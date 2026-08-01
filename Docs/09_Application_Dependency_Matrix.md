Phase 11 – Application Dependency Matrix (ADM)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: Application Dependency Matrix (ADM)

1. Purpose

The Application Dependency Matrix identifies the technical dependencies between legacy assets.

It answers:

Which program calls another program?
Which copybooks are shared?
Which datasets are accessed?
Which batch jobs depend on those datasets?
Which assets can be modernized independently?

This document is the foundation for a low-risk modernization strategy.

2. High-Level Dependency View
                    +--------------------+
                    |      VRCB0001      |
                    |    Main Menu       |
                    +---------+----------+
                              |
      -------------------------------------------------
      |          |            |          |            |
      ▼          ▼            ▼          ▼            ▼
   VRCB0100   VRCB0200    VRCB0300   VRCB0400    VRCB0500
 Customer     Account      Deposit    Transfer    Inquiry
Key Observation

VRCB0001 is only a navigation controller.

It contains no banking business logic.

That means it has Low Modernization Risk.

3. Program Dependency Matrix
Program	Calls	Reads	Updates	Copybooks	Risk
VRCB0001	VRCB0100,0200,0300,0400,0500	None	None	VRCP9002	Low
VRCB0100	VRCB0110	CUSTOMER	CUSTOMER	VRCP0101	Medium
VRCB0110	None	CUSTOMER	None	VRCP0101	Low
VRCB0200	VRCB0110	CUSTOMER	ACCOUNT	VRCP0101, VRCP0201	High
VRCB0210	None	ACCOUNT	None	VRCP0201	Low
VRCB0300	None	ACCOUNT	ACCOUNT, TRANSACT	VRCP0201, VRCP0301	High
VRCB0310	None	ACCOUNT	ACCOUNT, TRANSACT	VRCP0201, VRCP0301	High
VRCB0400	None	ACCOUNT	ACCOUNT, TRANSACT	VRCP0201, VRCP0301	Very High
VRCB0500	None	TRANSACT	None	VRCP0301	Low
VRCB0900	None	ACCOUNT, TRANSACT	ACCOUNT, REPORT	All	Very High
4. Copybook Dependency Matrix
Copybook	Used By
VRCP0101	VRCB0100, VRCB0110, VRCB0200
VRCP0201	VRCB0200, VRCB0210, VRCB0300, VRCB0310, VRCB0400
VRCP0301	VRCB0300, VRCB0310, VRCB0400, VRCB0500, VRCB0900
VRCP0401	VRCB0900
VRCP9001	All Programs
VRCP9002	All Programs
Observation

A change to VRCP0201 affects five COBOL programs.

This is why shared copybooks require careful version management.

5. Dataset Dependency Matrix
Dataset	Programs Using It	Batch Dependency
CUSTOMER	VRCB0100, VRCB0110, VRCB0200	No
ACCOUNT	VRCB0200, VRCB0210, VRCB0300, VRCB0310, VRCB0400, VRCB0900	Yes
TRANSACT	VRCB0300, VRCB0310, VRCB0400, VRCB0500, VRCB0900	Yes
AUDIT	All Transaction Programs	Yes
REPORT	VRCB0900	Generated Daily
Observation

The ACCOUNT dataset is one of the most critical assets in the system.

6. Batch Dependency Matrix
Batch Job	Depends On	Produces
VRBT0001	ACCOUNT	Updated Interest
VRBT0002	ACCOUNT, TRANSACT	Reconciliation Report
VRBT0003	CUSTOMER, ACCOUNT	Daily Reports
VRBT0004	AUDIT	Archive Files
Key Insight

Batch processing depends on the integrity of online transactions.

Modernization must preserve this relationship.

7. Modernization Impact Analysis
Asset	Dependency	Modernization Priority	Complexity
Customer Module	Medium	High	Medium
Account Module	High	High	High
Deposit Module	High	High	Medium
Withdrawal Module	High	High	Medium
Transfer Module	Very High	High	Very High
Batch Module	Very High	Phase 2	Very High
Strategy
Modernize low-risk capabilities first.
Protect highly shared datasets.
Delay batch transformation until APIs are stable.
8. Candidate API Extraction Order

Based on dependencies, we recommend:

Order	Capability	Reason
1	Customer	Lowest risk
2	Account Inquiry	Read-only
3	Account Maintenance	Moderate dependency
4	Deposit	Controlled updates
5	Withdrawal	Controlled updates
6	Transfer	Highest transactional complexity
7	Batch	Final modernization phase

This ordering minimizes business risk.

9. Enterprise Risk Assessment
Risk	Probability	Impact	Mitigation
Copybook Changes Affect Multiple Programs	High	High	Version Control & Regression Testing
Shared Dataset Corruption	Low	Critical	Transaction Validation
Batch Failure	Medium	High	Parallel Run Strategy
API Layer Failure	Medium	Medium	Retry & Monitoring
10. Architectural Conclusion

The analysis shows:

The system is modular enough for incremental modernization.
Customer services have the lowest modernization risk.
Funds Transfer has the highest business and technical complexity.
Batch processing should remain unchanged in the initial modernization phase.
Shared copybooks and datasets are the primary integration points.

These findings support a phased modernization strategy rather than a complete rewrite.
