# CUSTADD CICS Interface

## Purpose

Define the CICS entry boundary for the Customer Add transaction and its
invocation of the existing `VRCB0100` business program.

## Transaction

| Attribute | Value |
|---|---|
| Transaction ID | CUSTADD |
| Business Function | Customer Add |
| Business Program | VRCB0100 |
| Current Interface | COBOL CALL |
| Target Interface | CICS transaction |

## Processing Flow

```text
CICS transaction CUSTADD
        |
        v
CICS entry boundary
        |
        v
VRCB0100 Customer Add
        |
        +--> VRCB0110 Customer Validation
        |
        +--> VRCB0120 Customer ID Generation
        |
        +--> Customer Master File
        |
        v
Operation Result
Input

The CICS request represents the existing customer record structure used by
VRCB0100.

The business program remains responsible for:

Customer validation
Customer ID generation
Duplicate detection
Customer persistence
Operation result

For the initial modernization implementation, the existing COBOL business
program is reused without modification.

Output

The CICS boundary returns:

Customer record
Operation return code
Operation severity
Operation error code
Operation return message
CICS Responsibility

The CICS layer is responsible for:

Receiving the transaction request
Establishing the program invocation boundary
Preparing the invocation data
Passing the request to VRCB0100
Returning the operation result to the caller

Business validation and persistence logic remain in VRCB0100.

Modernization Principle

CICS-specific transport concerns remain separated from customer business
logic so the same business capability can subsequently be exposed through
REST and z/OS Connect.

The existing COBOL business program is modified only when an actual
modern-integration requirement demonstrates that its existing interface or
capability is insufficient.

COMMAREA Interface

The logical CICS customer contract uses the existing customer and
operation-result structures.

Customer Data

Customer data follows VRCP0101.

Operation Result

Operation result follows VRCP9003.

CICS-to-VRCB0100 Invocation Area

The CICS entry program defines a contiguous invocation area:

WS-VRCB0100-COMMAREA
|
+-- WS-CUSTOMER-RECORD
|     VRCP0101 layout
|
+-- WS-OPERATION-RESULT
      VRCP9003 layout

The layout is intentionally aligned with the existing VRCB0100
PROCEDURE DIVISION USING interface:

LK-CUSTOMER-RECORD
LK-OPERATION-RESULT

The CICS LINK passes the complete invocation area and its length to
VRCB0100.

The existing copybooks are reused. No new business-level customer record
or operation-result definition is introduced.

CICS-to-VRCB0100 Invocation

The CUSTADD CICS entry boundary invokes VRCB0100 using:

EXEC CICS
    LINK PROGRAM("VRCB0100")
         COMMAREA(WS-VRCB0100-COMMAREA)
         LENGTH(LENGTH OF WS-VRCB0100-COMMAREA)
END-EXEC

The CICS boundary is responsible only for:

Receiving the CUSTADD request
Preparing the invocation data
Invoking VRCB0100
Returning the customer record and operation result

VRCB0100 remains responsible for:

Customer validation
Customer ID generation
Duplicate detection
Customer persistence
Business error handling

The CICS layer does not duplicate customer business logic.

Add and Update Support

The existing VRCB0100 business program supports both customer creation
and customer update.

Customer Add

When the incoming customer ID is blank:

CUSTADD
  |
  v
VRCB0100
  |
  +--> Validate
  +--> Generate customer ID
  +--> Check duplicate
  +--> Write customer
Customer Update

When the incoming customer ID is supplied:

Customer Update
  |
  v
VRCB0100
  |
  +--> Validate
  +--> Read existing customer
  +--> Rewrite customer

The CICS wrapper therefore provides a reusable CICS-to-COBOL invocation
boundary without duplicating add or update business logic.

CICS Error and Result Mapping

The CICS boundary returns the OPERATION-RESULT produced by VRCB0100.

Field	Source
Return Code	OPERATION-RETURN-CODE
Severity	OPERATION-SEVERITY
Error Code	OPERATION-ERROR-CODE
Return Message	OPERATION-RETURN-MESSAGE

A return code of zero represents successful processing.

A non-zero return code represents a business or processing error.

The CICS boundary does not reinterpret or replace business error codes.

Legacy Error Codes

The customer operation result may contain codes including:

Error Code	Meaning
VR-CUST-001	Customer already exists
VR-CUST-002	Validation error
VR-CUST-005	Customer not found
VR-CUST-999	Internal customer processing error

These codes remain available for translation by the modern integration
layer.

Local Validation Strategy

The CICS entry program contains CICS-specific EXEC CICS statements and
therefore requires a CICS/Enterprise COBOL environment for compilation.

Local validation uses the existing GnuCOBOL-compatible VRCB0100 program
to verify the business behavior independently of the CICS transport layer.

CICS-specific source validation is limited to structural and interface
review on the local development environment.

No CICS runtime execution is claimed locally.

CUSTADD Test Design

The CUSTADD boundary will be validated against the following scenarios.

Scenario	Input	Expected Result
Successful customer add	Valid customer record	Return code 00, severity S, customer ID returned
Duplicate customer	Existing customer ID	Return code 01, severity E, VR-CUST-001
Invalid customer	Invalid customer data	Validation error returned
Persistence failure	Customer repository failure	Processing error returned

The tests validate that the CICS boundary preserves the result produced by
VRCB0100.

Business behavior is validated locally using the existing GnuCOBOL test
programs. CICS-specific execution requires a CICS runtime.

CICS Integration Validation

Local validation confirms that the underlying VRCB0100 Customer Add and
Customer Update capabilities remain executable and that their success and
error results are covered by existing tests.

The CICS entry program VRCB0100-CICS.cbl cannot be compiled or executed
with the local GnuCOBOL toolchain because it contains CICS-specific
EXEC CICS statements.

Therefore:

Existing COBOL business logic: validated locally
CICS-to-COBOL interface: implemented and source-reviewed
COMMAREA layout: aligned with VRCB0100 linkage interface
CICS runtime integration test: requires a CICS/Enterprise COBOL environment
No CICS runtime behavior is claimed as locally executed
Acceptance

S7-03 CICS interface: ACCEPTED

The CICS entry wrapper now passes a complete invocation area containing the
existing customer record and operation-result structures to VRCB0100.

The existing COBOL business logic remains unchanged.