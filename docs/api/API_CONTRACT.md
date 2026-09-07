VRUT Bank Customer REST API Contract
Purpose

This document defines the REST boundary consumed by the VRUT Bank frontend.

The frontend must not depend on the implementation behind the REST API.

Base Path
/api/v1/customers
Create Customer
Request
POST /api/v1/customers
Content-Type: application/json

Example:

{
  "firstName": "Arun",
  "lastName": "Kumar",
  "address": "Phoenix Street",
  "city": "Chennai",
  "state": "TN",
  "zipCode": "600001"
}
Success
HTTP 201 Created

Response contains the created customer information.

Get Customer
GET /api/v1/customers/{customerId}

Example:

GET /api/v1/customers/0000000005
Success
HTTP 200 OK
Update Customer
PUT /api/v1/customers/{customerId}
Content-Type: application/json

Example:

{
  "firstName": "Arun-Updated"
}
Success
HTTP 200 OK
Error Handling

The frontend should present useful user-facing messages for:

HTTP status	Meaning
400	Invalid customer data
404	Customer not found
409	Customer already exists
502	Legacy backend / downstream unavailable
500	Unexpected server error

The frontend should not expose internal implementation details to the customer.

Backend Independence

The same REST contract is used for:

Modern backend → PostgreSQL

and:

Legacy backend → z/OS Connect → CICS → COBOL

The frontend does not change when the backend implementation changes.