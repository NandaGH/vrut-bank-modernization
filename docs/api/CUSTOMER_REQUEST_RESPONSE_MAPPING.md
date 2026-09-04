# Project Phoenix - Customer Request / Response Mapping

## 1. Purpose

This document defines the mapping between the modern Customer REST API
contract and the existing COBOL Customer business interfaces.

The mapping establishes a clear boundary between:

- REST JSON
- Customer business fields
- COBOL linkage structures
- Customer copybook VRCP0101
- Operation result VRCP9003
- HTTP response status

The mapping applies to Customer Add, Customer Inquiry, and Customer Update.

---

## 2. Mapping Architecture

```text
Modern Client
     |
     v
REST JSON
     |
     v
Customer API Boundary
     |
     v
Request / Response Mapping
     |
     +-----------------------------+
     |                             |
     v                             v
VRCB0100                       VRCB0130
Add / Update                   Inquiry
     |                             |
     v                             v
VRCP0101                       VRCP0101
Customer Record                Customer Record
     |                             |
     +-------------+---------------+
                   |
                   v
              Customer Master

Business Result
       |
       v
VRCP9003
       |
       v
HTTP Status + JSON Response
3. Customer Field Mapping
REST JSON Field	COBOL Linkage Field	COBOL Picture	Direction	Notes
customerId	LK-CUSTOMER-ID	X(10)	Request / Response	Customer identifier
customerType	LK-CUSTOMER-TYPE	X(02)	Request / Response	IN, NRI, or corporate
title	LK-CUSTOMER-TITLE	X(05)	Request / Response	Customer title
firstName	LK-CUSTOMER-FIRST-NAME	X(30)	Request / Response	First name
middleName	LK-CUSTOMER-MIDDLE-NAME	X(30)	Request / Response	Middle name
lastName	LK-CUSTOMER-LAST-NAME	X(30)	Request / Response	Last name
gender	LK-CUSTOMER-GENDER	X(01)	Request / Response	M, F, or other
dateOfBirth	LK-CUSTOMER-DATE-OF-BIRTH	X(10)	Request / Response	YYYY-MM-DD
mobileNumber	LK-CUSTOMER-MOBILE-NUMBER	X(10)	Request / Response	Mobile number
email	LK-CUSTOMER-EMAIL-ID	X(60)	Request / Response	Email address
addressLine1	LK-CUSTOMER-ADDRESS-LINE-1	X(50)	Request / Response	Address line 1
addressLine2	LK-CUSTOMER-ADDRESS-LINE-2	X(50)	Request / Response	Address line 2
city	LK-CUSTOMER-CITY	X(30)	Request / Response	City
state	LK-CUSTOMER-STATE	X(30)	Request / Response	State
pincode	LK-CUSTOMER-PINCODE	X(06)	Request / Response	Postal code
country	LK-CUSTOMER-COUNTRY	X(30)	Request / Response	Country
homeBranchCode	LK-CUSTOMER-HOME-BRANCH	X(04)	Request / Response	Home branch
status	LK-CUSTOMER-STATUS	X(01)	Request / Response	A/I/D/B/C
createdDate	LK-CUSTOMER-CREATED-DATE	X(10)	Response	Audit field
createdBy	LK-CUSTOMER-CREATED-BY	X(08)	Response	Audit field
lastUpdatedDate	LK-CUSTOMER-LAST-UPD-DATE	X(10)	Response	Audit field
lastUpdatedBy	LK-CUSTOMER-LAST-UPD-BY	X(08)	Response	Audit field
4. Customer Add Mapping
REST Request
POST /api/v1/customers

The REST request does not provide a generated customer ID.

JSON Request
     |
     v
Customer API Mapper
     |
     v
LK-CUSTOMER-RECORD
     |
     v
VRCB0100
Processing

VRCB0100 performs:

Customer validation through VRCB0110.
Duplicate customer checking.
Customer ID generation through VRCB0120.
Customer persistence.
Operation result creation.
Customer ID

For Customer Add:

REST customerId
        |
        +--> Not supplied
        |
        v
VRCB0100
        |
        v
VRCB0120
        |
        v
Generated 10 digit Customer ID

The generated ID becomes part of the response.

5. Customer Inquiry Mapping
REST Request
GET /api/v1/customers/{customerId}

The path parameter maps to:

customerId
     |
     v
LK-INQUIRY-ID
     |
     v
VRCB0130
     |
     v
Customer Master

VRCB0130 uses the inquiry ID as the indexed Customer Master key.

Successful Inquiry
Customer Master
     |
     v
FD-CUSTOMER-RECORD
     |
     v
LK-CUSTOMER-RECORD
     |
     v
REST Response JSON

The returned customer record is mapped from the COBOL customer structure
to the REST customer representation.

Customer Not Found
READ CUSTOMER-FILE
       |
       v
INVALID KEY
       |
       v
VR-CUST-005
       |
       v
OPERATION-RETURN-CODE = 01
OPERATION-SEVERITY = E
       |
       v
HTTP 404
6. Customer Update Mapping
REST Request
PUT /api/v1/customers/{customerId}

The path customer ID identifies the existing customer.

Path customerId
       |
       v
Existing customer identity
       |
       v
VRCB0100
       |
       v
Existing customer verification
       |
       v
Validation
       |
       v
Customer Master update

The update operation does not generate a new customer ID.

The supplied customer ID remains the record identity.

7. Operation Result Mapping

The common COBOL operation result is defined by VRCP9003.

COBOL Field	REST Meaning
OPERATION-RETURN-CODE	Business operation outcome
OPERATION-SEVERITY	Success or error severity
OPERATION-ERROR-CODE	Phoenix business / technical error code
OPERATION-RETURN-MESSAGE	Human-readable result message

The REST boundary converts this internal result into HTTP status and JSON.

8. HTTP Result Mapping
COBOL Condition	HTTP Status	REST Meaning
Return code 00 + severity S	200	Successful inquiry/update
Return code 00 + severity S for create	201	Customer created
Validation failure	400	Invalid customer request
Customer not found	404	Customer does not exist
Duplicate customer	409	Customer already exists
Repository / unexpected failure	500	Internal server error
9. Error Code Mapping
COBOL Error Code	Business Meaning	HTTP Status
VR-CUST-001	Customer already exists	409
VR-CUST-002	Invalid branch	400
VR-CUST-003	Invalid mobile number	400
VR-CUST-004	Mandatory field missing	400
VR-CUST-005	Customer not found	404
VR-CUST-999	Unexpected customer processing error	500
VR-COM-001	Message repository unavailable	500

The REST layer must not expose internal COBOL implementation details.

The error code may be retained as a business error identifier in the API
response where appropriate.

10. Validation Mapping

The REST layer performs structural request validation.

Business validation remains with the Customer business capability.

REST Request
     |
     v
Structural Validation
     |
     v
Customer Mapper
     |
     v
VRCB0100
     |
     v
VRCB0110

VRCB0110 validates customer information including:

First name
Last name
Customer type
Gender
Customer status
Home branch

The modernization design therefore avoids duplicating legacy business rules
inside the REST boundary.

11. Create Response Mapping

Successful Customer Add:

VRCB0100
     |
     +--> Generated Customer ID
     |
     +--> OPERATION-RETURN-CODE = 00
     |
     +--> OPERATION-SEVERITY = S
     |
     v
REST Mapper
     |
     v
HTTP 201 Created

Example:

{
  "customerId": "0000000001",
  "status": "SUCCESS",
  "message": "Customer created successfully."
}
12. Inquiry Response Mapping

Successful Customer Inquiry:

VRCB0130
     |
     v
LK-CUSTOMER-RECORD
     |
     v
REST Mapper
     |
     v
HTTP 200 OK
     |
     v
Customer JSON

The response contains the customer business fields defined by the API
contract.

13. Update Response Mapping

Successful Customer Update:

VRCB0100
     |
     +--> Existing customer verified
     |
     +--> Customer validated
     |
     +--> Customer record updated
     |
     +--> OPERATION-RETURN-CODE = 00
     |
     v
REST Mapper
     |
     v
HTTP 200 OK

Example:

{
  "customerId": "0000000001",
  "status": "SUCCESS",
  "message": "Customer updated successfully."
}
14. Mapping Boundary

The REST mapping layer owns:

JSON serialization
JSON deserialization
Field-name conversion
HTTP status conversion
API error representation
API authentication / authorization integration

The COBOL business layer owns:

Customer validation
Customer ID generation
Duplicate detection
Customer existence checking
Customer persistence
Business operation result

This separation allows the same COBOL business capability to be reused by
CICS and REST integration.

15. z/OS Connect Alignment

The mapping is designed so that it can subsequently be represented using
OpenAPI and z/OS Connect.

Target flow:

Modern Client
     |
     v
OpenAPI Contract
     |
     v
z/OS Connect
     |
     v
CICS
     |
     v
VRCB0100 / VRCB0130
     |
     v
COMMAREA
     |
     v
COBOL Business Logic

The API contract remains independent of whether the backend invocation is
implemented using a modern microservice adapter or z/OS Connect.

16. Modern Microservice Alignment

A future modern implementation can use the same API contract:

Modern Client
     |
     v
API Gateway
     |
     v
Customer Microservice
     |
     v
Customer Repository
     |
     v
PostgreSQL

The REST contract therefore becomes the stable boundary between consumers
and the underlying implementation.

17. Contract Preservation Principle

The following must remain stable when moving from legacy-backed execution to
a modern implementation:

Endpoint
HTTP method
Request field names
Response field names
Business meanings
Error semantics
Customer identity rules

Only the internal implementation is allowed to change.

18. S6-03 Status

Status: Complete - Request/Response mapping defined.

Next:

S6-04 - Define REST-to-Customer-service boundary.
