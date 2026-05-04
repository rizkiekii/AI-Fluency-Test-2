import pytest
from fastapi.testclient import TestClient

from app.store import store
from solution.main import app


@pytest.fixture(autouse=True)
def reset_store() -> None:
    store.reset()


@pytest.fixture
def client():
    """Test client using FastAPI's official TestClient pattern."""
    return TestClient(app)
