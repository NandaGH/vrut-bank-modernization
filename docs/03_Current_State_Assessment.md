Phase 4 – Current State Assessment (CSA)
Document: Current State Assessment (CSA)
Version: 1.0
Client: VRUT Bank
Program: Project Phoenix
Status: Discovery Phase

1. Current Business Situation
VRUT Bank has been operating since 1998.
Its Core Banking System (CBS) was developed in COBOL and has evolved over more than two decades. The system has undergone many enhancements but was never designed for internet banking, mobile applications, or cloud-native integration.
Today, the system continues to support critical daily banking operations but struggles to meet modern digital expectations.
Captain's Note: This is a believable scenario. Many banks worldwide are in exactly this position—they are modernizing proven systems rather than replacing them.

2. Existing Technology Landscape
Layer
Current Technology
Status
Application
COBOL
Stable
Online Processing
Menu-driven terminal screens (CICS-like)
Stable
Batch Processing
JCL-style nightly jobs
Stable
Data Storage
Indexed Files (VSAM-like) + DB2
Stable
Reporting
Batch-generated reports
Stable
Integration
File exchanges
Limited
APIs
None
Gap
Cloud
None
Gap
Monitoring
Manual
Gap
Logging
Basic job logs
Gap

This is our "Before Modernization" landscape.

3. Existing Business Process
Let's walk through a common scenario: Opening a Savings Account.
Step 1
A customer visits a branch.
Step 2
The bank employee opens a terminal.
Step 3
Customer information is entered.
Step 4
The COBOL program validates:
Customer details
KYC status
Duplicate records
Step 5
A new account is created.
Step 6
The account record is stored.
Step 7
The transaction is written to an audit file.
Step 8
At the end of the day, the batch process updates reports and summaries.
This workflow has served the bank well for years.

4. Current Application Landscape
We'll model the legacy application as a set of COBOL programs, each with a clear responsibility.
Program ID
Name
Responsibility
VRCB100
Customer Maintenance
Customer operations
VRCB200
Account Maintenance
Account operations
VRCB300
Transaction Processing
Deposits & withdrawals
VRCB400
Funds Transfer
Internal transfers
VRCB500
Inquiry Services
Balance & statements
VRCB900
End-of-Day Batch
Daily processing

This modular structure reflects common enterprise COBOL systems.

5. Existing Data
The legacy system manages several core datasets.
Dataset
Purpose
CUSTOMER
Customer information
ACCOUNT
Account details
TRANSACTION
Financial transactions
AUDIT
Audit trail
DAILY_REPORT
End-of-day reports

For our project, we'll simulate these using indexed files while keeping the design ready for later migration to PostgreSQL.

6. Current Pain Points
This section is crucial because it justifies the modernization effort.
Pain Point
Business Impact
No REST APIs
Mobile and partner applications cannot integrate directly.
Tight coupling
Business logic and data access are intertwined, making changes difficult.
Batch dependency
Customers may wait until end-of-day for certain updates.
Limited observability
Troubleshooting relies on manual log inspection.
Manual deployments
Releases are slower and riskier.
Knowledge concentration
Understanding the system depends on a few experienced COBOL developers.

These are common challenges in long-lived enterprise systems.

7. Existing Strengths
Modernization should preserve what already works.
Strength
Why It Matters
Proven COBOL business logic
Reliable and tested over many years.
Stable transaction processing
Handles daily banking operations consistently.
Mature business rules
Encodes valuable domain knowledge.
Reliable batch processing
Supports regulatory and operational reporting.

A good modernization program builds on these strengths rather than discarding them.

8. Current State Summary
Current Architecture Characteristics
Monolithic COBOL application
File-centric processing
Branch-based operations
Nightly batch processing
No APIs
No cloud deployment
No containerization
Limited integration capabilities