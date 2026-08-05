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

Everything reusable goes into

VRCP9002

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