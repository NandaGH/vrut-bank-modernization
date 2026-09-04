from abc import ABC, abstractmethod

from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)


class CustomerAdapter(ABC):
    """
    Common backend contract for Customer operations.

    Any Customer backend, legacy or modern, must implement
    these operations.
    """

    @abstractmethod
    def create_customer(
        self,
        request: CustomerCreateRequest,
    ) -> CustomerResponse:
        """Create a customer in the backend."""
        raise NotImplementedError

    @abstractmethod
    def get_customer(
        self,
        customer_id: str,
    ) -> CustomerResponse:
        """Retrieve a customer from the backend."""
        raise NotImplementedError

    @abstractmethod
    def update_customer(
        self,
        customer_id: str,
        request: CustomerUpdateRequest,
    ) -> CustomerResponse:
        """Update a customer in the backend."""
        raise NotImplementedError
