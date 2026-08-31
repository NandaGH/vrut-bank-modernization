# CUSTADD CICS Interface

## Purpose

Define the CICS entry boundary for the Customer Add transaction.

## Transaction

| Attribute | Value |
|---|---|
| Transaction ID | CUSTADD |
| Business Function | Customer Add |
| Business Program | VRCB0100 |
| Current Interface | COBOL CALL |
| Target Interface | CICS transaction |

## Processing Flow

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

## Input

The CICS request represents the existing customer record structure used by
VRCB0100.

The business program remains responsible for:

- Customer validation
- Customer ID generation
- Duplicate detection
- Customer persistence
- Operation result

## Output

The CICS boundary returns:

- Customer record
- Operation return code
- Operation severity
- Operation error code
- Operation return message

## CICS Responsibility

The CICS layer is responsible for:

- Receiving the transaction request
- Establishing the program invocation boundary
- Passing the request to VRCB0100
- Returning the operation result to the caller

Business validation and persistence logic remain in VRCB0100.

## Modernization Principle

CICS-specific transport concerns must remain separated from customer
business logic so the same business capability can subsequently be exposed
through REST.

## COMMAREA Interface

The CUSTADD transaction uses the existing customer and operation-result
structures as its logical COMMAREA contract.

### Customer Data

Customer data follows `VRCP0101`.

### Operation Result

Operation result follows `VRCP9003`.

### Boundary Contract

The CICS layer passes the customer request to `VRCB0100` and receives the
updated customer record and operation result.

No duplicate customer data structure is introduced for the CICS interface.

## CICS-to-VRCB0100 Invocation

The CUSTADD CICS entry boundary invokes `VRCB0100` using the existing
customer record and operation-result structures.

The CICS boundary is responsible only for:

- Receiving the CUSTADD request
- Preparing the invocation data
- Invoking VRCB0100
- Returning the customer record and operation result

VRCB0100 remains responsible for:

- Customer validation
- Customer ID generation
- Duplicate detection
- Customer persistence
- Business error handling

The CICS layer does not duplicate customer business logic.

## CICS Error and Result Mapping

The CICS boundary returns the `OPERATION-RESULT` produced by `VRCB0100`.

| Field | Source |
|---|---|
| Return Code | `OPERATION-RETURN-CODE` |
| Severity | `OPERATION-SEVERITY` |
| Error Code | `OPERATION-ERROR-CODE` |
| Return Message | `OPERATION-RETURN-MESSAGE` |

A return code of zero represents successful processing.

A non-zero return code represents a business or processing error.

The CICS boundary does not reinterpret or replace business error codes.

## Local Validation Strategy

The CICS entry program contains CICS-specific `EXEC CICS` statements and
therefore requires a CICS/Enterprise COBOL environment for compilation.

Local validation uses the existing GnuCOBOL-compatible `VRCB0100` program
to verify the business behavior independently of the CICS transport layer.

The following existing tests provide local evidence for the underlying
Customer Add capability:

- Customer validation
- Customer ID generation
- Duplicate detection
- Customer persistence
- Operation result handling

CICS-specific compilation and runtime validation remain environment-dependent.

## CUSTADD Test Design

The CUSTADD boundary will be validated against the following scenarios.

| Scenario | Input | Expected Result |
|---|---|---|
| Successful customer add | Valid customer record | Return code 00, severity S, customer ID returned |
| Duplicate customer | Existing customer ID | Return code 01, severity E, `VR-CUST-001` |
| Invalid customer | Invalid customer data | Validation error returned |
| Persistence failure | Customer repository failure | Processing error returned |

The tests validate that the CICS boundary preserves the result produced by
`VRCB0100`.

Business behavior is validated locally using the existing GnuCOBOL test
programs. CICS-specific execution requires a CICS runtime.

## CICS Integration Validation

Local validation confirms that the underlying `VRCB0100` Customer Add
business capability is executable and its success and error results are
already covered by the existing tests.

The CICS entry program `VRCB0100-CICS.cbl` cannot be compiled or executed
with the local GnuCOBOL toolchain because it contains CICS-specific
`EXEC CICS` statements.

Therefore:

- Business logic validation: completed locally
- CICS source/interface review: completed
- CICS runtime integration test: requires a CICS/Enterprise COBOL environment
- No CICS behavior is claimed as locally executed
