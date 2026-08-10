Phase 14 — API & Integration Architecture

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: API & Integration Architecture

1. Purpose

This document defines how external applications securely interact with the modernized banking platform.

It establishes:

API standards
Integration patterns
Authentication
Error handling
API lifecycle
Future event-driven integration
2. Architecture Overview

Instead of calling COBOL programs directly:

Client
   │
REST API
   │
API Gateway
   │
Spring Boot Service
   │
Legacy Adapter
   │
COBOL
   │
Indexed Files

This is the only supported integration path.

No application communicates directly with COBOL.

3. API Design Principles
ID	Principle
API-01	REST First
API-02	JSON Payloads
API-03	Stateless Services
API-04	Versioned APIs
API-05	HTTPS Only
API-06	Standard HTTP Status Codes
API-07	Consistent Error Model
API-08	Backward Compatibility
4. API Naming Standards
Base URL
/api/v1
Resource Naming

Correct:

/customers
/accounts
/transfers
/transactions

Avoid:

/getCustomer
/createAccount
/doTransfer

Resources should represent business entities, not actions.

5. REST Endpoint Catalog (Phase 1)
Business Capability	Method	Endpoint
Customer Lookup	GET	/api/v1/customers/{customerId}
Create Customer	POST	/api/v1/customers
Update Customer	PUT	/api/v1/customers/{customerId}
Account Lookup	GET	/api/v1/accounts/{accountNumber}
Deposit	POST	/api/v1/accounts/{accountNumber}/deposit
Withdrawal	POST	/api/v1/accounts/{accountNumber}/withdrawal
Fund Transfer	POST	/api/v1/transfers
Mini Statement	GET	/api/v1/accounts/{accountNumber}/transactions
6. Request Flow

Example: Customer Inquiry

Mobile App
     │
HTTPS Request
     │
API Gateway
     │
Customer Service
     │
Legacy Adapter
     │
VRCB0100
     │
Indexed File

Response follows the same path back.

7. JSON Standards
Customer Response
{
  "customerId": "VR100001",
  "firstName": "Rahul",
  "lastName": "Sharma",
  "status": "ACTIVE"
}
Error Response
{
  "timestamp": "2026-08-01T15:30:45Z",
  "status": 404,
  "error": "Customer Not Found",
  "message": "Customer VR100001 does not exist.",
  "path": "/api/v1/customers/VR100001"
}

We'll use this format consistently.

8. HTTP Status Standards
Status	Meaning
200	Success
201	Created
204	No Content
400	Validation Error
401	Unauthorized
403	Forbidden
404	Resource Not Found
409	Business Conflict
500	Internal Server Error
9. Authentication

Phase 1

HTTPS
JWT Authentication
Role-Based Authorization

Example Roles

Role	Access
CUSTOMER	Personal Accounts
BANK_USER	Branch Operations
MANAGER	Branch Approval
ADMIN	System Administration
10. Adapter Layer Responsibilities

The Adapter Layer is critical.

It performs:

JSON ↔ COBOL structure conversion
Data validation
Copybook mapping
Error translation
COBOL program invocation
Response transformation

The Adapter ensures that COBOL remains isolated from external consumers.

11. Error Translation

Example

Legacy COBOL returns:

RETURN-CODE = 12

Adapter converts to:

404 Not Found

with a structured JSON error.

Clients never see COBOL-specific return codes.

12. Future Event Integration (Phase 2)

Some business events will be published instead of only returning API responses.

Examples:

Customer Created

↓

Kafka Event

↓

CRM System

↓

Fraud Detection

↓

Notification Service

Initial candidate events:

Event
CustomerCreated
AccountOpened
CashDeposited
CashWithdrawn
TransferCompleted
13. API Versioning Strategy

Initial Version

/api/v1

Future

/api/v2

Older versions remain available until officially retired.

14. API Governance

Every API must have:

Business owner
Technical owner
Swagger/OpenAPI specification
Version history
Test cases
Security review
15. Success Criteria

The API platform is considered successful when:

All Phase 1 business capabilities are API-enabled.
No external consumer calls COBOL directly.
Authentication is enforced.
Responses follow a consistent JSON format.
Services are deployable in containers.