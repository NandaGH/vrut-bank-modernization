# Project Phoenix - REST Wrapper Design

## 1. Purpose

This document defines the design of the Customer REST wrapper.

The wrapper provides a stable REST interface while allowing the Customer
business capability to be implemented through either:

- The existing COBOL/CICS capability accessed through z/OS Connect.
- A modern Customer microservice backed by PostgreSQL.

---

## 2. Design Objective

The REST layer must isolate consumer-facing API concerns from backend
implementation concerns.

The API consumer must not know whether the request is processed by the
legacy or modern backend.

---

## 3. Target Architecture

```text
Angular / API Client
          |
          | HTTPS / JSON
          v
+---------------------------+
| Customer REST API         |
| FastAPI                   |
+-------------+-------------+
              |
              v
+---------------------------+
| Customer Service Boundary |
+-------------+-------------+
              |
       +------+------+
       |             |
       v             v
Legacy Adapter   Modern Adapter
       |             |
       v             v
z/OS Connect     Customer Service
       |             |
       v             v
CICS             Repository
       |             |
       v             v
COBOL           PostgreSQL
4. REST Layer Responsibilities

The REST wrapper is responsible for:

HTTP endpoint handling
JSON request parsing
JSON response serialization
API request validation
Authentication integration
Authorization integration
Request mapping
Response mapping
HTTP status mapping
Error response formatting
Correlation ID handling
Backend selection

The REST wrapper must not contain legacy business rules.

5. Customer Service Boundary

The Customer Service boundary represents the business capability independently
of its implementation.

Conceptually:

CustomerService
      |
      +--> create_customer()
      |
      +--> get_customer()
      |
      +--> update_customer()

The interface represents business operations rather than HTTP operations.

6. Backend Adapter Pattern

The Customer Service boundary delegates execution to a backend adapter.

CustomerService
      |
      +--> LegacyCustomerAdapter
      |
      +--> ModernCustomerAdapter
Legacy Adapter
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
Modern Adapter
ModernCustomerAdapter
        |
        v
Customer Service
        |
        v
Customer Repository
        |
        v
PostgreSQL
7. Create Customer Flow
POST /api/v1/customers
        |
        v
Request Model
        |
        v
Customer Service
        |
        +-----------------------+
        |                       |
        v                       v
Legacy Adapter           Modern Adapter
        |                       |
        v                       v
z/OS Connect             PostgreSQL Service
        |                       |
        v                       v
VRCB0100                  Customer Repository
        |                       |
        +-----------+-----------+
                    |
                    v
              Business Result
                    |
                    v
             Response Mapper
                    |
                    v
               HTTP 201
8. Customer Inquiry Flow
GET /api/v1/customers/{customerId}
              |
              v
        Request Validation
              |
              v
       Customer Service
              |
       +------+------+
       |             |
       v             v
 Legacy Adapter   Modern Adapter
       |             |
       v             v
 VRCB0130       Customer Repository
       |             |
       +------+------+
              |
              v
        Customer Result
              |
              v
        Response Mapper
              |
              v
           HTTP 200
9. Customer Update Flow
PUT /api/v1/customers/{customerId}
              |
              v
        Request Validation
              |
              v
       Customer Service
              |
       +------+------+
       |             |
       v             v
 Legacy Adapter   Modern Adapter
       |             |
       v             v
 VRCB0100       Customer Repository
       |             |
       +------+------+
              |
              v
        Business Result
              |
              v
        Response Mapper
              |
              v
           HTTP 200
10. Request Processing Pipeline

Every request follows this logical pipeline:

1. Receive HTTP request
2. Authenticate caller
3. Authorize operation
4. Validate API request
5. Map JSON to business request
6. Select backend
7. Invoke Customer Service
8. Receive business result
9. Map business result
10. Generate HTTP response
11. Response Processing Pipeline
Backend Result
      |
      v
Business Result
      |
      v
Response Mapper
      |
      +--> Success response
      |
      +--> Error response
      |
      v
HTTP Response
12. Backend Selection

Backend selection is not exposed to the API consumer.

Possible deployment configurations:

Legacy Demonstration
Customer API
     |
     v
Legacy Adapter
     |
     v
z/OS Connect
     |
     v
CICS
     |
     v
COBOL
Modern Demonstration
Customer API
     |
     v
Modern Adapter
     |
     v
Customer Microservice
     |
     v
PostgreSQL

A configuration setting may determine the active backend.

The API contract remains unchanged.

13. Request Models

REST request models represent the API contract.

They must not directly expose COBOL copybook structures.

Example:

CustomerCreateRequest
CustomerUpdateRequest

These models are mapped internally to the Customer business model.

14. Response Models

REST response models represent the API contract.

Examples:

CustomerResponse
CustomerCreateResponse
CustomerUpdateResponse
ErrorResponse

Internal backend response structures must not be returned directly to the
consumer.

15. Error Handling

The wrapper uses the standard Phoenix error mapping.

Backend Error
      |
      v
Error Mapper
      |
      +--> 400 Validation
      +--> 401 Authentication
      +--> 403 Authorization
      +--> 404 Customer Not Found
      +--> 409 Duplicate
      +--> 500 Internal Error

The mapping defined in:

docs/api/CUSTOMER_ERROR_HTTP_MAPPING.md

is authoritative for HTTP error semantics.

16. Authentication

Authentication is performed at the REST boundary.

The initial implementation uses JWT-based authentication.

JWT tokens must not be passed into COBOL business programs.

The legacy backend receives only the business request required by the
Customer capability.

17. Authorization

Authorization is performed after authentication.

Role-based permissions determine whether the caller may perform:

CREATE_CUSTOMER
INQUIRE_CUSTOMER
UPDATE_CUSTOMER

Authorization decisions remain outside COBOL business logic.

18. OpenAPI

FastAPI will generate an OpenAPI specification from the REST endpoint and
request/response definitions.

The OpenAPI specification will provide:

Endpoint definitions
HTTP methods
Request schemas
Response schemas
Error schemas
Authentication requirements

This specification will also support the future z/OS Connect integration
demonstration.

19. Swagger Demonstration

The local REST implementation should expose interactive API documentation.

Target demonstration:

Browser
   |
   v
Swagger UI
   |
   v
Customer REST API

The demonstration should allow the presenter to execute:

Create Customer
Customer Inquiry
Customer Update
Validation error
Customer not found
Duplicate customer
20. Configuration

Backend selection must be configuration-driven.

Conceptual configuration:

CUSTOMER_BACKEND=legacy

or:

CUSTOMER_BACKEND=modern

The API consumer does not change.

The configuration mechanism will be implemented during the REST wrapper
implementation sprint.

21. Local Development

The initial local implementation will use:

FastAPI
Python
Uvicorn

The application will be structured so it can later run inside Docker.

22. Containerization

The REST wrapper will be container-ready.

Target:

Docker
   |
   v
Customer REST API

The container must receive backend selection and integration settings through
environment configuration rather than hard-coded values.

23. z/OS Connect Integration

The legacy adapter will eventually communicate with z/OS Connect.

Target:

FastAPI
   |
   v
Legacy Customer Adapter
   |
   v
z/OS Connect REST endpoint
   |
   v
CICS
   |
   v
VRCB0100 / VRCB0130

The z/OS Connect endpoint details will be configured separately from the
Customer API contract.

24. Modern Backend Integration

The modern adapter will eventually communicate with the modern Customer
Service.

Target:

FastAPI
   |
   v
Modern Customer Adapter
   |
   v
Customer Microservice
   |
   v
PostgreSQL

The modern database remains behind the service boundary.

25. Observability

The wrapper should support:

Correlation ID
Request logging
Response status logging
Backend identification
Processing duration
Error logging

Detailed observability implementation is deferred to a later sprint.

26. Testing Strategy

The wrapper design supports testing at several levels:

Unit Test
   |
   v
API Test
   |
   v
Backend Adapter Test
   |
   v
Integration Test
   |
   v
End-to-End Test

The first implementation sprint will focus on local API and adapter testing.

27. Demonstration Architecture

The final demonstration should show the same API request executing through
both backend implementations.

Legacy
Angular
  |
  v
REST API
  |
  v
Legacy Adapter
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
Modern
Angular
  |
  v
REST API
  |
  v
Modern Adapter
  |
  v
Customer Microservice
  |
  v
PostgreSQL

The frontend request remains unchanged.

28. Design Principles
API contract remains stable.
Backend implementation remains replaceable.
COBOL business rules remain outside REST transport code.
Security remains outside COBOL business logic.
Legacy integration is isolated in an adapter.
Modern persistence is isolated behind a service/repository boundary.
Configuration controls backend selection.
OpenAPI remains the machine-readable API contract.
The implementation must be container-ready.
Both legacy and modern execution paths must be demonstrable.
29. S6-06 Status

Status: Complete - REST wrapper design defined.

Next:

S6-07 - Implement REST wrapper.
