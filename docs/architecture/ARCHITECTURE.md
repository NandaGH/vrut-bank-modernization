# VRUT Bank Modernization Architecture

## 1. Purpose

Project Phoenix modernizes a legacy VRUT Bank customer-management capability while preserving the existing COBOL business logic and customer data path.

The application exposes a stable REST API to consumers while allowing the backend implementation to be switched between a modern PostgreSQL implementation and a legacy z/OS implementation.

## 2. High-Level Architecture

```text
                         VRUT BANK
                            │
                         Angular
                            │
                            ▼
                     REST API Boundary
                            │
                 ┌──────────┴──────────┐
                 │                     │
          Modern Backend          Legacy Backend
                 │                     │
                 ▼                     ▼
        Customer Adapter       Legacy Customer Adapter
                 │                     │
                 ▼                     ▼
            PostgreSQL          z/OS Connect
                                       │
                                       ▼
                                      CICS
                                       │
                                       ▼
                                     COBOL
                                       │
                                       ▼
                                Customer Master
3. Backend Selection

The REST API consumer does not need to know which backend is active.

Backend selection is controlled by application configuration:

CUSTOMER_BACKEND=modern
CUSTOMER_BACKEND=legacy
Modern path
Angular
  → REST API
  → ModernCustomerAdapter
  → PostgreSQL
Legacy path
Angular
  → REST API
  → LegacyCustomerAdapter
  → z/OS Connect
  → CICS
  → COBOL
  → Customer Master
4. API Boundary

The REST API is the stable application boundary.

Current customer operations:

POST /api/v1/customers
GET /api/v1/customers/{customerId}
PUT /api/v1/customers/{customerId}

The Angular application will consume this boundary rather than accessing PostgreSQL, COBOL, CICS, or z/OS Connect directly.

5. Legacy Integration

The legacy integration uses IBM z/OS Connect as the REST-to-CICS integration layer.

The z/OS Connect workspace contains API/provider assets for:

VRCB0100 customer add/update
VRCB0130 customer inquiry

The local development environment demonstrates the z/OS Connect API provider configuration and CICS invocation path.

A live CICS region is an external runtime prerequisite for executing the COBOL path end-to-end.

6. Modernization Principle

The modernization separates:

presentation
REST API contract
backend adapter
system of record

This allows the customer-facing application to remain stable while backend implementation evolves.

7. Observability Goal

The final demonstration should make the request path understandable:

Angular
  → REST API
  → Selected backend
  → System of record

For the legacy path, the trace should additionally show:

z/OS Connect
  → CICS
  → COBOL