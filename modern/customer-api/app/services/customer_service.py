from app.adapters.base import CustomerAdapter
from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)


class CustomerService:
    """
    Business/service boundary for Customer operations.

    The service depends only on the CustomerAdapter contract.
    """

    def __init__(self, adapter: CustomerAdapter):
        self.adapter = adapter

    def create_customer(
        self,
        request: CustomerCreateRequest,
    ) -> CustomerResponse:
        return self.adapter.create_customer(request)

    def get_customer(
        self,
        customer_id: str,
    ) -> CustomerResponse:
        return self.adapter.get_customer(customer_id)

    def update_customer(
        self,
        customer_id: str,
        request: CustomerUpdateRequest,
    ) -> CustomerResponse:
        return self.adapter.update_customer(customer_id, request)
