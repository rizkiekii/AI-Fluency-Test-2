def test_list_deployments_returns_seed_data(client):
    response = client.get("/api/v1/deployments")

    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 2
    ids = {item["id"] for item in body}
    assert "payment-api-payments" in ids
    assert "user-service-platform" in ids


def test_get_deployment_by_id_success(client):
    response = client.get("/api/v1/deployments/payment-api-payments")

    assert response.status_code == 200
    body = response.json()
    assert body["app_name"] == "payment-api"
    assert body["team"] == "payments"
    assert body["status"] == "approved"


def test_create_deployment_sets_pending_status(client):
    payload = {
        "app_name": "fraud-api",
        "team": "risk",
        "resource": {"cpu": "300m", "memory": "192Mi", "replicas": 2},
    }

    response = client.post("/api/v1/deployments", json=payload)

    assert response.status_code == 201
    body = response.json()
    assert body["id"] == "fraud-api-risk"
    assert body["status"] == "pending"
    assert body["resource"]["cpu"] == "300m"


def test_update_deployment_success_when_approved(client):
    payload = {
        "resource": {"cpu": "750m", "memory": "512Mi", "replicas": 4},
    }

    response = client.put("/api/v1/deployments/payment-api-payments", json=payload)

    assert response.status_code == 200
    body = response.json()
    assert body["resource"]["cpu"] == "750m"
    assert body["resource"]["memory"] == "512Mi"
    assert body["resource"]["replicas"] == 4


def test_update_deployment_rejected_when_not_approved(client):
    payload = {
        "resource": {"cpu": "500m", "memory": "256Mi", "replicas": 1},
    }

    response = client.put("/api/v1/deployments/user-service-platform", json=payload)

    assert response.status_code == 409
    assert "approved" in response.json()["detail"]


def test_delete_deployment_success(client):
    response = client.delete("/api/v1/deployments/user-service-platform")

    assert response.status_code == 204

    get_response = client.get("/api/v1/deployments/user-service-platform")
    assert get_response.status_code == 404


def test_approve_deployment_success(client):
    response = client.post("/api/v1/deployments/user-service-platform/approve")

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "approved"


def test_put_non_existing_deployment_returns_404(client):
    payload = {
        "resource": {"cpu": "100m", "memory": "128Mi", "replicas": 1},
    }

    response = client.put("/api/v1/deployments/does-not-exist-team", json=payload)

    assert response.status_code == 404


def test_approve_non_existing_deployment_returns_404(client):
    response = client.post("/api/v1/deployments/does-not-exist-team/approve")
    assert response.status_code == 404


def test_approve_already_approved_deployment_returns_409(client):
    response = client.post("/api/v1/deployments/payment-api-payments/approve")
    assert response.status_code == 409
