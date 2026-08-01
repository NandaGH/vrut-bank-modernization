Phase 5 — Legacy Asset Inventory (LAI)
This is one of the most valuable documents in a modernization project.
Many developers think:
"Let's see what programs are there."
Architects ask:
"What are the business capabilities, dependencies, risks, and modernization candidates?"
That difference is what we're going to learn.

1. Purpose
The Legacy Asset Inventory is the complete catalog of everything inside the Core Banking System.
Before anyone writes Java...
Before anyone builds APIs...
Before anyone migrates data...
They must know exactly what already exists.

2. Legacy Application Landscape
We won't build one huge COBOL program.
We'll simulate a realistic banking application.
                   VRUT CORE BANKING SYSTEM

                     +----------------------+
                     | Main Banking Menu    |
                     +----------+-----------+
                                |
        ------------------------------------------------
        |            |            |          |          |
   Customer      Account     Transaction   Inquiry    Batch
     Module       Module       Module      Module     Module
Each box is a separate business capability.

3. COBOL Program Inventory
Program ID
Program Name
Type
Description
Modernization Priority
VRCB000
Main Menu
Online
Entry point
Low
VRCB100
Customer Maintenance
Online
Customer management
High
VRCB110
Customer Validation
Online
Validate customer
High
VRCB200
Account Maintenance
Online
Account operations
High
VRCB210
Balance Inquiry
Online
Balance lookup
Medium
VRCB300
Cash Deposit
Online
Deposit transactions
High
VRCB310
Cash Withdrawal
Online
Withdrawals
High
VRCB400
Funds Transfer
Online
Transfer money
High
VRCB500
Mini Statement
Online
Last transactions
Medium
VRCB900
End-of-Day Batch
Batch
Interest & reports
High

Notice something important.
We are not creating one 3,000-line COBOL program.
We're creating a modular system.
That's how enterprise applications are structured.

4. Copybook Inventory
Copybook
Purpose
VRCP-CUSTOMER
Customer record
VRCP-ACCOUNT
Account record
VRCP-TRANSACTION
Transaction record
VRCP-AUDIT
Audit record
VRCP-MESSAGES
Common messages
VRCP-CONSTANTS
Business constants

These become reusable definitions shared across programs.

5. Legacy Files
File Name
Type
Purpose
CUSTOMER.DAT
Indexed
Customer master
ACCOUNT.DAT
Indexed
Account master
TRANS.DAT
Indexed
Transaction history
AUDIT.DAT
Sequential
Audit trail
REPORT.DAT
Sequential
Daily reports


6. Batch Jobs
Job
Purpose
VRBT001
End-of-Day Processing
VRBT002
Interest Calculation
VRBT003
Report Generation
VRBT004
Audit Archival


7. External Interfaces
Current state:
System
Method
Mobile Banking
None
ATM
File Exchange
CRM
CSV Import
Regulatory Reports
Batch File
Third Party
None

This becomes one of the strongest justifications for introducing REST APIs.

8. Modernization Candidates
This is where an architect starts thinking ahead.
Legacy Asset
Future State
Customer Module
Customer REST API
Account Module
Account REST API
Transfer Module
Transfer Service
Batch Reports
Scheduled Microservice
Indexed Files
PostgreSQL
Audit File
Audit Database
File Exchange
REST Integration

We're not deciding how yet—only identifying what is likely to evolve.

Deliverables
Store this as:
docs/05_Legacy_Asset_Inventory.md
No Git commit yet.
We'll wait until the next major milestone, because the LAI and the upcoming architecture documents naturally belong together.