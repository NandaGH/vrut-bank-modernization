Phase 12 — Target Solution Architecture (TSA)

Document Version: 1.0

Project: Legacy Core Banking Modernization Platform (LCBMP)

Client: VRUT Bank

Program: Project Phoenix

Document Type: Target Solution Architecture

1. Purpose
Objective

Define the future-state architecture for modernizing VRUT Bank's legacy core banking system while preserving proven COBOL business logic and enabling cloud-native integration.

The architecture must:

Preserve existing business functionality.
Introduce REST APIs.
Enable containerization.
Support incremental migration.
Be deployable on AWS.
Minimize modernization risk.
2. Architecture Vision
Vision Statement

"Transform the legacy core banking platform into an API-enabled, cloud-ready architecture using incremental modernization, while preserving business-critical COBOL logic and ensuring uninterrupted banking operations."

This is exactly the kind of statement you would find in an enterprise architecture document.

3. Architecture Principles

These principles will guide every design decision.

ID	Principle	Description
AP-01	Business First	Preserve business rules before replacing technology.
AP-02	API First	New consumers interact through REST APIs.
AP-03	Incremental Modernization	Replace functionality in phases, not all at once.
AP-04	Loose Coupling	Components communicate through well-defined interfaces.
AP-05	Cloud Ready	New components are container-friendly and AWS deployable.
AP-06	Observability	Logging, metrics, and tracing are built in.
AP-07	Security by Design	Authentication, authorization, and audit are mandatory.
4. Modernization Strategy

After evaluating modernization approaches, Project Phoenix adopts the Strangler Fig Pattern.

Why?
Approach	Decision	Reason
Big Bang Rewrite	❌ Rejected	High business risk
Lift & Shift	❌ Rejected	No modernization value
Replatform	❌ Rejected	Limited long-term benefit
Strangler Fig Pattern	✅ Selected	Enables phased modernization with minimal disruption
Modernization Flow
Existing COBOL System
        │
        ▼
REST API Layer Introduced
        │
        ▼
New Consumers Use APIs
        │
        ▼
Business Capabilities Migrated One by One
        │
        ▼
Legacy Footprint Gradually Reduced
5. Target Architecture Overview

Instead of replacing the COBOL system, we'll place a modern service layer around it.

                         External Consumers
          (Web | Mobile | Internal Apps | Partners)
                               │
                               ▼
                         API Gateway
                               │
                               ▼
                    Spring Boot REST Services
                               │
                ┌──────────────┴──────────────┐
                │                             │
                ▼                             ▼
         Legacy Adapter Layer        Modern Business Services
                │                             │
                ▼                             ▼
        GnuCOBOL Programs             PostgreSQL (Future)
                │
                ▼
       Indexed Files / VSAM Simulation
Design Philosophy
Preserve what works.
Modernize what delivers business value.
Replace only when justified.
6. Target Technology Stack
Layer	Technology
Front-End Clients	Web, Mobile (Consumers only)
API Layer	Spring Boot
Programming	COBOL, Java, Python
Data Exchange	JSON
Messaging (Phase 2)	Kafka
Database	PostgreSQL
Legacy Storage	Indexed Files (GnuCOBOL)
Containerization	Docker
Cloud	AWS
Version Control	Git + GitHub
7. Component Responsibilities
Component	Responsibility
API Gateway	Route external requests securely
Spring Boot Services	Expose REST endpoints
Legacy Adapter	Translate REST requests into COBOL calls
COBOL Programs	Execute validated banking rules
PostgreSQL	Host modernized data (future phases)
Batch Engine	Continue end-of-day processing
8. Modernization Phases
Phase	Objective
Phase 1	API-enable COBOL applications
Phase 2	Introduce event-driven integration (Kafka)
Phase 3	Migrate selected capabilities to Java microservices
Phase 4	Containerize remaining legacy components
Phase 5	Deploy hybrid architecture on AWS
9. Security Architecture

The initial solution will include:

HTTPS for all APIs.
JWT-based authentication.
Role-based authorization.
Audit logging.
Request validation.
Input sanitization.
10. Non-Functional Requirements
Category	Target
Availability	99.9%
API Response	< 500 ms (non-batch operations)
Security	JWT + HTTPS
Scalability	Horizontal scaling for API layer
Maintainability	Modular architecture
Observability	Centralized logging and metrics
11. Risks and Mitigations
Risk	Mitigation
Business disruption	Incremental rollout using Strangler Fig
Data inconsistency	Single source of truth during Phase 1
API failures	Retry policies and logging
Legacy dependency	Adapter layer isolates COBOL from consumers
12. Expected Business Outcomes

Upon completion of the modernization program:

Legacy functionality remains intact.
Modern applications integrate via REST APIs.
Cloud deployment becomes practical.
Future microservice migration is simplified.
Operational risk is reduced through phased delivery.