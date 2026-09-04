# REST Customer API Integration Validation

## Purpose

This document records the local validation completed for the Project Phoenix Customer REST API.

The objective was to prove that the REST layer works as an actual HTTP service and that the modern Customer backend persists data in PostgreSQL.

## Environment

- Python: 3.14.6
- FastAPI: 0.141.1
- Uvicorn: 0.52.4
- PostgreSQL: 17
- PostgreSQL deployment: Docker container `phoenix-postgres`
- Database: `phoenix`
- API base path: `/api/v1`
- Backend configuration: `CUSTOMER_BACKEND=modern`

## Validation Results

### Service health

`GET /health`

Result:

- HTTP 200
- Service status `UP`

**PASS**

### Customer create

`POST /api/v1/customers`

Result:

- HTTP 201
- Customer identifier returned
- Customer data returned in the defined response structure

**PASS**

### Customer inquiry

`GET /api/v1/customers/{customerId}`

Result:

- HTTP 200 for an existing customer
- Persisted customer data returned

**PASS**

### Customer update

`PUT /api/v1/customers/{customerId}`

Result:

- HTTP 200
- Updated customer data returned

**PASS**

### Update persistence

A subsequent GET confirmed that the updated customer data remained persisted.

**PASS**

### Missing customer

`GET /api/v1/customers/DOESNOTEXIST`

Result:

- HTTP 404
- Error code `VR-CUST-005`
- Message `Customer not found`

**PASS**

### Invalid create request

A create request with an empty `firstName` was submitted.

Result:

- HTTP 400
- Error code `VR-CUST-002`
- Message `Validation Error`
- Validation details returned

**PASS**

### Missing customer update

`PUT /api/v1/customers/DOESNOTEXIST`

Result:

- HTTP 404
- Error code `VR-CUST-005`
- Message `Customer not found`

**PASS**

## Automated API Test Result

The automated REST test suite completed with:

**8 passed**

The test suite covers:

1. Health check
2. Customer creation
3. Existing customer retrieval
4. Customer update
5. Update persistence
6. Missing customer handling
7. Invalid request handling
8. Missing customer update handling

## Database Verification

The PostgreSQL `customers` table was queried directly after API testing.

Customer records created or updated through the REST API were present in PostgreSQL.

**PASS**

## Validated Modern Architecture

```text
HTTP Client / Swagger
        |
        v
FastAPI REST API
        |
        v
CustomerService
        |
        v
ModernCustomerAdapter
        |
        v
PostgreSQL
Legacy Integration Boundary

The application configuration provides the architectural backend-selection mechanism:

CUSTOMER_BACKEND=modern
        |
        v
ModernCustomerAdapter
        |
        v
PostgreSQL

The intended future legacy path is:

CUSTOMER_BACKEND=legacy
        |
        v
LegacyCustomerAdapter
        |
        v
z/OS Connect
        |
        v
CICS
        |
        v
COBOL
        |
        v
Customer Master

The legacy path is not yet considered implemented. It will be built and validated in the next development phase.

Acceptance

Sprint 6 modern REST/API baseline: ACCEPTED

The httpx / Starlette deprecation warning observed during pytest does not affect functional test results and is retained as a technical-debt item for later dependency cleanup.