# AGENTS.md — Career360 Executive Engineering Protocol

## 1. Mission

Build **Career360 — Industry-Driven Career & Workforce Readiness Platform** as a production-oriented software product connecting:

- Students
- Colleges
- Companies

Career360 is centered on:

**Role → Competency → Skill → Evidence → Gap → Learning/Training → Reassessment → Readiness → Opportunity → Outcome**

Core business loop:

```text
Industry Demand
      ↓
Role Blueprint
      ↓
Skills / Competencies
      ↓
Assessment
      ↓
Evidence
      ↓
Skill Gap
      ↓
Learning / Training
      ↓
Practical Evidence
      ↓
Reassessment
      ↓
Role Readiness
      ↓
Jobs / Internships / Hiring
      ↓
Outcome & Employer Feedback
      ↺
Industry / Training Intelligence
```

Every implementation decision must preserve and strengthen this loop unless an explicit project decision says otherwise.

---

## 2. Source of Truth

Before implementing or changing functionality, inspect the applicable project specifications:

```text
docs/
├── 00_product_vision.md
├── 01_architecture_and_invariants.md
├── 02_domain_model.md
├── 03_skill_competency_model.md
├── 04_role_blueprint.md
├── 05_readiness_matching.md
├── 06_data_contracts.md
├── 07_security_authorization.md
├── 08_assessment_engine.md
├── 09_learning_training.md
├── 10_industry_intelligence.md
├── 11_opportunities_applications.md
├── 12_outcomes_analytics.md
├── 13_design_system.md
├── 14_integrations.md
├── 15_operations_runbook.md
└── 16_active_sprint.md
```

`docs/16_active_sprint.md` defines the current execution scope.

Do not implement future milestones simply because they are documented.

---

## 3. Active Milestone Discipline

1. Read `docs/16_active_sprint.md` before implementation.
2. Work only inside the active milestone.
3. Complete acceptance criteria before marking work complete.
4. Do not scaffold future features without a current milestone requirement.
5. Do not introduce infrastructure that is not required by the active milestone.
6. Update sprint status only after verification passes.
7. Resolve specification conflicts explicitly; do not silently invent behavior.

---

## 4. Product Definition

Career360 is primarily a:

- Career readiness platform
- Skill intelligence platform
- College workforce-preparation platform
- Industry training/readiness platform
- Opportunity and placement platform

It is not primarily a generic job board, LMS, assessment-only system, resume builder, certification marketplace, AI chatbot, or campus-recruitment clone.

Those may exist as supporting capabilities.

The central product capability is:

# Closed-Loop Role Readiness

The system must connect:

```text
What a role requires
        ↓
What a student/cohort can demonstrate
        ↓
What is missing
        ↓
What intervention is needed
        ↓
Whether capability improved
        ↓
Whether the person is ready
        ↓
Whether readiness leads to an opportunity/outcome
```

---

## 5. Core Domain Model

Primary domain chain:

```text
Organization
      ↓
Role Blueprint
      ↓
Competency
      ↓
Skill
      ↓
Assessment / Learning
      ↓
Evidence
      ↓
Skill Profile
      ↓
Gap
      ↓
Readiness
      ↓
Opportunity
      ↓
Outcome
```

Core entities include:

```text
User
Organization
Membership
StudentProfile
Skill
SkillAlias
Competency
RoleBlueprint
RoleRequirement
Assessment
AssessmentVersion
AssessmentAttempt
SkillObservation
Evidence
LearningItem
TrainingProgram
TrainingSession
TrainerAssignment
ReadinessResult
Opportunity
Application
IndustrySignal
EmployerFeedback
Outcome
Document
Report
Notification
Subscription
Payment
AuditLog
```

---

## 6. Role Blueprint Rules

`RoleBlueprint` is the central employer/industry model.

It may contain:

- Role identity
- Responsibilities
- Competencies
- Skills
- Required proficiency
- Requirement priority
- Eligibility rules
- Evidence requirements
- Practical evidence requirements
- Training/intervention recommendations
- Readiness conditions
- Version information

