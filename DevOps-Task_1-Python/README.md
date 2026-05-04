# Infrastructure Deployment API (Python)

Runnable FastAPI baseline for the DevOps assessment task.

## What Is Included

- A single FastAPI app with deployment endpoints in `app/main.py`
- Pydantic models in `app/models.py`
- In-memory storage and canonical seed data in `app/store.py`
- Pytest suite in `tests/` with intentionally failing bug-focused tests

## Prerequisites

- Python `3.11+`

## Setup And Run

From this folder:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8585
```

Service URL:

- `http://localhost:8585`

Health check:

```bash
curl http://localhost:8585/healthz
```

## Run Tests

```bash
pytest tests/ -v
```

## Seed Data

The in-memory store resets to the following deployments:

```python
SEED_DEPLOYMENTS = [
    {
        "app_name": "payment-api",
        "team": "payments",
        "resource": {"cpu": "500m", "memory": "256Mi", "replicas": 3},
        "status": "approved"
    },
    {
        "app_name": "user-service",
        "team": "platform",
        "resource": {"cpu": "250m", "memory": "128Mi", "replicas": 2},
        "status": "pending"
    }
]
```

Generated IDs use: `{app_name}-{team}`.

## Important Note

Some tests are intentionally failing. They represent known defects that candidates are expected to diagnose and fix.
