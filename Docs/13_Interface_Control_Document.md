Phase 15 — Interface Control Document (ICD)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: Interface Control Document (ICD)

Purpose

The ICD formally defines the interface contract between:

Spring Boot REST API
Legacy Adapter Layer
COBOL Business Programs

It ensures both teams (or in our case, both parts of the project) implement against the same contract.

Interface Inventory
Interface ID	COBOL Program	REST API	Status
ICD-001	VRCB0100	Customer API	Planned
ICD-002	VRCB0200	Account API	Planned
ICD-003	VRCB0300	Deposit API	Planned
ICD-004	VRCB0310	Withdrawal API	Planned
ICD-005	VRCB0400	Transfer API	Planned
ICD-006	VRCB0500	Statement API	Planned
ICD-001
Customer Maintenance Interface
Business Capability

Customer Management

Legacy Program
VRCB0100
API
POST /api/v1/customers
Description

Creates a new customer in the legacy banking system.

Request Flow
REST Client
      │
      ▼
Spring Boot
      │
      ▼
Legacy Adapter
      │
      ▼
VRCB0100
      │
      ▼
Indexed File
Request JSON
{
  "customerId": "VR100001",
  "firstName": "Rahul",
  "lastName": "Sharma",
  "dateOfBirth": "1992-08-15",
  "mobileNumber": "9876543210",
  "email": "rahul.sharma@example.com",
  "branchCode": "1001"
}
Response JSON
{
  "customerId": "VR100001",
  "status": "SUCCESS",
  "message": "Customer created successfully."
}
COBOL Input Layout
Field	PIC	Length
CUSTOMER-ID	X(10)	10
FIRST-NAME	X(30)	30
LAST-NAME	X(30)	30
DOB	X(10)	10
MOBILE	X(10)	10
EMAIL	X(60)	60
BRANCH	X(4)	4

We intentionally keep dates as character strings (YYYY-MM-DD) in Phase 1 to simplify adapter logic. We can introduce native date handling later if needed.

COBOL Output Layout
Field	PIC
RETURN-CODE	9(02)
RETURN-MESSAGE	X(50)
Validation Rules
Rule	Description
Customer ID	Mandatory and unique
First Name	Mandatory
Last Name	Mandatory
Mobile	Exactly 10 digits
Email	Valid email format
Branch Code	Must exist in branch master
Business Errors
Code	Description
VR001	Customer already exists
VR002	Invalid branch
VR003	Invalid mobile number
VR004	Mandatory field missing
HTTP Mapping
COBOL Return	HTTP	Meaning
00	201 Created	Success
01	400 Bad Request	Validation error
02	404 Not Found	Branch not found
03	409 Conflict	Duplicate customer
99	500 Internal Server Error	Unexpected failure
Logging Requirements

Each request logs:

Correlation ID
Timestamp
Customer ID
API Name
COBOL Program
Execution Time
Return Code

No sensitive data (such as email or mobile number) should be written to logs.

Audit Requirements

Record:

User ID
Branch
Operation
Date/Time
Success/Failure
Performance Target
Metric	Target
Average Response	< 300 ms
Maximum Response	< 500 ms
Dependencies
Customer Indexed File
Branch Master
Common Validation Copybook
Common Error Copybook
Future ICDs

We'll create the same structure for:

ICD-002 Account Management
ICD-003 Deposit
ICD-004 Withdrawal
ICD-005 Transfer
ICD-006 Statement Inquiry

Each document will follow the same format.