Requirement priority is:

```text
MUST
SHOULD
COULD
WON'T
```

An unsatisfied `MUST` requirement is a readiness blocker and cannot be hidden by an aggregate score.

---

## 7. Skill Taxonomy Rules

Career360 uses a canonical skill taxonomy.

Rules:

1. Use stable skill identifiers.
2. Use aliases/normalization instead of duplicate skills.
3. Maintain parent/child relationships where applicable.
4. Version important taxonomy changes.
5. Assessments, evidence, learning items and roles reference canonical skills.
6. Do not use uncontrolled skill strings as the authoritative matching mechanism.

Example:

```text
"Postgres"
"PostgreSQL"
"Postgres SQL"
        ↓
Canonical Skill
        ↓
PostgreSQL
```

---

## 8. Evidence-First Rule

Every authoritative capability claim must be traceable to evidence.

Evidence can originate from:

- Assessments
- Practical labs
- Projects
- Simulations
- Certifications
- Course completion
- Internships
- Mentor evaluations
- Faculty evaluations
- Employer evaluations
- Interviews

Evidence should retain:

- skill
- source type
- source reference
- score/proficiency where applicable
- verification state
- evidence date
- confidence/metadata

Course completion or certification must not automatically be treated as equivalent to demonstrated practical competency.

---

## 9. Readiness Rules

Career360 uses role-specific readiness.

Readiness considers:

- Skill fit
- Critical requirement satisfaction
- Practical evidence
- Evidence confidence
- Evidence freshness
- Behavioural requirements where applicable

Readiness states:

```text
NOT_ASSESSED
      ↓
ASSESSED
      ↓
GAP_IDENTIFIED
      ↓
IN_TRAINING
      ↓
PENDING_REASSESSMENT
      ↓
PROVISIONALLY_READY
      ↓
READY
```

Critical invariant:

> An unsatisfied `MUST` requirement prevents a candidate from being classified as fully `READY`.

Do not replace role readiness with one universal score.

The institutional Placement Readiness Index (PRI) may exist as a reporting metric, but it must not override role-specific critical blockers.

---

## 10. AI / GenAI Boundaries

AI is an assistive intelligence layer.

Allowed AI responsibilities include:

- Job description → skill extraction
- Job description → Role Blueprint proposal
- Skill normalization assistance
- Skill-gap explanations
- Training-plan proposals
- Career guidance
- Industry-signal summarization
- Report narrative generation
- Semantic similarity

AI must NOT independently determine:

- Final hiring decision
- Final eligibility
- Final assessment score
- Final authoritative proficiency
- Final authoritative readiness

Required AI flow:

```text
Raw Input
   ↓
AI Provider
   ↓
Structured Proposal
   ↓
Schema Validation
   ↓
Domain Validation
   ↓
Business Rules
   ↓
Persisted Authoritative Result
```

Treat model output as untrusted input until validated.

Do not allow LLM output to directly mutate authoritative business state.

---

## 11. AI Provider Abstraction

The core application must not depend directly on model SDK calls throughout the domain.

Use an abstraction conceptually equivalent to:

```text
AIProvider
    ├── GeminiProvider
    └── FutureProvider
```

Current provider:

**Gemini API**

A dedicated Python/FastAPI AI runtime may be introduced when document-processing, NLP, embedding or AI workload complexity requires it.

---

## 12. Core Backend

The authoritative backend stack is:

- Java 25 LTS
- Spring Boot 4.1.x
- Spring Security
- Spring Modulith
- Hibernate ORM 7
- jOOQ selectively
- Flyway
- REST + OpenAPI

Architecture:

# Modular Monolith

Initial modules:

```text
identity
organizations
students
colleges
companies
skills
competencies
roles
assessments
evidence
readiness
learning
training
opportunities
matching
applications
industry
outcomes
reporting
notifications
documents
billing
audit
```

Do not turn these into microservices during initial implementation.

---

## 13. Modular Architecture Rules

