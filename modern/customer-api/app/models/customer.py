from pydantic import BaseModel, Field


class CustomerCreateRequest(BaseModel):
    firstName: str = Field(min_length=1, max_length=40)
    lastName: str = Field(min_length=1, max_length=40)
    address: str = Field(min_length=1, max_length=100)
    city: str = Field(min_length=1, max_length=40)
    state: str = Field(min_length=1, max_length=2)
    zipCode: str = Field(min_length=1, max_length=10)


class CustomerUpdateRequest(BaseModel):
    firstName: str | None = Field(default=None, min_length=1, max_length=40)
    lastName: str | None = Field(default=None, min_length=1, max_length=40)
    address: str | None = Field(default=None, min_length=1, max_length=100)
    city: str | None = Field(default=None, min_length=1, max_length=40)
    state: str | None = Field(default=None, min_length=1, max_length=2)
    zipCode: str | None = Field(default=None, min_length=1, max_length=10)


class CustomerResponse(BaseModel):
    customerId: str
    firstName: str
    lastName: str
    address: str
    city: str
    state: str
    zipCode: str


class ErrorResponse(BaseModel):
    errorCode: str
    message: str
