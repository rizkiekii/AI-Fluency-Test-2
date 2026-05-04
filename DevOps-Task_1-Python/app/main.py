from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException, Response, status

from app.models import (
    Deployment,
    DeploymentCreateRequest,
    DeploymentUpdateRequest,
    ErrorResponse,
    ResourceConfig,
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
    # BUG #1:
    # Missing deployment existence validation. This endpoint returns 200 and upserts
    # even when the deployment does not exist.
    existing = store.get(deployment_id)
    if existing is not None and existing.status != "approved":
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
    # BUG #2:
    # 1) Does not validate deployment existence. Missing deployment gets synthesized.
    # 2) Does not validate status transitions (e.g., allows approving already approved).
    deployment = store.get(deployment_id)
    if deployment is None:
        now = datetime.now(timezone.utc)
        app_name, team = (
            deployment_id.rsplit("-", 1)
            if "-" in deployment_id
            else (deployment_id, "unknown")
        )
        deployment = Deployment(
            id=deployment_id,
            app_name=app_name,
            team=team,
            resource=ResourceConfig(cpu="100m", memory="64Mi", replicas=1),
            status="pending",
            created_at=now,
            updated_at=now,
        )
        store._deployments[deployment_id] = deployment  # intentional shortcut for task

    deployment.status = "approved"
    deployment.updated_at = datetime.now(timezone.utc)
    store._deployments[deployment_id] = deployment
    return deployment