1. Each module owns its business logic.
2. Each module owns its persistence abstractions.
3. Do not directly manipulate another module's internal tables from unrelated domain code.
4. Use explicit interfaces/application services/events for cross-module behavior.
5. Prevent circular module dependencies.
6. Keep module responsibilities understandable.
7. Do not introduce distributed services merely to increase architectural complexity.

---

## 14. Database

Primary database:

# PostgreSQL 18.x

Initial managed environment:

# Aiven PostgreSQL Free

PostgreSQL is the authoritative system of record.

Use:

- relational tables for core business entities,
- database constraints,
- transactions,
- Flyway migrations,
- `pgvector`,
- `pg_trgm`,
- PostgreSQL full-text search,
- selective Row-Level Security.

Do not make a backend-as-a-service platform the application's core business layer.

---

## 15. Database Rules

Core business entities must be modeled relationally.

Authoritative relational data includes:

- organizations
- memberships
- roles
- requirements
- skills
- competencies
- assessments
- attempts
- evidence
- skill observations
- readiness
- learning/training
- opportunities
- applications
- outcomes
- audit records

Use JSONB only for genuinely extensible metadata.

Do not model the whole domain as uncontrolled JSON documents.

---

## 16. Transaction Rules

Critical operations must be transactional, including:

- role requirement changes,
- assessment completion,
- evidence creation,
- readiness updates,
- training state changes,
- reassessment,
- application state transitions,
- placement outcome recording,
- subscription/entitlement changes.

A failed transaction must not leave partially updated authoritative state.

---

## 17. Multi-Tenancy

Career360 is multi-organization.

Organizations include:

- Colleges
- Companies
- Platform administration

Relationships must be explicit.

Example:

```text
Student
   ↕
College Membership

Student
   ↕
Application
   ↕
Company
```

Every protected operation must validate:

```text
identity
+
organization membership
+
role
+
resource
+
resource scope
+
action
```

Prevent cross-tenant access at every layer.

---

## 18. Authorization

Use:

# RBAC + Resource Scope

Examples:

```text
Faculty
+
Own Assigned Batch
+
VIEW_STUDENT_PROFILE
```

```text
Student
+
Self
+
VIEW_OWN_READINESS
```

```text
Recruiter
+
Authorized Opportunity
+
VIEW_CANDIDATE
```

Frontend route visibility is not authorization.

Backend authorization is mandatory.

---

## 19. Security Invariants

Forbidden:

- hardcoded credentials,
- committed secrets,
- unvalidated external input,
- unparameterized SQL,
- client-only authorization,
- uncontrolled tenant access,
- sensitive stack traces in API responses,
- secrets in logs,
- public sensitive documents,
- unvalidated AI output,
- unauthenticated webhook processing.

Required:

- secure secret handling,
- input validation,
- safe error responses,
- authorization,
- audit logging,
- controlled file access,
- traceability.

---

## 20. Object Storage

Initial object storage:

# Cloudflare R2

Store:

- resumes,
- certificates,
- reports,
- profile assets,
- assessment exports,
- internship documents,
- company documents.

PostgreSQL stores object metadata/references.

Sensitive files must not be public by default.

---

## 21. Search

Initial search stack:

# PostgreSQL Full-Text Search + pg_trgm

Use PostgreSQL indexes and search capabilities before introducing an external search cluster.

Semantic similarity uses:

# pgvector

Do not introduce Elasticsearch/OpenSearch or a separate vector database without an active requirement and architectural decision.

---

## 22. Cache

Initial cache:

# Caffeine

Use only for suitable read-heavy reference data.

Do not introduce Redis/Valkey in V1 unless distributed caching becomes a measured requirement.

Future path:

```text
Caffeine
    ↓
Valkey / Redis
```

---

## 23. Asynchronous Processing

Initial architecture:

# PostgreSQL-backed Job Queue + Spring Workers

Use jobs for:

- bulk student imports,
- report generation,
- notifications,
- document processing,
- AI processing,
- readiness recalculation,
- large exports.

Job records must support:

- status,
- attempt count,
- retry timing,
- locking,
- failure information,
- completion information.

Workers must be idempotent where retries can occur.

---

