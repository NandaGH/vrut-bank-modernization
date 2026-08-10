Phase 13 – Legacy-to-Modern Component Mapping (LMCM)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: Legacy-to-Modern Component Mapping

1. Purpose

This document defines how each legacy component will evolve during the modernization journey.

It provides:

Migration planning
Scope definition
Impact analysis
Implementation roadmap
Traceability between legacy and modern components
2. Modernization Principles

For every component, one of the following modernization strategies will be applied:

Strategy	Meaning
Retain	Keep the component unchanged
Wrap	Expose existing COBOL through REST APIs
Refactor	Improve the component while preserving business logic
Replace	Rewrite using modern technologies
Retire	Remove because it is no longer required
3. COBOL Program Mapping
Legacy Program	Business Function	Phase 1	Future State	Strategy
VRCB0001	Main Menu	Retain	Navigation Layer	Retain
VRCB0100	Customer Maintenance	REST Wrapper	Customer Service	Wrap → Replace
VRCB0110	Customer Validation	Internal API	Validation Service	Wrap
VRCB0130.   CustomerRepository
VRCB0200	Account Maintenance	REST Wrapper	Account Service	Wrap → Replace
VRCB0210	Balance Inquiry	REST Wrapper	Inquiry Service	Wrap
VRCB0300	Deposit	REST Wrapper	Transaction Service	Wrap
VRCB0310	Withdrawal	REST Wrapper	Transaction Service	Wrap
VRCB0400	Fund Transfer	REST Wrapper	Transfer Service	Wrap → Replace
VRCB0500	Mini Statement	REST Wrapper	Statement Service	Wrap
VRCB0900	End-of-Day Batch	Retain	Containerized Batch	Refactor
4. Copybook Mapping
Copybook	Purpose	Future
VRCP0101	Customer Record Layout	Java DTO + JSON Model
VRCP0201	Account Record Layout	Java DTO + JSON Model
VRCP0301	Transaction Record Layout	Java DTO + JSON Model
VRCP0401	Batch Report Layout	Report DTO
VRCP9001	Common Constants	Shared Configuration
VRCP9002	Common Messages	Message Catalog
Why this matters

The same business data definitions will exist in both COBOL and Java during the coexistence phase.

5. Data Storage Mapping
Legacy Storage	Current	Future
CUSTOMER	Indexed File	PostgreSQL customer table
ACCOUNT	Indexed File	PostgreSQL account table
TRANSACT	Indexed File	PostgreSQL transaction table
AUDIT	Sequential File	PostgreSQL audit_log table
REPORT	Sequential File	Object Storage / Reports
6. JCL Mapping
Legacy Job	Current Function	Future
VRBT0001	Interest Calculation	Scheduled Container Job
VRBT0002	Reconciliation	Spring Batch
VRBT0003	Daily Reports	Reporting Service
VRBT0004	Archive Processing	Scheduled Archive Service
7. Interface Mapping
Current	Modern Target
3270 Screen	REST API
COBOL CALL	Internal Service Call
Indexed File Access	Repository Layer
Batch Execution	Scheduler + Containers
File Exchange	REST / Kafka (Phase 2)
8. Technology Mapping
Legacy	Modern
COBOL	COBOL + Java (Phase 1), Java (selected services in later phases)
VSAM Simulation	PostgreSQL
JCL	Spring Batch / AWS Scheduler
Sequential Files	JSON / CSV
Green Screen	REST APIs
Monolithic Application	Modular Services
9. Migration Timeline
Phase	Deliverables
Phase 1	REST wrappers around COBOL programs
Phase 2	Adapter Layer + API Gateway
Phase 3	Customer & Account services migrated
Phase 4	Transaction services migrated
Phase 5	Batch modernization & AWS deployment
10. Traceability Matrix
Business Capability	Legacy Asset	Modern Component
Customer Management	VRCB0100	Customer API + Customer Service
Account Management	VRCB0200	Account API + Account Service
Deposit	VRCB0300	Transaction API
Withdrawal	VRCB0310	Transaction API
Transfer	VRCB0400	Transfer API
Inquiry	VRCB0500	Statement API
Batch	VRCB0900	Batch Processing Service
11. Modernization Status

We'll use this table throughout the project.

Component	Status
Customer API	Planned
Account API	Planned
Transaction API	Planned
Adapter Layer	Planned
PostgreSQL Migration	Planned
Docker	Planned
AWS Deployment	Planned

As we implement each feature, we'll update this document. It becomes a living modernization dashboard.

12. Architectural Decision

The modernization program does not replace all COBOL immediately.

Instead, it follows a coexistence model:

COBOL remains the system of record during Phase 1.
Modern APIs provide external access.
Business capabilities are migrated incrementally.
Legacy components are retired only after successful validation.

This minimizes business risk while enabling steady modernization.