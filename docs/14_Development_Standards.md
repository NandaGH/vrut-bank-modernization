Development Standards v1.0
COBOL Standards
Program Naming

Exactly 8 characters.

Examples

VRCB0100
VRCB0110
Divisions

Always

IDENTIFICATION DIVISION.
ENVIRONMENT DIVISION.
DATA DIVISION.
PROCEDURE DIVISION.

Never omit divisions.

Comments

Every program begins with:

Program Name

Purpose

Author

Created Date

Modification History

Exactly like enterprise systems.

Paragraph Naming

Example

1000-MAIN

2000-INITIALIZE

3000-PROCESS

4000-VALIDATE

5000-WRITE

9000-EXIT

No random paragraph names.

Variables

Working Storage

WS-


Linkage

LK-


File Section

FD
01

Copybook

No prefixes.

Constants

Everything reusable goes into

VRCP9001
Messages

Reusable message definitions go into the common message catalog.

Validation result interface

VRCP9002

Enterprise operation result

VRCP9003

No hardcoded messages.

Java Standards

Package

com.vrutbank.customer

Controller

CustomerController

Service

CustomerService

DTO

CustomerRequest

CustomerResponse

Entity

Customer

Repository

CustomerRepository

Copybook Contextualization Standard

Reusable copybooks must use a neutral CP- prefix for data-names that
may be reused in multiple COBOL contexts.

Example:

CP-CUSTOMER-RECORD
CP-CUSTOMER-ID
CP-CUSTOMER-FIRST-NAME

When the copybook is included, contextual data-names must be
explicitly replaced using COPY REPLACING.

Example:

COPY VRCP0101
    REPLACING
        CP-CUSTOMER-RECORD
            BY LK-CUSTOMER-RECORD
        CP-CUSTOMER-ID
            BY LK-CUSTOMER-ID
        CP-CUSTOMER-FIRST-NAME
            BY LK-CUSTOMER-FIRST-NAME.

Approved contexts:

FD-  File Section
LK-  Linkage Section
WS-  Working Storage

Explicit data-name replacement must be used rather than relying on
partial prefix substitution.

The CP- prefix is a copybook template convention only and must not
be exposed as part of an external API contract.

Context prefixes provide compile-time namespace separation and
reduce ambiguity when the same copybook is used multiple times
within a program.

Copybook contextualization must not alter the logical data layout,
PIC definitions, field lengths, or external interface semantics.