## 24. Messaging Escalation

Do not introduce Kafka/RabbitMQ in V1 without a demonstrated need.

Evolution path:

```text
PostgreSQL Job Queue
        ↓
RabbitMQ
        ↓
Kafka / event streaming
```

Use RabbitMQ when dedicated job/message infrastructure is required.

Use Kafka only when high-volume event streaming, replay, pipelines or multiple independent stream consumers are actual requirements.

---

## 25. Workflow Engine

Do not introduce Temporal initially.

Use explicit domain state and PostgreSQL-backed processing.

A durable workflow engine may be introduced later for genuinely long-running, multi-stage workflows whose complexity exceeds the application state-machine model.

---

## 26. Infrastructure

Initial deployment:

```text
React/Vite
    ↓
Cloudflare Pages
    ↓
Google Cloud Run
    ↓
Spring Boot
    ↓
Aiven PostgreSQL
```

Supporting:

```text
Cloudflare R2
Gemini API
```

Do not introduce Kubernetes in the initial architecture.

---

## 27. Cost-Control Rules

Career360 is intentionally designed for free/low-cost development and pilot operation.

Initial infrastructure:

- Cloudflare Pages
- Google Cloud Run
- Aiven PostgreSQL Free
- Cloudflare R2
- Gemini API within applicable limits
- Docker/local development

Rules:

1. Prefer standard protocols and portable data formats.
2. Never make a vendor-specific backend service authoritative for core business logic.
3. Do not introduce paid infrastructure without a documented product/scale requirement.
4. Use conservative resource limits where appropriate.
5. Monitor free-tier usage.
6. Configure billing alerts where available.
7. Keep the database connection pool compatible with the Aiven free-tier limits.
8. Do not assume free-tier services provide enterprise availability guarantees.

---

## 28. Provider Portability

External services must be isolated behind application interfaces.

Examples:

```text
AIProvider
StoragePort
EmailPort
QueuePort
IdentityProvider
CachePort
```

Business domains must not directly depend on provider SDKs.

Target migration paths:

```text
Aiven Free PostgreSQL
    ↓
Aiven Paid / Cloud SQL / RDS

Caffeine
    ↓
Valkey / Redis

PostgreSQL Jobs
    ↓
RabbitMQ

R2
    ↓
S3 / GCS

Gemini
    ↓
Alternative Provider / Dedicated AI Service
```

Domain logic must remain stable across infrastructure changes.

---

## 29. API Architecture

All APIs are versioned:

```text
/api/v1
```

Primary API domains:

```text
/api/v1/auth
/api/v1/organizations
/api/v1/students
/api/v1/skills
/api/v1/roles
/api/v1/assessments
/api/v1/evidence
/api/v1/readiness
/api/v1/learning
/api/v1/training
/api/v1/opportunities
/api/v1/applications
/api/v1/industry
/api/v1/outcomes
/api/v1/reports
```

Use OpenAPI for contract documentation.

---

## 30. API Contract

Success:

```json
{
  "success": true,
  "data": {},
  "meta": {
    "timestamp": "ISO8601",
    "traceId": "string"
  }
}
```

Failure:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message",
    "details": []
  }
}
```

API contracts must remain consistent.

---

## 31. Frontend

Frontend stack:

- React 19.x
- Vite 8.x
- TypeScript
- Tailwind CSS 4.x
- shadcn/ui
- TanStack Query

Rules:

- strict TypeScript,
- no `any`,
- no unsafe casts,
- no error suppression,
- shared UI primitives,
- API contracts respected,
- role-aware navigation,
- responsive behavior,
- accessibility.

Do not implement business authorization solely in frontend code.

---

## 32. UI State Matrix

Every asynchronous/data-driven component must implement:

```text
IDLE
LOADING
ERROR
EMPTY
```

Loading states must preserve layout where practical.

Error states must provide useful recovery.

Empty states must explain the absence of data and provide an appropriate action when possible.

---

## 33. Assessment Engine

Assessments must support:

- authoring,
- versioning,
- question bank,
- skill tags,
- assignments,
- attempts,
- scoring,
- per-skill results,
- attempt history,
- reassessment rules.

Completed attempts must be auditable and must not be silently altered.

---

## 34. Evidence Engine

Evidence must link:

```text
Student
   ↓
