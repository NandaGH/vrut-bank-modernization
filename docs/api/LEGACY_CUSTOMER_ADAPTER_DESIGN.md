# Legacy Customer Adapter Design

## Purpose

Define the application-side adapter responsible for exposing the existing
legacy customer capabilities through the modern REST service.

The adapter isolates legacy integration concerns from the REST API and
customer service layer.

## Position in the Architecture

The target legacy processing path is:

```text
Angular
   |
   v
REST API
   |
   v
CustomerService
   |
   v
LegacyCustomerAdapter
   |
   v
z/OS Connect
   |
   v
CICS
   |
   v
Existing COBOL
   |
   v
Customer Master

The REST API contract remains independent of whether the customer capability
is implemented by the modern or legacy backend.

Adapter Responsibility

The LegacyCustomerAdapter is responsible for:

Translating application requests into the z/OS Connect request contract
Invoking the z/OS Connect API
Receiving z/OS Connect responses
Translating legacy customer data into the application response model
Translating legacy operation results into application-level errors
Translating transport or integration failures into appropriate application
errors
Obtaining integration configuration from application settings

The adapter is not responsible for:

Customer business validation
Customer ID generation
Duplicate detection
Customer persistence rules
CICS business processing
Direct access to the Customer Master file
Reimplementation of COBOL business logic

Existing COBOL programs remain the source of truth for legacy customer
business behavior.

Adapter Interface

The adapter implements the same customer capability interface used by the
modern customer implementation.

Logical operations:

Operation	Adapter Method	Legacy Capability
Create customer	create	VRCB0100 Customer Add
Get customer	get	VRCB0130 Customer Inquiry
Update customer	update	VRCB0100 Customer Update

Customer delete is not exposed because no corresponding legacy COBOL
capability has been established.

Create Flow
POST /api/v1/customers
        |
        v
CustomerService
        |
        v
LegacyCustomerAdapter.create()
        |
        v
z/OS Connect
        |
        v
CICS CUSTADD
        |
        v
VRCB0100
        |
        +--> Validation
        +--> Customer ID generation
        +--> Duplicate detection
        +--> Customer Master write
        |
        v
Operation Result
        |
        v
LegacyCustomerAdapter
        |
        v
REST response

The adapter does not generate the customer ID. The existing VRCB0100
business program remains responsible for customer ID generation.

Inquiry Flow
GET /api/v1/customers/{customerId}
        |
        v
CustomerService
        |
        v
LegacyCustomerAdapter.get()
        |
        v
z/OS Connect
        |
        v
VRCB0130
        |
        v
Customer Master inquiry
        |
        v
Customer Record + Operation Result
        |
        v
LegacyCustomerAdapter
        |
        v
REST response
Update Flow
PUT /api/v1/customers/{customerId}
        |
        v
CustomerService
        |
        v
LegacyCustomerAdapter.update()
        |
        v
z/OS Connect
        |
        v
CICS CUSTADD boundary
        |
        v
VRCB0100
        |
        +--> Validation
        +--> Existing customer lookup
        +--> Customer rewrite
        |
        v
Operation Result
        |
        v
LegacyCustomerAdapter
        |
        v
REST response

The existing VRCB0100 update behavior remains responsible for determining
whether the requested customer exists and for persisting the update.

Request Mapping

The initial modernization scope uses the following application-to-legacy
field mappings:

Application Field	Legacy Field
firstName	CP-CUSTOMER-FIRST-NAME
lastName	CP-CUSTOMER-LAST-NAME
address	CP-CUSTOMER-ADDRESS-LINE-1
city	CP-CUSTOMER-CITY
state	CP-CUSTOMER-STATE
zipCode	CP-CUSTOMER-PINCODE

The mapping follows the z/OS Connect customer API contract.

Additional legacy customer fields may be introduced later when required by
the modern application contract.

Response Mapping

The legacy response contains:

Customer record
Operation return code
Operation severity
Operation error code
Operation return message

The adapter converts these into the modern application response model.

For successful operations, the customer data is returned to the REST layer.

For unsuccessful operations, the legacy error code is preserved as the
basis for application-level error mapping.

Error Handling

The adapter preserves the established legacy error semantics.

Initial mappings include:

Legacy Error	Meaning	REST Mapping
VR-CUST-001	Customer already exists	HTTP 409
VR-CUST-002	Validation error	HTTP 400
VR-CUST-005	Customer not found	HTTP 404
VR-CUST-999	Internal customer processing error	HTTP 500

Integration or transport failures are treated separately from business
errors.

The adapter must not convert a transport failure into a misleading
customer business error.

Configuration

The adapter obtains z/OS Connect connection details from application
configuration rather than hard-coding endpoint values.

Initial configuration properties:

ZOS_CONNECT_BASE_URL
ZOS_CONNECT_TIMEOUT
ZOS_CONNECT_VERIFY_TLS

The same application can therefore use different z/OS Connect environments
without changing adapter implementation code.

Backend Selection

Backend selection remains a configuration concern.

Modern processing:

CUSTOMER_BACKEND=modern
        |
        v
ModernCustomerAdapter
        |
        v
PostgreSQL

Legacy processing:

CUSTOMER_BACKEND=legacy
        |
        v
LegacyCustomerAdapter
        |
        v
z/OS Connect
        |
        v
CICS
        |
        v
COBOL

The REST consumer does not need to know which backend is active.

Security Boundary

Authentication and authorization remain responsibilities of the REST/API
boundary.

The LegacyCustomerAdapter is responsible for propagating only the
integration credentials or tokens required by the configured z/OS Connect
environment.

Business authorization rules are not duplicated inside the adapter.

Observability

The adapter should provide enough integration visibility to support the
modernization demonstration and operational troubleshooting.

The target implementation should capture:

Backend selected
Operation being performed
z/OS Connect endpoint being called
Request correlation information
Response status
Legacy operation result code
Integration duration
Integration failures

Sensitive customer data must not be written to application logs.

OpenTelemetry remains the planned observability mechanism for the broader
application.

Testing Strategy

The adapter will be tested at multiple levels.

Unit Testing

Validate:

Request mapping
Response mapping
Legacy error mapping
Transport failure handling
Configuration behavior
Integration Testing

Validate the adapter against the z/OS Connect environment.

The integration path should demonstrate:

REST
  |
  v
LegacyCustomerAdapter
  |
  v
z/OS Connect
  |
  v
CICS
  |
  v
COBOL
End-to-End Demonstration

The final demonstration should use the same REST API for both:

Modern Backend
REST -> Customer Service -> PostgreSQL

and:

Legacy Backend
REST -> LegacyCustomerAdapter -> z/OS Connect -> CICS -> COBOL

The visible consumer contract remains unchanged.

Design Acceptance

S7-04 LegacyCustomerAdapter design: ACCEPTED

The adapter boundary is defined between the application customer service
and z/OS Connect.

The adapter owns translation and integration concerns while existing COBOL
programs remain responsible for legacy customer business behavior.

Implementation proceeds in S7-06 after the practical z/OS Connect environment
has been established.