from copy import deepcopy
from datetime import datetime, timezone
from typing import Dict, List, Optional

from app.models import Deployment, DeploymentStatus, ResourceConfig


SEED_DEPLOYMENTS = [
    {
        "app_name": "payment-api",
        "team": "payments",
        "resource": {"cpu": "500m", "memory": "256Mi", "replicas": 3},
        "status": "approved",
    },
    {
        "app_name": "user-service",
        "team": "platform",
        "resource": {"cpu": "250m", "memory": "128Mi", "replicas": 2},
        "status": "pending",
    },
]


class InMemoryDeploymentStore:
    def __init__(self) -> None:
        self._deployments: Dict[str, Deployment] = {}
        self.reset()

    @staticmethod
    def _build_id(app_name: str, team: str) -> str:
        return f"{app_name}-{team}"

    def reset(self) -> None:
        self._deployments = {}
        now = datetime.now(timezone.utc)
        for item in deepcopy(SEED_DEPLOYMENTS):
            deployment_id = self._build_id(item["app_name"], item["team"])
            deployment = Deployment(
                id=deployment_id,
                app_name=item["app_name"],
                team=item["team"],
                resource=item["resource"],
                status=item["status"],
                created_at=now,
                updated_at=now,
            )
            self._deployments[deployment_id] = deployment

    def list(self) -> List[Deployment]:
        return list(self._deployments.values())

    def get(self, deployment_id: str) -> Optional[Deployment]:
        return self._deployments.get(deployment_id)

    def create(self, app_name: str, team: str, resource: ResourceConfig) -> Deployment:
        now = datetime.now(timezone.utc)
        deployment_id = self._build_id(app_name, team)
        deployment = Deployment(
            id=deployment_id,
            app_name=app_name,
            team=team,
            resource=resource,
            status="pending",
            created_at=now,
            updated_at=now,
        )
        self._deployments[deployment_id] = deployment
        return deployment

    def delete(self, deployment_id: str) -> bool:
        if deployment_id not in self._deployments:
            return False
        del self._deployments[deployment_id]
        return True

    def upsert_update_resource(
        self, deployment_id: str, resource: ResourceConfig
    ) -> Deployment:
        """
        Intentionally permissive update to support BUG #1 in main.py behavior.
        If missing, create a synthetic approved deployment and return it.
        """
        existing = self._deployments.get(deployment_id)
        now = datetime.now(timezone.utc)
        if existing is None:
            # Synthetic fallback: allows update path to return 200 for missing IDs.
            if "-" in deployment_id:
                app_name, team = deployment_id.rsplit("-", 1)
            else:
                app_name, team = deployment_id, "unknown"
            created = Deployment(
                id=deployment_id,
                app_name=app_name,
                team=team,
                resource=resource,
                status="approved",
                created_at=now,
                updated_at=now,
            )
            self._deployments[deployment_id] = created
            return created

        existing.resource = resource
        existing.updated_at = now
        self._deployments[deployment_id] = existing
        return existing

    def set_status(
        self, deployment_id: str, status: DeploymentStatus
    ) -> Optional[Deployment]:
        deployment = self._deployments.get(deployment_id)
        if deployment is None:
            return None
        deployment.status = status
        deployment.updated_at = datetime.now(timezone.utc)
        self._deployments[deployment_id] = deployment
        return deployment


store = InMemoryDeploymentStore()