Skill
   ↓
Evidence Source
```

Evidence sources may include:

- assessment,
- project,
- practical,
- internship,
- certification,
- course,
- mentor,
- faculty,
- employer.

Every evidence record should retain provenance and verification status.

---

## 35. Learning and Training

Learning items may include:

```text
Course
Project
Lab
Workshop
Certification
Simulation
Mentor Session
```

Every learning item should declare applicable skill relationships.

Training programmes may contain:

- target role,
- target cohort,
- skill gaps,
- learning modules,
- trainers,
- schedule,
- progress,
- reassessment.

Completion alone does not establish competency.

---

## 36. Company Training

Required workflow:

```text
Role Blueprint
      ↓
Target Cohort / Candidate Pool
      ↓
Baseline Assessment
      ↓
Capability Matrix
      ↓
Skill Gaps
      ↓
Training Program
      ↓
Trainer Allocation
      ↓
Training
      ↓
Practical Evidence
      ↓
Reassessment
      ↓
Role Readiness
```

---

## 37. Opportunity and Matching

Opportunities include:

- jobs,
- internships,
- other authorized workforce opportunities.

Opportunity requirements should reference structured role requirements.

Matching must evaluate:

- eligibility,
- skills,
- proficiency,
- requirement priority,
- evidence,
- readiness.

Matching results must be explainable.

---

## 38. Industry Intelligence

Industry intelligence may use:

- job descriptions,
- employer-defined roles,
- structured industry sources,
- recruitment outcomes,
- employer feedback,
- historical platform signals.

Pipeline:

```text
Raw Source
    ↓
Extraction
    ↓
Normalization
    ↓
Skill Mapping
    ↓
Role Aggregation
    ↓
Demand Signal
    ↓
Trend / Intelligence View
```

Important signals should retain:

- source,
- observation date,
- context,
- confidence.

AI may summarize structured signals but must not replace their provenance.

---

## 39. College Analytics

Institutional hierarchy:

```text
Student
   ↓
Batch
   ↓
Department
   ↓
College
```

Industry context:

```text
Industry Role
   ↓
College
   ↓
Department
   ↓
Batch
   ↓
Student
```

Analytics may cover:

- skill gaps,
- role readiness,
- training progress,
- assessment completion,
- readiness trends,
- placement pipeline,
- placement outcomes,
- industry demand.

---

## 40. Reports

Core reports:

- Career Readiness Report
- Student Skill Card
- Batch Skill Gap Report
- Department Readiness Report
- College Industry Readiness Report
- Candidate Readiness Report
- Training Outcome Report
- Placement Outcome Report
- Industry Trend Report

Large reports must be processed asynchronously.

---

## 41. Notifications

Notification domain supports:

- assessment assignment,
- deadline reminder,
- result notification,
- training notification,
- application update,
- report-ready notification,
- alert.

Initial channels:

- in-app,
- email.

Additional channels must integrate through the notification abstraction.

---

## 42. Billing

Billing is an organization-level capability.

Conceptual entities:

```text
Plan
Entitlement
Subscription
SubscriptionPeriod
Usage
Invoice
Payment
```

Feature limits must be managed through centralized entitlement logic.

---

## 43. Audit

Audit records should capture, where applicable:

```text
actor
organization
action
resource
resource_id
timestamp
change summary
trace/request context
```

Audit sensitive actions such as:

- role requirement changes,
- assessment configuration changes,
- student state changes,
- candidate shortlisting,
- organization changes,
- outcome recording.

---

## 44. Data Lifecycle

Historical business facts must remain interpretable.

Where appropriate use:

- versioning,
- effective dates,
- snapshots,
- event records,
- soft deletion.

Do not destructively overwrite data when history is required for reporting or audit.

---

## 45. Frontend User Experiences

### Student

```text
Profile
→ Target Role
→ Assessment
→ Skill Profile
→ Gap
→ Roadmap
→ Learning/Project
→ Evidence
→ Reassessment
→ Readiness
→ Opportunity
→ Application
```

### College

```text
College
→ Department
→ Batch
→ Students
→ Target Roles
→ Assessment
→ Skill Heatmap
→ Training
→ Reassessment
→ Readiness
→ Placement
→ Outcomes
```

### Company

```text
Company
→ Role
→ Role Blueprint
→ Assessment
→ Capability Matrix
→ Ready / Trainable Pool
→ Training
→ Reassessment
→ Ready Pool
→ Interview
→ Hire
→ Feedback
```

---

## 46. Golden Product Workflow

The primary system acceptance flow is:

```text
Company creates Graduate Backend Engineer role
        ↓
