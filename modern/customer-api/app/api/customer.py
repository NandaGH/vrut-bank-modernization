from fastapi import APIRouter, HTTPException, status

from app.adapters.in_memory import InMemoryCustomerAdapter
from app.adapters.legacy import (
    LegacyCustomerAdapter,
    LegacyCustomerBadRequestError,
    LegacyCustomerConflictError,
    LegacyCustomerError,
    LegacyCustomerNotFoundError,
    LegacyCustomerUnavailableError,
)
from app.adapters.modern import ModernCustomerAdapter
from app.core.config import settings
from app.models.customer import (
    CustomerCreateRequest,
    CustomerResponse,
    CustomerUpdateRequest,
)
from app.services.customer_service import CustomerService


router = APIRouter(
    prefix="/api/v1/customers",
    tags=["Customers"],
)


def create_customer_adapter():
    if settings.customer_backend == "modern":
        return ModernCustomerAdapter()

    if settings.customer_backend == "memory":
        return InMemoryCustomerAdapter()

    if settings.customer_backend == "legacy":
        return LegacyCustomerAdapter()

    raise ValueError(
        f"Unsupported CUSTOMER_BACKEND: {settings.customer_backend}"
    )


customer_service = CustomerService(
    adapter=create_customer_adapter()
)


@router.post(
    "",
    response_model=CustomerResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_customer(request: CustomerCreateRequest):
    try:
        return customer_service.create_customer(request)
    except LegacyCustomerConflictError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "code": "VR-CUST-001",
                "message": "Customer Already Exists",
            },
        )
    except LegacyCustomerBadRequestError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "code": "VR-CUST-002",
                "message": str(exc),
            },
        )
    except LegacyCustomerUnavailableError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "code": "VR-CUST-502",
                "message": str(exc),
            },
        )
    except ValueError as exc:
        message = str(exc)

        if "already exists" in message.lower():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail={
                    "code": "VR-CUST-001",
                    "message": "Customer Already Exists",
                },
            )

        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "code": "VR-CUST-002",
                "message": message,
            },
        )


@router.get(
    "/{customerId}",
    response_model=CustomerResponse,
)
def get_customer(customerId: str):
    try:
        return customer_service.get_customer(customerId)
    except LegacyCustomerNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "code": "VR-CUST-005",
                "message": "Customer not found",
            },
        )
    except LegacyCustomerUnavailableError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "code": "VR-CUST-502",
                "message": str(exc),
            },
        )
    except LegacyCustomerError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "code": "VR-CUST-500",
                "message": str(exc),
            },
        )
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "code": "VR-CUST-005",
                "message": "Customer not found",
            },
        )


@router.put(
    "/{customerId}",
    response_model=CustomerResponse,
)
def update_customer(
    customerId: str,
    request: CustomerUpdateRequest,
):
    try:
        return customer_service.update_customer(
            customerId,
            request,
        )
    except LegacyCustomerNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "code": "VR-CUST-005",
                "message": "Customer not found",
            },
        )
    except LegacyCustomerBadRequestError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "code": "VR-CUST-004",
                "message": str(exc),
            },
        )
    except LegacyCustomerUnavailableError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "code": "VR-CUST-502",
                "message": str(exc),
            },
        )
    except LegacyCustomerError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "code": "VR-CUST-500",
                "message": str(exc),
            },
        )
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "code": "VR-CUST-005",
                "message": "Customer not found",
            },
        )

