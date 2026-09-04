from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_check():
    response = client.get("/health")

    assert response.status_code == 200

    data = response.json()

    assert data["status"] == "UP"
    assert data["service"] == "customer-api"
    assert data["version"] == "1.0.0"


def test_create_customer():
    response = client.post(
        "/api/v1/customers",
        json={
            "firstName": "Test",
            "lastName": "Customer",
            "address": "Test Street",
            "city": "Chennai",
            "state": "TN",
            "zipCode": "600001",
        },
    )

    assert response.status_code == 201

    data = response.json()

    assert "customerId" in data
    assert data["customerId"].startswith("CUST")
    assert data["firstName"] == "Test"
    assert data["lastName"] == "Customer"
    assert data["address"] == "Test Street"
    assert data["city"] == "Chennai"
    assert data["state"] == "TN"
    assert data["zipCode"] == "600001"


def test_get_existing_customer():
    response = client.get("/api/v1/customers/CUST0002")

    assert response.status_code == 200

    data = response.json()

    assert data["customerId"] == "CUST0002"
    assert "firstName" in data
    assert "lastName" in data
    assert "address" in data
    assert "city" in data
    assert "state" in data
    assert "zipCode" in data


def test_update_customer():
    response = client.put(
        "/api/v1/customers/CUST0002",
        json={
            "firstName": "Automated Test",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert data["customerId"] == "CUST0002"
    assert data["firstName"] == "Automated Test"


def test_updated_customer_is_persisted():
    response = client.get("/api/v1/customers/CUST0002")

    assert response.status_code == 200

    data = response.json()

    assert data["customerId"] == "CUST0002"
    assert data["firstName"] == "Automated Test"


def test_get_missing_customer():
    response = client.get(
        "/api/v1/customers/DOESNOTEXIST"
    )

    assert response.status_code == 404

    data = response.json()

    assert data["detail"]["code"] == "VR-CUST-005"
    assert data["detail"]["message"] == "Customer not found"


def test_create_invalid_customer():
    response = client.post(
        "/api/v1/customers",
        json={
            "firstName": "",
            "lastName": "Customer",
            "address": "Test Street",
            "city": "Chennai",
            "state": "TN",
            "zipCode": "600001",
        },
    )

    assert response.status_code == 400

    data = response.json()

    assert data["code"] == "VR-CUST-002"
    assert data["message"] == "Validation Error"
    assert "details" in data


def test_update_missing_customer():
    response = client.put(
        "/api/v1/customers/DOESNOTEXIST",
        json={
            "firstName": "Nobody",
        },
    )

    assert response.status_code == 404

    data = response.json()

    assert data["detail"]["code"] == "VR-CUST-005"
    assert data["detail"]["message"] == "Customer not found"