Role Blueprint:
Java / SQL / REST / Git / Testing
        ↓
College selects target cohort
        ↓
Career360 conducts baseline assessment
        ↓
Per-skill capability recorded
        ↓
Critical gaps identified
        ↓
Training track created
        ↓
Students complete learning/projects
        ↓
Practical evidence recorded
        ↓
Reassessment
        ↓
Role readiness recalculated
        ↓
Company receives explainable ready pool
        ↓
Students apply
        ↓
Hiring outcome recorded
        ↓
Employer feedback stored
```

---

## 47. Repository Structure

```text
career360/
├── AGENTS.md
├── .antigravityignore
│
├── frontend/
├── backend/
├── ai/
├── db/
├── infra/
│
├── docs/
│   ├── 00_product_vision.md
│   ├── 01_architecture_and_invariants.md
│   ├── 02_domain_model.md
│   ├── 03_skill_competency_model.md
│   ├── 04_role_blueprint.md
│   ├── 05_readiness_matching.md
│   ├── 06_data_contracts.md
│   ├── 07_security_authorization.md
│   ├── 08_assessment_engine.md
│   ├── 09_learning_training.md
│   ├── 10_industry_intelligence.md
│   ├── 11_opportunities_applications.md
│   ├── 12_outcomes_analytics.md
│   ├── 13_design_system.md
│   ├── 14_integrations.md
│   ├── 15_operations_runbook.md
│   └── 16_active_sprint.md
│
└── .agents/
    ├── rules/
    ├── skills/
    ├── agents/
    ├── hooks.json
    └── mcp_config.json
```

---

## 48. Development Workflow

### Before editing

- Read the relevant specification.
- Inspect current implementation.
- Identify affected modules.
- Check existing patterns.
- Identify acceptance criteria.

### During editing

- Implement complete behavior.
- Respect domain boundaries.
- Keep work within the active sprint.
- Reuse established patterns.
- Avoid unrelated refactors.
- Do not introduce unnecessary infrastructure.

### After editing

- Run verification.
- Inspect failures.
- Fix root causes.
- Validate relevant user flows.
- Update sprint status.

---

## 49. Zero Placeholder Rule

Production code must not contain incomplete implementations such as:

```text
TODO
FIXME
stub
placeholder
fake response
demo-only logic
coming soon
```

Test doubles are permitted only within controlled test boundaries.

A UI shell is not an implemented feature.

---

## 50. Strict Type Safety

### TypeScript

Forbidden in production:

```text
any
unsafe casts
@ts-ignore
suppression used to hide implementation problems
```

### Java

Avoid:

- raw types,
- swallowed exceptions,
- unchecked assumptions,
- unnecessary reflection.

### Python AI service

Use Pydantic models for structured external and AI data.

---

## 51. Error Handling

API errors must:

- use stable codes,
- use safe human-readable messages,
- avoid exposing internal stack traces,
- include trace identifiers when appropriate,
- distinguish retryable failures where useful.

Domain logic must reject invalid state transitions.

Database failures must not leave partial state.

Async jobs must record failure state.

External-provider failures must be handled explicitly.

---

## 52. Observability

Required foundations:

- structured logs,
- request/trace IDs,
- exception/error visibility,
- job status monitoring,
- database latency/connection metrics,
- AI latency/failure metrics,
- report-processing metrics,
- business metrics.

Use:

# OpenTelemetry

Initial operational visualization may use available cloud logging/metrics.

A dedicated Prometheus/Grafana environment can be introduced when justified by operating scale.

---

## 53. Performance

Performance must be measured rather than assumed.

Primary engineering priorities:

- efficient indexes,
- bounded queries,
- pagination,
- efficient joins,
- connection-pool control,
- asynchronous large workloads,
- selective caching,
- profiling before optimization.

Initial Aiven PostgreSQL resource constraints must be respected.

Avoid unbounded queries and unnecessarily large result sets.

---

## 54. Aiven Free-Tier Constraints

Initial Aiven PostgreSQL environment is resource-constrained.

Current baseline includes:

```text
1 CPU
1 GB RAM
1 GB storage
20 maximum connections
```

Engineering implications:

- use a conservative HikariCP pool,
- paginate large queries,
- index important paths,
- avoid unnecessary polling,
- monitor storage,
- separate test/demo data from real data.

---

## 55. Testing Strategy

Required testing levels:

```text
Unit
  ↓
