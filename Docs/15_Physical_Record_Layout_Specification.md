Phase 18 – Physical Record Layout Specification (PRLS)

Document Version: 1.0

Project: Project Phoenix – Legacy Core Banking Modernization

Client: VRUT Bank

Document ID: PRLS-001

Record: Customer Master (CUSTOMER.DAT)

Status: Draft (Design Review)

1. Purpose

This document defines the physical structure of the CUSTOMER.DAT indexed file.

It is the authoritative source for:

COBOL Copybook (VRCP0101)
Indexed File Layout
API Data Mapping
PostgreSQL Migration
Test Data
Adapter Layer

Any future changes to the customer record must begin here.

2. File Information
Property	Value
File Name	CUSTOMER.DAT
File Organization	Indexed
Access Mode	Dynamic
Record Type	Fixed Length
Primary Key	CUSTOMER-ID
Alternate Keys	None (Release 1.0)
Record Format	Fixed
Character Set	ASCII (GnuCOBOL)

Design Note: In a production z/OS environment, EBCDIC would be used. We are using ASCII because the project targets GnuCOBOL on a standard PC while preserving the logical structure of a legacy application.

3. Customer Record Layout
Offset	Length	Field Name	PIC	Required	Remarks
1	10	CUSTOMER-ID	X(10)	Yes	Primary Key
11	3	CUSTOMER-TYPE	X(3)	Yes	IND / NRI / COR
14	5	TITLE	X(5)	Yes	MR, MRS, MS, DR
19	30	FIRST-NAME	X(30)	Yes	Given Name
49	30	MIDDLE-NAME	X(30)	No	Optional
79	30	LAST-NAME	X(30)	Yes	Family Name
109	1	GENDER	X(1)	Yes	M / F / O
110	10	DATE-OF-BIRTH	X(10)	Yes	YYYY-MM-DD
120	10	MOBILE-NUMBER	X(10)	Yes	Primary Mobile
130	60	EMAIL-ID	X(60)	No	Optional
190	50	ADDRESS-LINE-1	X(50)	Yes	Residential Address
240	50	ADDRESS-LINE-2	X(50)	No	Landmark / Apartment
290	30	CITY	X(30)	Yes	City
320	30	STATE	X(30)	Yes	State
350	6	PINCODE	X(6)	Yes	Postal Code
356	30	COUNTRY	X(30)	Yes	Country
386	4	HOME-BRANCH-CODE	X(4)	Yes	Branch Master Reference
390	1	CUSTOMER-STATUS	X(1)	Yes	A / I / D / B / C
391	10	CREATED-DATE	X(10)	Yes	YYYY-MM-DD
401	8	CREATED-BY	X(8)	Yes	User ID
409	10	LAST-UPDATED-DATE	X(10)	Yes	YYYY-MM-DD
419	8	LAST-UPDATED-BY	X(8)	Yes	User ID
4. Record Summary
Item	Value
Total Fields	22
Record Length	426 Bytes
Key Length	10 Bytes
Record Type	Fixed
Compression	None
5. Field Validation Standards
Field	Validation
CUSTOMER-ID	Unique, mandatory
CUSTOMER-TYPE	IND, NRI, COR
TITLE	MR, MRS, MS, DR
GENDER	M, F, O
DATE-OF-BIRTH	Valid date (YYYY-MM-DD)
MOBILE-NUMBER	Exactly 10 digits
EMAIL-ID	Valid email format if supplied
HOME-BRANCH-CODE	Must exist in BRANCHM.DAT
CUSTOMER-STATUS	A, I, D, B, C
6. Reference Files

The following master files will be used for validation:

File	Purpose
BRANCHM.DAT	Branch validation
STATEM.DAT	State validation
CNTRYM.DAT	Country validation

Design Note: For Release 1.0, we will implement BRANCHM.DAT. STATEM.DAT and CNTRYM.DAT will be documented but deferred to a later release to keep the scope realistic.

7. Record Ownership
Component	Responsibility
VRCB0100	Create / Update Customer
VRCB0110	Customer Validation
VRCP0101	Record Definition
CUSTOMER.DAT	Persistent Storage
8. Future Modernization Mapping
Legacy Field	Future PostgreSQL Column
CUSTOMER-ID	customer_id
FIRST-NAME	first_name
LAST-NAME	last_name
MOBILE-NUMBER	mobile_number
HOME-BRANCH-CODE	home_branch_code
CUSTOMER-STATUS	customer_status

This mapping keeps naming consistent between legacy and modern systems.

9. Design Approval
Role	Status
Business Analyst	Approved
Data Architect	Approved
Mainframe Technical Lead	Approved
Modernization Architect	Approved