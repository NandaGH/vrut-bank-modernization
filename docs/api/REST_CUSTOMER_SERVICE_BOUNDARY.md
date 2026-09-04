# Project Phoenix - REST to Customer Service Boundary

## 1. Purpose

This document defines the architectural boundary between the modern REST API
and the Customer business capability.

The boundary allows Project Phoenix to demonstrate both:

1. REST integration with the existing COBOL/CICS capability.
2. REST integration with a modern Customer microservice.

The consumer-facing API contract remains stable while the backend
implementation can evolve.

---

## 2. Architectural Principle

The REST API is the stable consumer boundary.

Consumers must not directly depend on:

- COBOL programs
- CICS transactions
- COMMAREA structures
- Indexed files
- PostgreSQL tables
- Internal microservice implementation classes

The implementation behind the API boundary may change without changing the
consumer contract.

---

## 3. Consumer Layer

The primary modern consumer is the digital channel.

The target demonstration may use an Angular frontend.

```text
Angular Frontend
       |
       | HTTPS / JSON
       v
Customer REST API

The Angular application consumes the REST contract only.

4. REST API Boundary

The Customer API exposes:

Operation	Method	Endpoint
Create Customer	POST	/api/v1/customers
Customer Inquiry	GET	/api/v1/customers/{customerId}
Update Customer	PUT	/api/v1/customers/{customerId}

The API boundary is responsible for:

HTTP handling
JSON handling
Authentication
Authorization
Request validation at the API boundary
Request mapping
Response mapping
HTTP status mapping
Error response formatting
Correlation information

Business rules remain outside the API transport layer.

5. Legacy Backend Boundary

The legacy-backed implementation uses:

REST API
   |
   v
z/OS Connect
   |
   v
CICS
   |
   v
COBOL Customer Capability
   |
   +--> VRCB0100
   |
   +--> VRCB0110
   |
   +--> VRCB0120
   |
   +--> VRCB0130
   |
   v
Customer Master

The z/OS Connect layer provides the integration boundary between the modern
REST contract and the CICS/COBOL capability.

The COBOL programs remain responsible for customer business processing.

6. Modern Backend Boundary

The modern implementation uses:

REST API
   |
   v
Customer Microservice
   |
   v
Customer Service
   |
   v
Customer Repository
   |
   v
PostgreSQL

The microservice implementation must preserve the Customer API contract.

The database schema is an internal implementation concern and must not be
exposed directly to the frontend.

7. Dual-Path Architecture

Project Phoenix will support the following conceptual execution paths.

Legacy Path
Angular
   |
REST
   |
API Boundary
   |
z/OS Connect
   |
CICS
   |
VRCB0100 / VRCB0130
   |
Customer Master
Modern Path
Angular
   |
REST
   |
API Boundary
   |
Customer Microservice
   |
Customer Repository
   |
PostgreSQL

Both paths implement the same customer business capabilities.

8. Backend Selection

Backend selection must remain an infrastructure or deployment concern.

The API consumer must not change its request or response format when the
backend changes.

Possible demonstration configurations include:

Configuration A
Angular
   |
REST
   |
z/OS Connect
   |
CICS / COBOL

and:

Configuration B
Angular
   |
REST
   |
Customer Microservice
   |
PostgreSQL

A later demonstration may also introduce an API gateway or routing layer
to select between backend implementations.

9. Authentication and Authorization

Authentication and authorization are API-level concerns.

The target API contract uses:

JWT authentication
Role-based authorization

The initial functional implementation may use a simplified local security
configuration for demonstration purposes.

Security must remain outside the COBOL business logic.

The COBOL programs should continue to receive business data through their
existing program interfaces rather than handling JWT tokens directly.

10. Error Boundary

Backend errors must be translated into the standard Phoenix REST error
model.

Example:

COBOL
VR-CUST-005
Customer not found
       |
       v
Integration / Service Layer
       |
       v
HTTP 404
       |
       v
JSON Error Response

The frontend should receive a consistent API error regardless of whether
the backend is legacy or modern.

11. Data Ownership
Legacy

Customer data is owned by the existing Customer Master implementation.

COBOL
  |
  v
Customer Master
Modern

Customer data is owned by the modern Customer Repository.

Customer Service
  |
  v
PostgreSQL

The REST API does not own persistence.

It exposes the business capability.

12. Transaction Boundary

Each customer operation must have a clear business transaction boundary.

For example:

POST Customer
      |
      v
Validate
      |
      v
Generate ID
      |
      v
Check duplicate
      |
      v
Persist
      |
      v
Return result

The transaction boundary must preserve the existing business semantics when
the legacy capability is used.

The modern implementation should provide equivalent business behaviour.

13. Observability Boundary

The REST boundary should provide common observability information.

Target capabilities include:

Correlation ID
Request logging
Response status logging
Processing duration
Backend identification
Error logging

A later sprint can implement centralized observability.

14. Deployment Independence

The API contract must remain independent of deployment topology.

Possible deployment:

Angular
   |
   v
API Gateway
   |
   v
Customer API
   |
   +--> z/OS Connect --> CICS --> COBOL
   |
   +--> Customer Service --> PostgreSQL

This allows Phoenix to demonstrate progressive modernization rather than
requiring a single-step replacement.

15. z/OS Connect Demonstration Goal

The final project should demonstrate a practical flow where a modern REST
request can reach the existing COBOL business capability through z/OS
Connect and CICS.

Example:

POST /api/v1/customers
       |
       v
JSON
       |
       v
z/OS Connect
       |
       v
CICS CUSTADD
       |
       v
VRCB0100
       |
       +--> VRCB0110
       |
       +--> VRCB0120
       |
       v
Customer Master
       |
       v
JSON Response

This is a core modernization demonstration objective.

16. Modern Replacement Demonstration Goal

The same consumer operation should eventually be demonstrable against the
modern service:

POST /api/v1/customers
       |
       v
Customer Microservice
       |
       v
Customer Repository
       |
       v
PostgreSQL
       |
       v
JSON Response

The frontend request remains unchanged.

17. Separation of Responsibilities
Layer	Responsibility
Angular	User interaction
REST API	Consumer contract
Security	Authentication / authorization
Mapper	Request / response translation
z/OS Connect	Legacy integration
CICS	Mainframe transaction boundary
COBOL	Legacy business processing
Microservice	Modern business processing
Repository	Modern persistence
PostgreSQL	Modern data storage
18. S6-04 Status

Status: Complete - REST-to-Customer-service boundary defined.

Next:

S6-05 - Define error and HTTP mapping.
