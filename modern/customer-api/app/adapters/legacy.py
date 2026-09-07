import httpx

from app.adapters.base import CustomerAdapter
from app.core.config import settings
from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)


class LegacyBackendError(ValueError):
    """Base error for the legacy z/OS Connect backend."""


class LegacyCustomerNotFoundError(LegacyBackendError):
    """Customer does not exist in the legacy backend."""


class LegacyCustomerConflictError(LegacyBackendError):
    """Customer already exists in the legacy backend."""


class LegacyCustomerBadRequestError(LegacyBackendError):
    """Legacy backend rejected the supplied customer data."""


class LegacyCustomerUnavailableError(LegacyBackendError):
    """z/OS Connect or the downstream legacy system is unavailable."""


class LegacyCustomerError(LegacyBackendError):
    """Unexpected error returned by the legacy backend."""


class LegacyCustomerAdapter(CustomerAdapter):
    """
    Customer backend adapter for the legacy z/OS path.

    Application model
        ↓
    z/OS Connect REST API
        ↓
    CICS
        ↓
    COBOL
    """

    def __init__(self):
        self.base_url = settings.zos_connect_base_url.rstrip("/")
        self.timeout = settings.zos_connect_timeout
        self.verify_tls = settings.zos_connect_verify_tls

    def create_customer(
        self,
        request: CustomerCreateRequest,
    ) -> CustomerResponse:
        payload = {
            "firstName": request.firstName,
            "lastName": request.lastName,
            "addressLine1": request.address,
            "city": request.city,
            "state": request.state,
            "pinCode": request.zipCode,
        }

        response = self._request(
            "POST",
            "/customers",
            json=payload,
        )

        data = response.json()
        self._raise_for_legacy_error(response, data)

        return CustomerResponse(
            customerId=data.get("customerId", ""),
            firstName=request.firstName,
            lastName=request.lastName,
            address=request.address,
            city=request.city,
            state=request.state,
            zipCode=request.zipCode,
        )

    def get_customer(
        self,
        customer_id: str,
    ) -> CustomerResponse:
        response = self._request(
            "GET",
            f"/customers/{customer_id}",
        )

        data = response.json()
        self._raise_for_legacy_error(response, data)

        return CustomerResponse(
            customerId=data["customerId"],
            firstName=data.get("firstName", ""),
            lastName=data.get("lastName", ""),
            address=data.get("address", ""),
            city=data.get("city", ""),
            state=data.get("state", ""),
            zipCode=data.get("zipCode", ""),
        )

    def update_customer(
        self,
        customer_id: str,
        request: CustomerUpdateRequest,
    ) -> CustomerResponse:
        payload = {
            key: value
            for key, value in {
                "firstName": request.firstName,
                "lastName": request.lastName,
                "addressLine1": request.address,
                "city": request.city,
                "state": request.state,
                "pinCode": request.zipCode,
            }.items()
            if value is not None
        }

        response = self._request(
            "PUT",
            f"/customers/{customer_id}",
            json=payload,
        )

        data = response.json()
        self._raise_for_legacy_error(response, data)

        return CustomerResponse(
            customerId=data.get("customerId", customer_id),
            firstName=request.firstName or "",
            lastName=request.lastName or "",
            address=request.address or "",
            city=request.city or "",
            state=request.state or "",
            zipCode=request.zipCode or "",
        )

    def _request(
        self,
        method: str,
        path: str,
        **kwargs,
    ) -> httpx.Response:
        url = f"{self.base_url}{path}"

        try:
            with httpx.Client(
                timeout=self.timeout,
                verify=self.verify_tls,
            ) as client:
                return client.request(
                    method,
                    url,
                    **kwargs,
                )
        except httpx.RequestError as exc:
            raise LegacyCustomerUnavailableError(
                f"Legacy z/OS Connect unavailable: {exc}"
            ) from exc

    @staticmethod
    def _raise_for_legacy_error(
        response: httpx.Response,
        data: dict,
    ) -> None:
        if response.status_code < 400:
            return

        if response.status_code == 409:
            raise LegacyCustomerConflictError(
                "Customer already exists"
            )

        if response.status_code == 404:
            raise LegacyCustomerNotFoundError(
                "Customer not found"
            )

        if response.status_code == 400:
            raise LegacyCustomerBadRequestError(
                "Invalid customer data"
            )

        message = (
            data.get("message")
            or data.get("detail")
            or f"Legacy backend returned HTTP {response.status_code}"
        )

        raise LegacyCustomerError(message)


class LegacyCustomerError(LegacyBackendError):
    """Unexpected error returned by the legacy backend."""
