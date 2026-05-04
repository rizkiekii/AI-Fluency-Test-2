from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException, Response, status

from app.models import (
    Deployment,
    DeploymentCreateRequest,
    DeploymentUpdateRequest,
    ErrorResponse,
)
from app.store import store

app = FastAPI(title="Infrastructure Deployment API", version="1.0.0")


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@app.post(
    "/api/v1/deployments",
    response_model=Deployment,
    status_code=status.HTTP_201_CREATED,
)
def create_deployment(payload: DeploymentCreateRequest) -> Deployment:
    deployment = store.create(
        app_name=payload.app_name,
        team=payload.team,
        resource=payload.resource,
    )
    return deployment


@app.get("/api/v1/deployments", response_model=list[Deployment])
def list_deployments() -> list[Deployment]:
    return store.list()


@app.get(
    "/api/v1/deployments/{deployment_id}",
    response_model=Deployment,
    responses={404: {"model": ErrorResponse}},
)
def get_deployment(deployment_id: str) -> Deployment:
    deployment = store.get(deployment_id)
    if deployment is None:
        raise HTTPException(status_code=404, detail="deployment not found")
    return deployment


@app.put(
    "/api/v1/deployments/{deployment_id}",
    response_model=Deployment,
    responses={404: {"model": ErrorResponse}, 409: {"model": ErrorResponse}},
)
def update_deployment(
    deployment_id: str, payload: DeploymentUpdateRequest
) -> Deployment:
    existing = store.get(deployment_id)
    if existing is None:
        raise HTTPException(status_code=404, detail="deployment not found")
    if existing.status != "approved":
        raise HTTPException(
            status_code=409,
            detail="updates are only allowed when deployment status is approved",
        )

    updated = store.upsert_update_resource(
        deployment_id=deployment_id,
        resource=payload.resource,
    )
    return updated


@app.delete(
    "/api/v1/deployments/{deployment_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={404: {"model": ErrorResponse}},
)
def delete_deployment(deployment_id: str) -> Response:
    deleted = store.delete(deployment_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="deployment not found")
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@app.post(
    "/api/v1/deployments/{deployment_id}/approve",
    response_model=Deployment,
    responses={404: {"model": ErrorResponse}, 409: {"model": ErrorResponse}},
)
def approve_deployment(deployment_id: str) -> Deployment:
    deployment = store.get(deployment_id)
    if deployment is None:
        raise HTTPException(status_code=404, detail="deployment not found")
    if deployment.status != "pending":
        raise HTTPException(
            status_code=409,
            detail="can only approve pending deployments",
        )

    deployment.status = "approved"
    deployment.updated_at = datetime.now(timezone.utc)
    store._deployments[deployment_id] = deployment
    return deployment