Integration
  ↓
API/Contract
  ↓
Frontend Component
  ↓
End-to-End
  ↓
Acceptance
```

Primary tools:

- JUnit
- Testcontainers
- Vitest
- React Testing Library
- Playwright

High-value tests cover:

- readiness,
- skill-gap calculation,
- MUST blockers,
- eligibility,
- matching,
- training state transitions,
- tenant isolation,
- authorization,
- assessment integrity.

---

## 56. Testcontainers Rules

Use real infrastructure in integration tests where behavior depends on infrastructure.

PostgreSQL integration tests should not rely only on mocks.

When additional infrastructure is introduced later, it may be covered through Testcontainers-based integration tests.

---

## 57. Playwright Rules

Browser validation is required for UI milestones.

Critical E2E paths include:

- Student target-role journey,
- College cohort/readiness journey,
- Company Role Blueprint journey,
- Assessment submission,
- Training/reassessment,
- Opportunity/application flow.

---

## 58. Definition of Done

A feature is complete only when applicable requirements are satisfied:

```text
Requirement defined
        ↓
Domain behavior defined
        ↓
Data model defined
        ↓
API contract defined
        ↓
Authorization defined
        ↓
Implementation complete
        ↓
Validation complete
        ↓
Error handling complete
        ↓
UI states complete
        ↓
Tests complete
        ↓
Audit/observability handled
        ↓
Acceptance criteria pass
        ↓
Fast verification passes
        ↓
Browser validation passes
        ↓
Full verification passes
        ↓
Sprint status updated
```

---

## 59. Verification Protocol

Before reporting an implementation task complete:

1. Inspect the relevant project documentation.
2. Implement the required behavior completely.
3. Run the fast verification script.
4. Run relevant unit/integration/API tests.
5. Run browser validation for UI work.
6. Verify acceptance scenarios.
7. Fix all identified failures.
8. Update `docs/16_active_sprint.md`.
9. Run the full verification suite before milestone completion.

---

## 60. Builder Agent Rules

Builder agents must:

- inspect applicable specifications before editing,
- implement complete functionality,
- respect module boundaries,
- maintain strict typing,
- validate external input,
- avoid placeholders,
- avoid changing product scope,
- run applicable verification before returning.

Builder agents must not silently introduce infrastructure or alter the core architecture.

---

## 61. Auditor Agent Rules

The auditor is read-only with respect to source implementation.

It must:

- inspect code,
- inspect architecture,
- execute tests,
- validate acceptance scenarios,
- identify exact failures,
- identify root causes,
- inspect browser behavior when required,
- return structured findings.

It must not modify implementation directly.

---

## 62. Change-Control Rules

Changes to the following require documentation before implementation:

- core domain model,
- Role Blueprint structure,
- readiness logic,
- skill taxonomy,
- tenant model,
- authorization model,
- database architecture,
- infrastructure dependency,
- AI provider architecture.

The change record must capture:

```text
Problem
Current behavior
Proposed change
Impact
Security impact
Cost impact
Migration impact
Testing impact
```

---

## 63. Infrastructure Escalation Rules

The following are not initial dependencies:

```text
Redis / Valkey
RabbitMQ
Kafka
Temporal
Elasticsearch / OpenSearch
Neo4j
Kubernetes
Dedicated vector database
Dedicated AI service
Keycloak
```

They may be introduced only when an actual requirement is documented and the migration impact is understood.

---

## 64. Product Metrics

Primary product metrics:

- Time-to-Ready
- Role Readiness Rate
- Gap Closure Rate
- Time-to-Qualified-Cohort
- Ready-to-Hire Conversion
- Evidence Coverage
- Post-Hire Alignment
- Assessment Completion
- Training Completion
- Readiness Improvement

Primary technical metrics:

- API latency
- error rate
- database latency
- connection-pool pressure
- job processing duration
- job failure/retry rate
- AI latency/failure rate
- report-generation duration

Metrics must come from actual system data.

---

## 65. Launch Gate

The initial production/pilot release is complete when the system can execute the complete core loop:

```text
Company Role
    ↓
