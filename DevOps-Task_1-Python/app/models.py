from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


DeploymentStatus = Literal["pending", "approved", "deployed"]


class ResourceConfig(BaseModel):
    cpu: str = Field(..., examples=["500m"])
    memory: str = Field(..., examples=["256Mi"])
    replicas: int = Field(..., ge=1, examples=[3])


class DeploymentCreateRequest(BaseModel):
    app_name: str
    team: str
    resource: ResourceConfig


class DeploymentUpdateRequest(BaseModel):
    resource: ResourceConfig


class Deployment(BaseModel):
    id: str
    app_name: str
    team: str
    resource: ResourceConfig
    status: DeploymentStatus
    created_at: datetime
    updated_at: datetime


class ErrorResponse(BaseModel):
    message: str
