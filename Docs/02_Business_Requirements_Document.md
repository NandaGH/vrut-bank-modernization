Phase 3 – Business Requirements Document (BRD)
Document Version: 1.0
Project: Legacy Core Banking Modernization Platform (LCBMP)
Client: VRUT Bank
Program Name: Project Phoenix
Document Owner: Enterprise Modernization Office
Status: Approved (Baseline)

1. Executive Summary
VRUT Bank operates a stable COBOL-based Core Banking System that has supported business operations for over two decades.
While the platform remains reliable, it presents several challenges:
Digital channels require REST APIs.
Partner integration is difficult.
Customer information is distributed across legacy components.
End-of-day batch processing is difficult to monitor.
Introducing new products takes longer than business expects.
Rather than replacing the Core Banking System, VRUT Bank has initiated Project Phoenix, an incremental modernization program that preserves proven business logic while introducing API-first services, modern data access patterns, and cloud-ready architecture.

2. Business Objectives
The program aims to:
Preserve existing COBOL business rules.
Expose banking services through REST APIs.
Reduce integration effort with digital channels.
Improve maintainability.
Prepare workloads for future AWS deployment.
Enable phased modernization with minimal business disruption.

3. Business Scope (Phase 1)
In Scope
Customer Management
Customer Registration
Customer Search
Customer Profile Update
Customer Status

Account Management
Open Savings Account
Balance Inquiry
Cash Deposit
Cash Withdrawal
Mini Statement

Funds Transfer
Internal Account Transfer
Transfer Validation
Daily Transfer Limit
Transaction History

Daily Batch
Interest Calculation
End-of-Day Closing
Daily Transaction Report
Audit Log Generation

4. Out of Scope
These capabilities are intentionally excluded from Phase 1.
Credit Cards
Loans
Fixed Deposits
Mobile Banking UI
Internet Banking UI
ATM Network
UPI
NEFT/RTGS
SMS Gateway
Email Notifications
Fraud Detection
AI Assistant
These become future modernization phases.

5. Business Users
Role
Responsibility
Teller
Customer transactions
Branch Officer
Account creation
Branch Manager
Approval & reporting
Operations Team
Batch monitoring
IT Support
Incident support
API Consumer
Mobile App / Partner Systems


6. Business Rules
This is where enterprise projects become interesting.
Instead of writing code first, we define business rules.
Examples:
BR-001
 Customer ID must be unique.

BR-002
 A Savings Account cannot be opened unless the customer's KYC status is VERIFIED.

BR-003
 A closed account cannot receive deposits.

BR-004
 Withdrawal amount cannot exceed the available balance.

BR-005
 Daily transfer limit:
 ₹2,00,000

BR-006
 Every financial transaction must generate an audit record.

BR-007
 Interest is calculated only during End-of-Day Batch.

BR-008
 Business rules remain inside the COBOL layer until explicitly modernized.
This last rule is extremely important because it reflects how enterprises actually modernize.

7. Success Criteria
The modernization program is considered successful when:
Legacy COBOL continues to function correctly.
REST APIs expose business services.
No business rules are lost.
Existing batch jobs continue operating.
Architecture supports incremental migration.
New digital applications integrate without changing COBOL programs.

8. Risks
Risk
Mitigation
Business rule loss
Incremental migration
Data inconsistency
Validation & reconciliation
API failures
Logging & retry strategy
Legacy dependency
API façade pattern
Batch disruption
Keep batch unchanged initially


9. Modernization Principles
These principles will guide every future decision:
Business before Technology: Protect business value.
Incremental Change: Avoid big-bang rewrites.
API-First: New integrations use REST APIs.
Cloud-Ready: Every new component should be deployable to AWS.
Backward Compatible: Existing COBOL continues to operate during migration.
Observability: Logging and monitoring are built in from the start.

