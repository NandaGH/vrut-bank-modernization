from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app.api.customer import router as customer_router


app = FastAPI(
    title="Project Phoenix Customer API",
    description="Modern REST interface for the Phoenix Customer capability.",
    version="1.0.0",
)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
    request: Request,
    exc: RequestValidationError,
):
    return JSONResponse(
        status_code=400,
        content={
            "code": "VR-CUST-002",
            "message": "Validation Error",
            "details": exc.errors(),
        },
    )


@app.get("/health")
def health_check():
    return {
        "status": "UP",
        "service": "customer-api",
        "version": "1.0.0",
    }


app.include_router(customer_router)