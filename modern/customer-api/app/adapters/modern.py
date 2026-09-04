import os

import psycopg

from app.adapters.base import CustomerAdapter
from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)


class ModernCustomerAdapter(CustomerAdapter):
    """
    PostgreSQL-backed implementation of the CustomerAdapter contract.
    """

    def __init__(self):
        self.database_url = os.getenv(
            "DATABASE_URL",
            "postgresql://phoenix:phoenix_dev@localhost:5432/phoenix",
        )

    def create_customer(
        self,
        request: CustomerCreateRequest,
    ) -> CustomerResponse:
        customer_id = self._generate_customer_id()

        with psycopg.connect(self.database_url) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO customers (
                        customer_id,
                        first_name,
                        last_name,
                        address,
                        city,
                        state,
                        zip_code
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    """,
                    (
                        customer_id,
                        request.firstName,
                        request.lastName,
                        request.address,
                        request.city,
                        request.state,
                        request.zipCode,
                    ),
                )

        return CustomerResponse(
            customerId=customer_id,
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
        with psycopg.connect(self.database_url) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT
                        customer_id,
                        first_name,
                        last_name,
                        address,
                        city,
                        state,
                        zip_code
                    FROM customers
                    WHERE customer_id = %s
                    """,
                    (customer_id,),
                )

                row = cursor.fetchone()

        if row is None:
            raise ValueError(f"Customer {customer_id} not found")

        return CustomerResponse(
            customerId=row[0],
            firstName=row[1],
            lastName=row[2],
            address=row[3],
            city=row[4],
            state=row[5],
            zipCode=row[6],
        )

    def update_customer(
        self,
        customer_id: str,
        request: CustomerUpdateRequest,
    ) -> CustomerResponse:
        current = self.get_customer(customer_id)

        updated = CustomerResponse(
            customerId=customer_id,
            firstName=request.firstName or current.firstName,
            lastName=request.lastName or current.lastName,
            address=request.address or current.address,
            city=request.city or current.city,
            state=request.state or current.state,
            zipCode=request.zipCode or current.zipCode,
        )

        with psycopg.connect(self.database_url) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    UPDATE customers
                    SET
                        first_name = %s,
                        last_name = %s,
                        address = %s,
                        city = %s,
                        state = %s,
                        zip_code = %s
                    WHERE customer_id = %s
                    """,
                    (
                        updated.firstName,
                        updated.lastName,
                        updated.address,
                        updated.city,
                        updated.state,
                        updated.zipCode,
                        customer_id,
                    ),
                )

        return updated

    def _generate_customer_id(self) -> str:
        with psycopg.connect(self.database_url) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT COALESCE(
                        MAX(
                            CAST(
                                SUBSTRING(customer_id FROM 5)
                                AS INTEGER
                            )
                        ),
                        0
                    ) + 1
                    FROM customers
                    WHERE customer_id LIKE 'CUST%'
                    """
                )

                next_number = cursor.fetchone()[0]

        return f"CUST{next_number:04d}"