Role Blueprint
    ↓
Assessment
    ↓
Skill Profile
    ↓
Skill Gap
    ↓
Training
    ↓
Evidence
    ↓
Reassessment
    ↓
Role Readiness
    ↓
Opportunity
    ↓
Application / Hiring
    ↓
Outcome
```

Required launch validation includes:

- tenant isolation,
- authorization,
- database migration/recovery,
- critical workflow testing,
- UI accessibility/state coverage,
- observability,
- controlled documents,
- AI validation,
- performance/load assessment,
- deployment/rollback procedure.

---

## 66. Product Scope Priorities

### P0

```text
Identity
Organizations
RBAC
Tenant Isolation
Skills
Competencies
Role Blueprints
Assessments
Evidence
Readiness
Learning
Training
Jobs / Internships
Matching
Applications
Basic Analytics
Reports
Audit
```

### P1

```text
Industry Intelligence
JD ingestion
Advanced skill normalization
Training intelligence
Trainer allocation
Advanced evidence
Employer evaluation
Employer feedback
Outcome analytics
Time-to-Ready
```

### P2

```text
Faculty-industry programmes
FDP
Research collaboration
Consulting
Mentorship marketplace
Advanced workforce planning
Cross-college benchmarking
Predictive analytics
Large learning marketplace
```

---

## 67. Final Architecture Summary

```text
                         USERS
                           │
                           ▼
                   Cloudflare Pages
                React + Vite + TypeScript
                           │
                         HTTPS
                           │
                           ▼
                    Google Cloud Run
                 Spring Boot + Java 25
                  Spring Modulith
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
 Aiven PostgreSQL      Cloudflare R2       Gemini API
   PostgreSQL 18          Documents             AI
   pgvector
   pg_trgm
   FTS
   Job Queue
```

Core domains:

```text
Identity
Organizations
Students
Colleges
Companies
Skills
Competencies
Roles
Assessments
Evidence
Readiness
Learning
Training
Opportunities
Matching
Applications
Industry
Outcomes
Reporting
Notifications
Documents
Billing
Audit
```

---

## 68. Final Project Engineering Principle

Career360 follows a **PostgreSQL-first, Spring Boot modular-monolith architecture**. External infrastructure is introduced only when a measurable scalability, reliability, security or product requirement justifies it.

The core application must remain independent of:

- backend-as-a-service platforms,
- database-vendor application APIs,
- AI-provider-specific business logic,
- storage-provider-specific domain logic,
- queue-provider-specific domain logic.

The domain model and business rules remain authoritative inside Career360.

---

## 69. Final Mission Statement

> **Career360 continuously translates evolving industry requirements into measurable competencies, identifies capability gaps in students and cohorts, enables targeted learning and training, validates improvement through evidence and reassessment, determines explainable role readiness, connects demonstrably ready talent to relevant opportunities, and captures outcomes for the next cycle of industry and workforce intelligence.**
