Phase 16 – Enterprise Repository Standards (ERS)

Document Version: 1.0

Project: Project Phoenix – Legacy Core Banking Modernization

Client: VRUT Bank

Document Type: Enterprise Repository Standards

Classification: Internal Engineering Standard

1. Purpose

This document establishes the engineering standards governing all deliverables produced during Project Phoenix.

It applies to:

Architecture
COBOL
Copybooks
JCL
Java
Python
SQL
Docker
AWS
Git
Documentation
Testing

Every contribution must comply with this standard.

2. Repository Layout Standard

The repository structure is fixed.

vrut-bank-modernization/
│
├── api/
│
├── cobol/
│   ├── customer/
│   ├── account/
│   ├── transaction/
│   ├── inquiry/
│   └── batch/
│
├── copybooks/
│
├── database/
│
├── diagrams/
│
├── docker/
│
├── docs/
│
├── jcl/
│
├── proc/
│
├── scripts/
│
├── test-data/
│
├── tools/
│
├── README.md
│
├── LICENSE
│
└── .gitignore

Rule ERS-001

No new top-level folders without architectural approval.

3. Naming Standards
COBOL Programs
VRCBxxxx

Examples

VRCB0100
VRCB0200
VRCB0900

Exactly 8 characters.

Copybooks
VRCPxxxx
JCL
VRJxxxxx
PROC
VRPxxxxx
Java Packages
com.vrutbank.customer
com.vrutbank.account
com.vrutbank.transaction
Database

snake_case

customer
customer_audit
transaction_history
REST

Plural resources

/customers

/accounts

/transfers
4. Documentation Standard

Every document begins with

# Project Phoenix

Document:
Version:
Status:
Owner:
Last Updated:
Review Status:

Every document ends with

Related Documents

Revision History

Approval

No exceptions.

5. COBOL Coding Standards

Mandatory order

IDENTIFICATION DIVISION.

ENVIRONMENT DIVISION.

DATA DIVISION.

PROCEDURE DIVISION.

Paragraph numbering

1000-MAIN

2000-INITIALIZE

3000-VALIDATE

4000-PROCESS

5000-WRITE

9000-EXIT

No GO TO unless explicitly justified.

Business logic

Never duplicated.

Copybooks

Used wherever data is shared.

No hard-coded literals.

6. Java Standards

Architecture

Controller

↓

Service

↓

Repository

Never bypass layers.

DTOs

Separate from entities.

Global exception handling mandatory.

Validation

Bean Validation.

Swagger/OpenAPI mandatory.

7. API Standards

JSON only.

UTF-8.

HTTPS only.

JWT authentication.

Versioned APIs.

Standard error model.

Correlation ID in every request.

8. Logging Standard

Every request logs

Timestamp
Correlation ID
User
Business Operation
Program Name
Execution Time
Result

Never log

Passwords
PAN
Aadhaar
JWT Tokens
9. Error Code Standard

Enterprise format

VR-CUST-001

VR-ACCT-001

VR-TRAN-001

Error Result Structure

Return Code
Technical processing outcome.

Severity
S = SUCCESS
W = WARNING
E = ERROR

Error Code
Enterprise business error identifier.

Message
Human-readable error or warning description.

Instead of generic

Error 12

This also maps cleanly into REST responses.

Message Repository

Phase 1:
Common COBOL message definitions.

Future:
Database-backed message repository such as DB2 or PostgreSQL.

The calling program must use the logical error-code and message
contract independently of the physical message repository.

10. Git Standards

Branch

main

Feature branches

feature/customer-module

feature/account-module

Commit examples

docs:

architecture:

cobol:

copybook:

database:

api:

docker:

aws:
11. Testing Standard

Every capability requires

Unit Test
Integration Test
End-to-End Test
Negative Test
Business Rule Validation
12. Security Standard

Authentication

JWT

Authorization

RBAC

Audit

Mandatory

Secrets

Never committed

13. Documentation Traceability

Every implementation must trace back to:

Business Requirement

↓

Business Capability

↓

Interface Control Document

↓

Copybook

↓

COBOL Program

↓

REST API

↓

Test Case

This is one of the strongest indicators of enterprise discipline.

14. Definition of Done (DoD)

A feature is complete only when all of the following are satisfied:

Business requirement implemented.
COBOL program compiled successfully.
Copybook validated.
Test data created.
REST API implemented.
Unit tests passed.
Integration tests passed.
Documentation updated.
Diagram updated if impacted.
Code reviewed.
Git committed and pushed.
15. Architecture Review Checklist

Before merging any feature, confirm:

Naming standards followed.
Business rules preserved.
Copybooks reused correctly.
Error handling implemented.
Logging present.
Documentation updated.
Tests executed.
No unnecessary complexity introduced.

## Enterprise Shared Copybooks

| Copybook | Purpose |
|----------|----------|
| VRCP9001 | Enterprise Constants |
| VRCP9002 | Enterprise Return Codes |
| VRCP9003 | Enterprise Operation Result |

Copybook Namespace Standard

Reusable COBOL copybooks must use a neutral CP- template prefix
where contextual reuse is required.

Approved contextual prefixes include:

FD-  File Definition
LK-  Linkage Interface
WS-  Working Storage

COPY REPLACING with explicit CP- data-name replacement pairs must
be used when contextualizing reusable copybook structures.

Partial prefix substitution must not be used as the contextualization
mechanism.

The contextual prefix is an implementation-level namespace and is
not part of the enterprise API contract.

This standard supports reuse, qualification, maintainability, and
cross-platform transformation.
