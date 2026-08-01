Phase 7 – Application Flow Analysis (AFA)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Document Type: Application Flow Analysis

Objective

Understand how the existing Core Banking System processes business transactions.

This document answers:

What starts the transaction?
Which COBOL programs execute?
Which copybooks are used?
Which datasets are accessed?
Which business rules are applied?
What output is produced?

Think of this as the execution blueprint of the legacy system.

Enterprise Architecture
User (Branch Teller)
        │
        ▼
  Main Banking Menu
   (VRCB0001)
        │
        ▼
Select Business Function
        │
 ┌──────┼────────┬─────────┐
 ▼      ▼        ▼         ▼
Customer Account Transfer Inquiry

The Main Menu does not contain business logic.

It routes users to the appropriate business program.

This separation is common in enterprise COBOL applications.

Business Flow 1 – Customer Registration
Business Objective

Register a new customer in VRUT Bank.

Execution Flow
Teller Login
      │
      ▼
VRCB0001
(Main Menu)

      │
      ▼
VRCB0100
(Customer Maintenance)

      │
      ▼
Include VRCP0101
(Customer Copybook)

      │
      ▼
Validate Customer

      │
      ▼
Call VRCB0110

      │
      ▼
Check Duplicate Customer

      │
      ▼
Write CUSTOMER.DAT

      │
      ▼
Write AUDIT.DAT

      │
      ▼
Return Success
Programs
Program	Responsibility
VRCB0001	Menu
VRCB0100	Customer Maintenance
VRCB0110	Customer Validation
Files Used
File	Mode
CUSTOMER.DAT	Read / Write
AUDIT.DAT	Write
Copybooks
Copybook	Purpose
VRCP0101	Customer Record
VRCP9001	Constants
VRCP9002	Messages
Business Rules
Customer ID must be unique.
KYC status is mandatory.
Mobile number must be unique.
PAN number must be unique.
Audit record must always be written.
Business Flow 2 – Open Savings Account
Flow
Main Menu

↓

Account Maintenance

↓

Validate Customer

↓

Check Customer Status

↓

Generate Account Number

↓

Write ACCOUNT.DAT

↓

Audit

↓

Success

Programs

VRCB0001

↓

VRCB0200

↓

VRCB0110

Files

CUSTOMER.DAT

ACCOUNT.DAT

AUDIT.DAT

Business Rules

Customer must exist.
Customer must be ACTIVE.
KYC must be VERIFIED.
Minimum opening balance ₹1000.
Account number must be unique.
Business Flow 3 – Cash Deposit
Main Menu

↓

Deposit

↓

Validate Account

↓

Read Balance

↓

Update Balance

↓

Write Transaction

↓

Write Audit

↓

Return

Programs

VRCB0001

↓

VRCB0300

Files

ACCOUNT.DAT

TRANSACT.DAT

AUDIT.DAT

Business Rules

Deposit > 0.
Account must be ACTIVE.
Audit mandatory.
Business Flow 4 – Cash Withdrawal
Menu

↓

Withdrawal

↓

Validate Account

↓

Read Balance

↓

Check Available Balance

↓

Update Balance

↓

Write Transaction

↓

Audit

↓

Return

Business Rules

Balance cannot become negative.
Daily withdrawal limit applies.
Audit mandatory.
Business Flow 5 – Funds Transfer

This is the first truly enterprise-grade flow because it involves two accounts.

Main Menu

↓

Transfer

↓

Validate Source Account

↓

Validate Destination Account

↓

Check Balance

↓

Debit Source

↓

Credit Destination

↓

Write Transaction

↓

Write Audit

↓

Commit

Programs

VRCB0001

↓

VRCB0400

Files

ACCOUNT.DAT

TRANSACT.DAT

AUDIT.DAT

Business Rules

Source and destination accounts must differ.
Transfer amount must be positive.
Source account must have sufficient funds.
Both updates succeed together.
Audit is mandatory.
Business Flow 6 – End-of-Day Batch

This is the flow that recruiters expect you to understand.

Scheduler

↓

VRBT0001

↓

VRCB0900

↓

Read CUSTOMER

↓

Read ACCOUNT

↓

Calculate Interest

↓

Update Accounts

↓

Generate Report

↓

Archive Audit

↓

Job Complete

Notice:

No user starts this flow.

It is triggered automatically.

That distinction between online and batch processing is fundamental in mainframe systems.

Dependency Matrix
Program	Reads	Writes	Calls
VRCB0100	CUSTOMER	CUSTOMER	VRCB0110
VRCB0200	CUSTOMER	ACCOUNT	VRCB0110
VRCB0300	ACCOUNT	ACCOUNT, TRANSACT	—
VRCB0310	ACCOUNT	ACCOUNT, TRANSACT	—
VRCB0400	ACCOUNT	ACCOUNT, TRANSACT	—
VRCB0900	ACCOUNT	ACCOUNT, REPORT	—

This matrix is extremely valuable during modernization because it highlights dependencies and candidates for API extraction.