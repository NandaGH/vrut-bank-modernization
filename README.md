Project Phoenix - VRUT Bank Modernization

Project Phoenix is a practical banking modernization demonstration showing how a legacy COBOL customer-management capability can coexist with a modern application architecture.

Architecture
                         VRUT BANK
                            │
                         Angular
                            │
                            ▼
                     REST API Boundary
                            │
                 ┌──────────┴──────────┐
                 │                     │
              Modern                Legacy
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
Current Capabilities
COBOL customer add
COBOL customer inquiry
COBOL customer update
Customer Master persistence
CICS interface programs
REST API
Modern backend adapter
Legacy z/OS Connect adapter
Backend switching
z/OS Connect API/provider assets
Automated Python API tests
Backend Switching

The REST API can select the customer backend through configuration:

CUSTOMER_BACKEND=modern

or:

CUSTOMER_BACKEND=legacy

The frontend remains independent of this choice.

REST API

Current operations:

POST /api/v1/customers
GET  /api/v1/customers/{customerId}
PUT  /api/v1/customers/{customerId}
Legacy Integration

The legacy path is designed as:

REST API
  → LegacyCustomerAdapter
  → z/OS Connect
  → CICS
  → COBOL
  → Customer Master

The local project includes the z/OS Connect API/provider configuration and CICS integration assets.

A live CICS region is required for a true end-to-end execution of the COBOL path.

Documentation
docs/architecture/ARCHITECTURE.md
docs/api/API_CONTRACT.md
docs/api/ZOS_CONNECT_CUSTOMER_API_CONTRACT.md
docs/api/LEGACY_CUSTOMER_ADAPTER_DESIGN.md
docs/ui/VRUT_BANK_UI_DESIGN.md
docs/design/CUSTADD_CICS.md
Project Goal

The final demonstration will show a modern banking frontend consuming a stable REST API while the backend can evolve from the legacy z/OS implementation toward a modern PostgreSQL-based implementation without requiring changes to the customer-facing UI.