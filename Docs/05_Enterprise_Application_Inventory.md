Phase 6 – Enterprise Application Inventory (EAI)
Why EAI instead of just LAI?
In real modernization engagements, a Legacy Asset Inventory often evolves into an Enterprise Application Inventory, because modernization teams inventory applications, jobs, data, interfaces, and dependencies together. This gives us a stronger foundation.

Objective
Answer these questions before writing any code:
What applications exist?
Who owns them?
What business function do they serve?
What datasets do they use?
What jobs execute them?
Which applications are modernization candidates?

1. Enterprise Portfolio
VRUT Bank has several enterprise applications, but Project Phoenix focuses on one.
Application ID
Application
Platform
Status
Modernization Scope
APP001
Core Banking System (CBS)
IBM Mainframe
In Scope
Yes
APP002
HR Management
Web
Out of Scope
No
APP003
Treasury
Mainframe
Out of Scope
No
APP004
Finance & GL
Mainframe
Out of Scope
No
APP005
CRM
Windows
Out of Scope
No

This makes the environment more believable than pretending the bank has only one application.

2. Core Banking Functional Modules
Within the Core Banking System:
Module ID
Module
Owner
Criticality
MOD01
Customer Management
Retail Banking
Critical
MOD02
Account Management
Retail Banking
Critical
MOD03
Cash Transactions
Branch Operations
Critical
MOD04
Funds Transfer
Payments
Critical
MOD05
Inquiry Services
Customer Service
High
MOD06
End-of-Day Processing
Operations
Critical

These modules will later map directly to packages in our API layer.

3. Program-to-Module Mapping
COBOL Program
Module
Purpose
VRCB0001
Menu
Main navigation
VRCB0100
Customer
Customer maintenance
VRCB0110
Customer
Customer validation
VRCB0200
Account
Open and maintain accounts
VRCB0210
Inquiry
Balance inquiry
VRCB0300
Cash
Deposit
VRCB0310
Cash
Withdrawal
VRCB0400
Transfer
Internal transfer
VRCB0500
Inquiry
Mini statement
VRCB0900
Batch
End-of-day processing

Notice that each program has one primary responsibility. That's a good architectural practice.

4. Copybook Inventory
We'll standardize our shared data definitions.
Copybook
Description
VRCP0101
Customer record layout
VRCP0201
Account record layout
VRCP0301
Transaction record layout
VRCP0401
Audit record layout
VRCP9001
Constants
VRCP9002
Error messages

We'll avoid embedding record layouts directly in COBOL programs.

5. Data Inventory
For the legacy phase, we'll use indexed files.
Logical Entity
Physical File
Access
Customer
CUSTOMER.DAT
Indexed
Account
ACCOUNT.DAT
Indexed
Transaction
TRANSACT.DAT
Indexed
Audit
AUDIT.DAT
Sequential
Daily Report
REPORT.DAT
Sequential

Later, these logical entities will be migrated to PostgreSQL tables while keeping the business model unchanged.

6. Batch Processing Inventory
Job
Purpose
Schedule
VRBT0001
Interest calculation
Daily
VRBT0002
Daily reconciliation
Daily
VRBT0003
Report generation
Daily
VRBT0004
Audit archival
Daily

We'll document these as if they were scheduled through an enterprise scheduler.

7. External Interfaces
Interface
Current Method
Future Method
Mobile Banking
Not available
REST API
Internet Banking
Not available
REST API
CRM
CSV import
REST API
Reporting
Batch files
Database/API
Partner Systems
Manual exchange
REST API

This table creates a clear modernization roadmap without changing business functionality.

8. Architectural Principles
These principles will guide implementation:
One business capability per COBOL program.
Shared layouts belong in copybooks.
Business rules remain in COBOL during Phase 1.
Modern services orchestrate rather than rewrite legacy logic.
Every new component must be independently testable.
Naming follows enterprise 8-character conventions for legacy artifacts.

Deliverables
Store this document as:
docs/05_Enterprise_Application_Inventory.md
We'll replace the earlier "Legacy Asset Inventory" with this richer document. It gives a broader, more realistic view of the enterprise.
Still no Git commit.
We'll make our first commit after we complete the architecture package.