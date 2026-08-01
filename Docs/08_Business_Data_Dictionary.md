Phase 9 – Business Data Dictionary (BDD)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Document Type: Business Data Dictionary

1. Purpose

The Business Data Dictionary provides a single source of truth for all business data used throughout the modernization program.

It standardizes:

Business terminology
COBOL field names
Copybook fields
Database columns
REST API JSON attributes
Validation rules

This ensures consistency across the legacy and modern environments.

2. Naming Standards

We will use the following conventions.

Layer	Naming Convention	Example
Business	Title Case	Customer ID
COBOL	UPPER-CASE with hyphens	WS-CUST-ID
Copybook	UPPER-CASE	CUST-ID
Database	SNAKE_CASE	CUSTOMER_ID
Java	camelCase	customerId
JSON	camelCase	customerId
3. Customer Fields
Business Name	COBOL	Copybook	Database	Java / JSON	Type	Validation
Customer ID	WS-CUST-ID	CUST-ID	CUSTOMER_ID	customerId	CHAR(10)	Mandatory, Unique
Customer Name	WS-CUST-NAME	CUST-NAME	CUSTOMER_NAME	customerName	VARCHAR(100)	Mandatory
Date of Birth	WS-DOB	DOB	DATE_OF_BIRTH	dateOfBirth	DATE	Mandatory
PAN Number	WS-PAN-NO	PAN-NO	PAN_NUMBER	panNumber	CHAR(10)	Unique
Mobile Number	WS-MOBILE-NO	MOBILE-NO	MOBILE_NUMBER	mobileNumber	CHAR(10)	Unique
Email	WS-EMAIL	EMAIL	EMAIL_ADDRESS	email	VARCHAR(100)	Optional
KYC Status	WS-KYC-STS	KYC-STS	KYC_STATUS	kycStatus	CHAR(10)	VERIFIED/PENDING
Customer Status	WS-CUST-STS	CUST-STS	CUSTOMER_STATUS	customerStatus	CHAR(10)	ACTIVE/INACTIVE
4. Account Fields
Business Name	COBOL	Copybook	Database	Java / JSON	Type	Validation
Account Number	WS-ACCT-NO	ACCT-NO	ACCOUNT_NUMBER	accountNumber	CHAR(12)	Unique
Customer ID	WS-CUST-ID	CUST-ID	CUSTOMER_ID	customerId	CHAR(10)	Foreign Key
Account Type	WS-ACCT-TYPE	ACCT-TYPE	ACCOUNT_TYPE	accountType	CHAR(3)	SAV/CUR
Balance	WS-BALANCE	BALANCE	ACCOUNT_BALANCE	balance	DECIMAL(15,2)	≥ 0
Branch Code	WS-BRANCH-CD	BRANCH-CD	BRANCH_CODE	branchCode	CHAR(6)	Mandatory
Status	WS-ACCT-STS	ACCT-STS	ACCOUNT_STATUS	accountStatus	CHAR(10)	ACTIVE/CLOSED/BLOCKED
5. Transaction Fields
Business Name	COBOL	Copybook	Database	Java / JSON	Type	Validation
Transaction ID	WS-TRAN-ID	TRAN-ID	TRANSACTION_ID	transactionId	CHAR(15)	Unique
Account Number	WS-ACCT-NO	ACCT-NO	ACCOUNT_NUMBER	accountNumber	CHAR(12)	Mandatory
Transaction Type	WS-TRAN-TYPE	TRAN-TYPE	TRANSACTION_TYPE	transactionType	CHAR(3)	DEP/WDL/TRF
Amount	WS-AMOUNT	AMOUNT	TRANSACTION_AMOUNT	amount	DECIMAL(15,2)	> 0
Transaction Date	WS-TRAN-DATE	TRAN-DATE	TRANSACTION_DATE	transactionDate	TIMESTAMP	Mandatory
Status	WS-TRAN-STS	TRAN-STS	TRANSACTION_STATUS	transactionStatus	CHAR(10)	SUCCESS/FAILED
6. Branch Fields
Business Name	COBOL	Database	Java / JSON
Branch Code	WS-BRANCH-CD	BRANCH_CODE	branchCode
Branch Name	WS-BRANCH-NAME	BRANCH_NAME	branchName
City	WS-CITY	CITY	city
State	WS-STATE	STATE	state
7. Employee Fields
Business Name	COBOL	Database	Java / JSON
Employee ID	WS-EMP-ID	EMPLOYEE_ID	employeeId
Employee Name	WS-EMP-NAME	EMPLOYEE_NAME	employeeName
Role	WS-ROLE	EMPLOYEE_ROLE	role
8. Standard Enumerations
Customer Status
Value	Meaning
ACTIVE	Customer can perform transactions
INACTIVE	Customer temporarily inactive
CLOSED	Relationship terminated
Account Status
Value	Meaning
ACTIVE	Operational
BLOCKED	Temporarily blocked
CLOSED	Permanently closed
Transaction Types
Code	Description
DEP	Deposit
WDL	Withdrawal
TRF	Transfer
KYC Status
Code	Meaning
VERIFIED	KYC completed
PENDING	Awaiting verification
9. Enterprise Standards

These rules apply across the project:

Business field names never change.
Every database column maps to exactly one business field.
Every API field maps to exactly one business field.
Every COBOL copybook field maps to exactly one business field.
No duplicate business concepts with different names.

This gives us complete traceability from legacy to modern layers.