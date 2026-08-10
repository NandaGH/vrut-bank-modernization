Phase 8 – Logical Data Model (LDM)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: Logical Data Model (LDM)

1. Purpose

The Logical Data Model defines the core business entities managed by VRUT Bank and the relationships between them.

This document is independent of:

COBOL
VSAM
DB2
PostgreSQL
AWS

It represents the business view of the data.

2. Design Principles

We will follow these enterprise principles:

Each business entity has a single owner.
Each entity has a unique business identifier.
Business entities are independent of implementation technology.
Relationships are defined before physical storage.
Business rules are documented alongside entities.
3. Core Business Entities
Entity	Description	Business Owner
Customer	Individual or organization banking with VRUT Bank	Retail Banking
Account	Financial account owned by a customer	Retail Banking
Transaction	Financial movement affecting an account	Operations
Branch	Physical banking location	Branch Operations
Employee	Bank staff performing operations	Human Resources
Audit	Immutable business audit record	Compliance

These six entities are enough to build a realistic modernization project without overcomplicating the scope.

4. Customer Entity
Purpose

Represents a bank customer.

Key Attributes
Attribute	Description
Customer ID	Unique identifier
Full Name	Customer name
Date of Birth	DOB
PAN Number	Tax identifier
Aadhaar Number	National ID (fictional data only)
Mobile Number	Contact
Email	Contact
Address	Residential address
KYC Status	VERIFIED / PENDING
Customer Status	ACTIVE / INACTIVE
5. Account Entity
Purpose

Represents a banking account.

Key Attributes
Attribute	Description
Account Number	Unique account
Customer ID	Owner reference
Branch Code	Opening branch
Account Type	SAV / CUR
Open Date	Date opened
Balance	Current balance
Currency	INR
Status	ACTIVE / CLOSED / BLOCKED
6. Transaction Entity
Purpose

Represents every financial transaction.

Key Attributes
Attribute	Description
Transaction ID	Unique transaction
Account Number	Related account
Transaction Type	Deposit / Withdrawal / Transfer
Amount	Transaction amount
Transaction Date	Timestamp
Channel	Branch / API
Employee ID	Teller or system
Status	SUCCESS / FAILED
7. Branch Entity
Attribute	Description
Branch Code	Unique branch
Branch Name	Name
City	City
State	State
Status	ACTIVE
8. Employee Entity
Attribute	Description
Employee ID	Unique ID
Employee Name	Name
Role	Teller / Manager / Operations
Branch Code	Assigned branch
Status	ACTIVE
9. Audit Entity

This entity exists solely for compliance.

Attribute	Description
Audit ID	Unique audit record
Transaction ID	Related transaction
Event Type	CREATE / UPDATE / DELETE
Timestamp	Event time
User ID	Employee or system
Remarks	Audit details

Audit records are append-only. They are never updated or deleted.

10. Business Relationships
Parent	Relationship	Child
Customer	owns	Account
Account	records	Transaction
Branch	manages	Account
Employee	performs	Transaction
Transaction	generates	Audit

These relationships remain valid whether the data is stored in indexed files or a relational database.

11. Business Rules
Rule ID	Description
BR-001	One customer may own multiple accounts.
BR-002	Every account belongs to exactly one customer.
BR-003	Every transaction is linked to one account.
BR-004	Every transaction produces an audit record.
BR-005	Every account belongs to one branch.
BR-006	Only ACTIVE accounts accept transactions.
BR-007	KYC must be VERIFIED before opening an account.
12. Future Entity Roadmap

These are intentionally excluded from Phase 1 but planned for future modernization:

Future Entity	Planned Phase
Loan	Phase 2
Credit Card	Phase 2
Fixed Deposit	Phase 3
Notification	Phase 3
Beneficiary	Phase 3
Payment	Phase 4
Fraud Case	Phase 5

This keeps our scope controlled while showing extensibility.

Deliverables

📁 Store this document as:

docs/07_Logical_Data_Model.md

Still no Git commit.

We'll commit after the next document because these design artifacts belong together.

Captain's Review (One Important Correction)

Before we move into physical database design or COBOL record layouts, I want to make one architectural refinement.

Most portfolio projects define entities and then immediately create database tables.

Real banks don't stop there.

They define a Business Data Dictionary (BDD) that standardizes every field used across the enterprise.

For example:

Business Name	COBOL Name	Database Column	API Field
Customer ID	WS-CUST-ID	CUSTOMER_ID	customerId

Why is this important?

Imagine, six weeks from now, we're implementing:

COBOL copybooks
PostgreSQL tables
Java DTOs
REST APIs
JSON payloads

Without a common dictionary, field names drift (CUSTNO, CUSTOMER_ID, custId, CID), making the project inconsistent. With a Business Data Dictionary, every layer refers back to the same business definition.