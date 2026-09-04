# Project Phoenix - Customer Error / HTTP Mapping

## 1. Purpose

This document defines how Customer business and technical outcomes are
translated from the legacy COBOL operation-result model into the modern REST
HTTP error model.

The mapping provides a consistent response to digital consumers regardless
of whether the backend is the legacy COBOL/CICS implementation or the modern
Customer microservice.

---

## 2. Error Translation Boundary

```text
Legacy / Modern Backend
          |
          v
Business / Technical Result
          |
          v
Error Mapping Layer
          |
          v
HTTP Status + Phoenix JSON Error
          |
          v
REST Consumer

The backend must not directly control HTTP semantics.

The REST boundary owns HTTP status mapping and API error formatting.

3. COBOL Operation Result

The existing COBOL programs use the common operation-result structure:

Field	Purpose
OPERATION-RETURN-CODE	Indicates success or failure
OPERATION-SEVERITY	Indicates result severity
OPERATION-ERROR-CODE	Identifies business or technical error
OPERATION-RETURN-MESSAGE	Human-readable result message

The REST layer interprets these values and produces the API response.

4. Customer Error Mapping
Error Code	Meaning	HTTP Status	API Error
VR-CUST-001	Customer already exists	409	Customer Already Exists
VR-CUST-002	Invalid branch	400	Validation Error
VR-CUST-003	Invalid mobile number	400	Validation Error
VR-CUST-004	Mandatory field missing	400	Validation Error
VR-CUST-005	Customer not found	404	Customer Not Found
VR-CUST-999	Unexpected customer processing error	500	Internal Server Error
VR-COM-001	Message repository unavailable	500	Internal Server Error
VR-COM-002	Message code not found	500	Internal Server Error
5. Successful Operation Mapping

A successful operation has:

OPERATION-RETURN-CODE = 00
OPERATION-SEVERITY    = S
Customer Inquiry
COBOL Success
     |
     v
HTTP 200 OK
     |
     v
Customer JSON
Customer Update
COBOL Success
     |
     v
HTTP 200 OK
     |
     v
Update Success JSON
Customer Create
COBOL Success
     |
     v
HTTP 201 Created
     |
     v
Create Success JSON
6. Validation Error

Validation failures are represented as HTTP 400 Bad Request.

Example:

{
  "timestamp": "2026-09-01T20:00:00Z",
  "status": 400,
  "error": "Validation Error",
  "message": "Mandatory field missing",
  "path": "/api/v1/customers"
}

Applicable legacy error codes include:

VR-CUST-002
VR-CUST-003
VR-CUST-004

The business validation remains owned by the Customer capability.

7. Duplicate Customer

Duplicate customer detection maps to HTTP 409 Conflict.

VR-CUST-001
     |
     v
Customer already exists
     |
     v
HTTP 409 Conflict

Example:

{
  "timestamp": "2026-09-01T20:00:00Z",
  "status": 409,
  "error": "Customer Already Exists",
  "message": "Customer already exists",
  "path": "/api/v1/customers"
}
8. Customer Not Found

Customer-not-found maps to HTTP 404 Not Found.

VR-CUST-005
     |
     v
Customer not found
     |
     v
HTTP 404 Not Found

Example:

{
  "timestamp": "2026-09-01T20:00:00Z",
  "status": 404,
  "error": "Customer Not Found",
  "message": "Customer does not exist.",
  "path": "/api/v1/customers/9999999999"
}

This applies to both Customer Inquiry and Customer Update.

9. Internal Processing Failure

Unexpected processing failures map to HTTP 500 Internal Server Error.

Examples:

VR-CUST-999
VR-COM-001
VR-COM-002

The REST response must not expose:

COBOL paragraph names
File names
Indexed-file details
Internal database details
Stack traces
Internal implementation information

Example:

{
  "timestamp": "2026-09-01T20:00:00Z",
  "status": 500,
  "error": "Internal Server Error",
  "message": "Customer service could not process the request.",
  "path": "/api/v1/customers"
}
10. Authentication Failure

Authentication is handled at the API/security boundary.

HTTP 401 Unauthorized means the request could not be authenticated.

Client
  |
  | Missing / invalid JWT
  v
Security Boundary
  |
  v
HTTP 401

The COBOL business programs do not process JWT tokens.

11. Authorization Failure

HTTP 403 Forbidden means the caller is authenticated but is not permitted
to perform the requested operation.

Authenticated Client
        |
        v
Authorization Check
        |
        v
Insufficient Permission
        |
        v
HTTP 403

Authorization remains outside the COBOL business logic.

12. HTTP Status Catalogue
HTTP Status	Meaning	Phoenix Usage
200	OK	Inquiry / Update success
201	Created	Customer creation success
204	No Content	Reserved for future operations
400	Bad Request	Validation failure
401	Unauthorized	Authentication failure
403	Forbidden	Authorization failure
404	Not Found	Customer not found
409	Conflict	Duplicate customer
500	Internal Server Error	Unexpected / infrastructure failure
13. Error Response Structure

The standard Phoenix REST error response is:

{
  "timestamp": "2026-09-01T20:00:00Z",
  "status": 400,
  "error": "Validation Error",
  "message": "Mandatory field missing",
  "path": "/api/v1/customers"
}
Field	Description
timestamp	Time at which the API error occurred
status	HTTP status
error	API error category
message	Consumer-readable message
path	Request path
14. Legacy-to-REST Example

Customer Inquiry for an unknown customer:

GET /api/v1/customers/9999999999
             |
             v
        REST Boundary
             |
             v
          VRCB0130
             |
             v
      Customer Master READ
             |
             v
        INVALID KEY
             |
             v
        VR-CUST-005
             |
             v
      Operation Result
             |
             v
          HTTP 404
             |
             v
       JSON Error
15. Modern-to-REST Example

The modern Customer Service must produce equivalent API behaviour:

GET /api/v1/customers/9999999999
             |
             v
    Customer Microservice
             |
             v
       Customer Repository
             |
             v
       Customer Not Found
             |
             v
          HTTP 404
             |
             v
        JSON Error

The consumer should not need to know which implementation produced the
result.

16. z/OS Connect Alignment

For the legacy integration path:

REST
 |
 v
z/OS Connect
 |
 v
CICS
 |
 v
COBOL
 |
 v
Operation Result
 |
 v
REST Error Mapping

z/OS Connect and the integration layer must preserve the business result
required by the API mapping.

17. Modern Microservice Alignment

For the modern implementation:

REST
 |
 v
Customer Microservice
 |
 v
Customer Service
 |
 v
Repository
 |
 v
Business Result
 |
 v
REST Error Mapping

The same API-level error semantics must be maintained.

18. Security Boundary

Security failures are deliberately separated from business errors.

Authentication
      |
      +--> 401

Authorization
      |
      +--> 403

Business Validation
      |
      +--> 400

Business Conflict
      |
      +--> 409

Business Resource Missing
      |
      +--> 404

Technical Failure
      |
      +--> 500

This separation will allow security controls to evolve independently of
legacy customer business logic.

19. Implementation Rule

The REST implementation must follow this sequence:

1. Receive request
2. Authenticate
3. Authorize
4. Validate API structure
5. Map request to business model
6. Invoke Customer capability
7. Interpret operation result
8. Map result to HTTP status
9. Map result to JSON
10. Return response

Business validation must not be duplicated unnecessarily in the REST layer.

20. Demonstration Scenarios

The final Phoenix demonstration should show at least these cases:

Scenario	Expected HTTP
Create valid customer	201
Create invalid customer	400
Create duplicate customer	409
Inquiry existing customer	200
Inquiry missing customer	404
Update existing customer	200
Update missing customer	404
Missing / invalid authentication	401
Insufficient authorization	403
Unexpected backend failure	500

These scenarios provide a practical demonstration of both business and
security error handling.

21. S6-05 Status

Status: Complete - Error and HTTP mapping defined.

Next:

S6-06 - Design REST wrapper.
