import httpx
import pytest

from app.adapters.legacy import (
    LegacyCustomerAdapter,
    LegacyCustomerConflictError,
    LegacyCustomerNotFoundError,
    LegacyCustomerUnavailableError,
)
from app.models.customer import (
    CustomerCreateRequest,
    CustomerUpdateRequest,
)


def make_response(status_code, json_data):
    return httpx.Response(
        status_code=status_code,
        json=json_data,
        request=httpx.Request("GET", "http://test"),
    )


def test_legacy_create_customer(monkeypatch):
    adapter = LegacyCustomerAdapter()

    captured = {}

    def fake_request(method, path, **kwargs):
        captured["method"] = method
        captured["path"] = path
        captured["json"] = kwargs["json"]

        return make_response(
            201,
            {
                "customerId": "0000000006",
                "message": "Customer created",
                "returnCode": 0,
                "severity": "S",
            },
        )

    monkeypatch.setattr(adapter, "_request", fake_request)

    request = CustomerCreateRequest(
        firstName="NANDAN",
        lastName="TEST",
        address="Phoenix Street",
        city="Chennai",
        state="TN",
        zipCode="600001",
    )

    result = adapter.create_customer(request)

    assert captured["method"] == "POST"
    assert captured["path"] == "/customers"
    assert captured["json"] == {
        "firstName": "NANDAN",
        "lastName": "TEST",
        "addressLine1": "Phoenix Street",
        "city": "Chennai",
        "state": "TN",
        "pinCode": "600001",
    }

    assert result.customerId == "0000000006"
    assert result.firstName == "NANDAN"


def test_legacy_get_customer(monkeypatch):
    adapter = LegacyCustomerAdapter()

    captured = {}

    def fake_request(method, path, **kwargs):
        captured["method"] = method
        captured["path"] = path

        return make_response(
            200,
            {
                "customerId": "0000000005",
                "firstName": "ARUN",
                "lastName": "KUMAR",
                "address": "Phoenix Street",
                "city": "Chennai",
                "state": "TN",
                "zipCode": "600001",
            },
        )

    monkeypatch.setattr(adapter, "_request", fake_request)

    result = adapter.get_customer("0000000005")

    assert captured["method"] == "GET"
    assert captured["path"] == "/customers/0000000005"
    assert result.customerId == "0000000005"
    assert result.firstName == "ARUN"


def test_legacy_update_customer(monkeypatch):
    adapter = LegacyCustomerAdapter()

    captured = {}

    def fake_request(method, path, **kwargs):
        captured["method"] = method
        captured["path"] = path
        captured["json"] = kwargs["json"]

        return make_response(
            200,
            {
                "customerId": "0000000005",
                "message": "Customer updated",
                "returnCode": 0,
                "severity": "S",
            },
        )

    monkeypatch.setattr(adapter, "_request", fake_request)

    request = CustomerUpdateRequest(
        firstName="ARUN-UPDATED",
        city="Chennai",
    )

    result = adapter.update_customer("0000000005", request)

    assert captured["method"] == "PUT"
    assert captured["path"] == "/customers/0000000005"
    assert captured["json"] == {
        "firstName": "ARUN-UPDATED",
        "city": "Chennai",
    }

    assert result.customerId == "0000000005"
    assert result.firstName == "ARUN-UPDATED"


def test_legacy_get_missing_customer(monkeypatch):
    adapter = LegacyCustomerAdapter()

    monkeypatch.setattr(
        adapter,
        "_request",
        lambda *args, **kwargs: make_response(
            404,
            {"message": "Customer not found"},
        ),
    )

    with pytest.raises(LegacyCustomerNotFoundError):
        adapter.get_customer("DOESNOTEXIST")


def test_legacy_create_duplicate_customer(monkeypatch):
    adapter = LegacyCustomerAdapter()

    monkeypatch.setattr(
        adapter,
        "_request",
        lambda *args, **kwargs: make_response(
            409,
            {"message": "Customer already exists"},
        ),
    )

    request = CustomerCreateRequest(
        firstName="NANDAN",
        lastName="TEST",
        address="Phoenix Street",
        city="Chennai",
        state="TN",
        zipCode="600001",
    )

    with pytest.raises(LegacyCustomerConflictError):
        adapter.create_customer(request)


def test_legacy_backend_unavailable(monkeypatch):
    adapter = LegacyCustomerAdapter()

    def fake_request(*args, **kwargs):
        raise LegacyCustomerUnavailableError(
            "Legacy z/OS Connect unavailable"
        )

    monkeypatch.setattr(adapter, "_request", fake_request)

    with pytest.raises(LegacyCustomerUnavailableError):
        adapter.get_customer("0000000005")
