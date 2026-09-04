from app.adapters.base import CustomerAdapter
from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)


class InMemoryCustomerAdapter(CustomerAdapter):
    """
    Temporary adapter used to validate the backend abstraction.

    This will later be replaced by the real modern and legacy adapters.
    """

    def __init__(self):
        self._customers: dict[str, CustomerResponse] = {}

    def create_customer(
        self,
        request: CustomerCreateRequest,
    ) -> CustomerResponse:
        customer_id = "DEMO001"

        customer = CustomerResponse(
            customerId=customer_id,
            firstName=request.firstName,
            lastName=request.lastName,
            address=request.address,
            city=request.city,
            state=request.state,
            zipCode=request.zipCode,
        )

        self._customers[customer_id] = customer
        return customer

    def get_customer(
        self,
        customer_id: str,
    ) -> CustomerResponse:
        customer = self._customers.get(customer_id)

        if customer:
            return customer

        return CustomerResponse(
            customerId=customer_id,
            firstName="Demo",
            lastName="Customer",
            address="Demo Address",
            city="Demo City",
            state="CA",
            zipCode="00000",
        )

    def update_customer(
        self,
        customer_id: str,
        request: CustomerUpdateRequest,
    ) -> CustomerResponse:
        existing = self._customers.get(customer_id)

        if existing:
            updated = CustomerResponse(
                customerId=customer_id,
                firstName=request.firstName or existing.firstName,
                lastName=request.lastName or existing.lastName,
                address=request.address or existing.address,
                city=request.city or existing.city,
                state=request.state or existing.state,
                zipCode=request.zipCode or existing.zipCode,
            )
        else:
            updated = CustomerResponse(
                customerId=customer_id,
                firstName=request.firstName or "Demo",
                lastName=request.lastName or "Customer",
                address=request.address or "Demo Address",
                city=request.city or "Demo City",
                state=request.state or "CA",
                zipCode=request.zipCode or "00000",
            )

        self._customers[customer_id] = updated
        return updated
