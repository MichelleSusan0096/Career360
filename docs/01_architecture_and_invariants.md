# Career360 — Architecture & Invariants

**Document:** `docs/01_architecture_and_invariants.md`  
**Status:** Product/Engineering Architecture Baseline  
**Applies to:** Career360 platform and all current implementation milestones  
**Primary owner:** Engineering  
**Related source:** `docs/00_product_vision.md`

---

## 1. Purpose

This document defines the architectural structure and non-negotiable invariants for Career360.

The objective is not to describe every implementation detail. The objective is to establish the boundaries that every feature, module, API, database change, UI flow, background worker and integration must respect.

Career360 is a production-oriented platform centered on **Closed-Loop Role Readiness**:

```text
Industry Requirement
        ↓
Role Blueprint
        ↓
Competencies / Skills
        ↓
Assessment
        ↓
Evidence
        ↓
Gap
        ↓
Learning / Training
        ↓
Practical Evidence
        ↓
Reassessment
        ↓
Role Readiness
        ↓
Opportunity
        ↓
Outcome
        ↓
Employer Feedback / Industry Intelligence
        ↺
```

Architecture must preserve this loop rather than optimize isolated features.

---

## 2. Architectural North Star

Career360 is one product with strongly separated business domains.

The initial architecture is a **modular monolith** implemented as one Spring Boot application. Modules are logically isolated even though they share one deployable backend and one PostgreSQL database.

The initial deployment topology is:

```text
                    ┌───────────────────────────┐
                    │          Users             │
                    │ Student / College /        │
                    │ Company / Staff            │
                    └─────────────┬─────────────┘
                                  │ HTTPS
                                  ▼
                    ┌───────────────────────────┐
                    │ Cloudflare Pages          │
                    │ React + TypeScript        │
                    └─────────────┬─────────────┘
                                  │ HTTPS / REST
                                  ▼
                    ┌───────────────────────────┐
                    │ Google Cloud Run          │
                    │ Spring Boot Backend       │
                    │ Modular Monolith          │
                    └─────┬────────┬────────┬───┘
                          │        │        │
              ┌───────────┘        │        └────────────┐
              ▼                    ▼                     ▼
   ┌──────────────────┐   ┌─────────────────┐   ┌─────────────────┐
   │ Aiven PostgreSQL │   │ Cloudflare R2   │   │ Gemini API      │
   │ PostgreSQL 18.x  │   │ Object Storage  │   │ AI Assistance   │
   └──────────────────┘   └─────────────────┘   └─────────────────┘
```

PostgreSQL is the primary transactional system of record. Object storage is used for files. AI is an assistive dependency, not an authoritative source of business truth.

---

## 3. Architecture Principles

The following principles govern all implementation decisions.

### 3.1 Product-first architecture

Technical decisions must support the Career360 product model rather than exist only for technology demonstration.

### 3.2 Domain ownership

Each business concept has a clear owning module. Other modules interact through defined contracts rather than reaching directly into another module's persistence internals.

### 3.3 PostgreSQL-first

PostgreSQL is the initial source of truth for transactional data, relational integrity, search capabilities supported by PostgreSQL, and the initial durable job queue.

### 3.4 Modular monolith before microservices

The system must not be split into distributed services merely for architectural appearance. Extraction into a separate service is justified only when measurable scale, reliability, deployment independence, workload isolation, or ownership requirements make it necessary.

### 3.5 Provider portability

Business/domain code must not depend directly on provider-specific infrastructure APIs when a stable application port can be used instead.

### 3.6 Evidence before claims

Authoritative capability claims must be backed by recorded evidence and remain traceable to their sources.

### 3.7 Explicit business rules

Critical readiness, eligibility and scoring behavior must be deterministic and testable. AI-generated suggestions must never silently become authoritative decisions.

### 3.8 Historical explainability

Assessment, readiness, role requirement and related historical results must remain interpretable under the rules and versions that generated them.

### 3.9 Secure by default

Authorization, tenant isolation, input validation, auditability and secret handling are architectural concerns, not optional post-development tasks.

### 3.10 Verify continuously

Code is not considered complete merely because it compiles. Unit, integration, contract and browser/UI verification must be applied at the appropriate scope.

---

## 4. Logical Architecture

Career360 is organized into layers with controlled dependency direction.

```text
┌─────────────────────────────────────────────────────────────┐
│ Presentation / API                                          │
│ REST controllers, request validation, response envelopes    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Application / Use Cases                                      │
│ Commands, queries, orchestration, transactions              │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Domain Modules                                               │
│ Business rules, aggregates, policies, domain services        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Infrastructure                                              │
│ PostgreSQL, jOOQ/JPA adapters, R2, queue, email, AI, cache   │
└─────────────────────────────────────────────────────────────┘
```

The exact package structure may evolve, but dependency direction must remain clear.

### 4.1 Presentation/API layer

Responsibilities:

- HTTP transport.
- Authentication context extraction.
- Request DTO validation.
- Response DTO mapping.
- OpenAPI contract exposure.
- HTTP status handling.
- Pagination/filter/sort contract enforcement.
- Consistent error responses.

The API layer must not contain substantial domain decisions.

### 4.2 Application layer

Responsibilities:

- Execute business use cases.
- Coordinate domain modules.
- Define transaction boundaries.
- Load required state through application-facing ports.
- Publish domain/application events where required.
- Invoke infrastructure ports.

Use-case services should express business actions such as:

```text
CreateRoleBlueprint
PublishRoleBlueprint
AssignAssessment
RecordAssessmentAttempt
SubmitEvidence
CalculateReadiness
CreateTrainingProgram
ReassessLearner
PublishOpportunity
SubmitApplication
RecordEmployerFeedback
```

### 4.3 Domain layer

Responsibilities:

- Core business concepts.
- Invariants.
- Policies.
- Value objects.
- State transitions.
- Domain-specific validation.
- Deterministic readiness and matching rules.

Domain code must not require an HTTP request, browser, provider SDK or cloud runtime to execute core business rules.

### 4.4 Infrastructure layer

Responsibilities:

- Persistence implementation.
- External provider adapters.
- Object storage.
- Queue execution.
- AI provider integration.
- Email provider integration.
- Cache implementation.
- Observability adapters.

Infrastructure is replaceable without changing core business meaning.

---

## 5. Domain Module Boundaries

The initial logical modules are:

```text
Identity & Access
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

These modules are initially deployed together.

### 5.1 High-value ownership rules

| Concept | Owning module | Purpose |
|---|---|---|
| User / membership / authentication state | Identity & Access | Identity and access control |
| Organization structure | Organizations | Tenant and organizational hierarchy |
| Skill / alias / taxonomy | Skills | Canonical skill vocabulary |
| Competency | Competencies | Broader capability groupings |
| Role Blueprint / requirements | Roles | Industry role definition |
| Assessment definition and attempts | Assessments | Measurement process |
| Evidence | Evidence | Proof of capability |
| Readiness policy/result | Readiness | Role-specific readiness |
| Courses / learning items / pathways | Learning | Learning content |
| Training Program / sessions / trainers | Training | Role/cohort intervention |
| Job / internship opportunity | Opportunities | Open opportunities |
| Candidate matching | Matching | Fit and eligibility computation |
| Applications | Applications | Application lifecycle |
| Industry signals | Industry | Demand intelligence |
| Hiring/training results | Outcomes | Outcome and feedback loop |
| Reports | Reporting | Analytical/report outputs |
| Notifications | Notifications | User communication |
| Files / secure artifacts | Documents | File metadata and storage references |
| Subscription / payment | Billing | Commercial lifecycle |
| Audit trail | Audit | Security and business traceability |

A module owns the meaning and rules for its concepts even when data is physically stored in the same PostgreSQL database.

---

## 6. Dependency Rules

### 6.1 Allowed dependency direction

Dependencies should generally flow:

```text
API → Application → Domain → Infrastructure adapters
```

Infrastructure implementations may depend on domain/application contracts; domain logic must not depend on infrastructure implementations.

### 6.2 Cross-module interaction

Cross-module interaction must use one of these mechanisms:

1. An explicit application/domain contract.
2. A typed port/interface.
3. A domain/application event where asynchronous behavior is appropriate.
4. A read/query contract for intentionally shared reporting views.

Direct access to another module's repositories or internal tables is prohibited as a default pattern.

### 6.3 Shared utilities

Shared code must remain small and genuinely generic.

Do not create a large `common` module that becomes an unowned dumping ground for business logic.

Business-specific behavior belongs to the domain that owns it.

---

## 7. System-of-Record Invariant

PostgreSQL is the authoritative transactional system of record for Career360.

Authoritative business state must not exist only in:

- Browser state.
- React query cache.
- Caffeine cache.
- Object storage.
- AI provider output.
- Logs.
- Temporary worker memory.

Caches may accelerate access but cannot redefine truth.

R2 stores file content; PostgreSQL stores the authoritative file metadata, ownership, association and lifecycle state.

AI output is a proposal or derived artifact unless it has passed the required deterministic validation and business rules.

---

## 8. Tenant and Organization Isolation Invariants

Career360 serves multiple organizations and organizational roles.

Every tenant-scoped record must have an explicit ownership/scope model.

At minimum, access decisions must account for:

```text
Authenticated User
        ↓
Membership
        ↓
Organization / Tenant
        ↓
Role
        ↓
Resource Scope
```

A user must never gain access to another organization's data merely because they can guess an identifier.

Tenant authorization must be enforced server-side. UI hiding is not an authorization mechanism.

Where database-level protection is appropriate, PostgreSQL Row-Level Security may be used selectively, but application authorization remains required.

---

## 9. Identity and Authorization Invariants

### 9.1 Authentication is not authorization

A valid session proves identity; it does not grant access to every resource.

### 9.2 Role is not scope

A role such as College Admin or Faculty must always be evaluated together with organizational scope and resource ownership.

### 9.3 Least privilege

Users receive only the permissions necessary for their current scope.

### 9.4 Server-side enforcement

Every protected API operation must authorize the requested action and resource.

### 9.5 Auditability

Security-sensitive and materially consequential actions must be auditable.

---

## 10. Transaction Invariants

Business operations that change related authoritative state must be atomic.

For example, a readiness transition must not persist a new readiness state while leaving required evidence, version or evaluation state inconsistent.

Transaction boundaries belong primarily in the application/use-case layer.

### 10.1 Atomicity

A transaction either completes the intended state change or rolls back.

### 10.2 Consistency

Database constraints, domain rules and validation must preserve valid states.

### 10.3 Isolation

Concurrent operations must not create impossible business states.

### 10.4 Idempotency

Retryable operations must define idempotency behavior where duplicate execution could create duplicate business outcomes.

Typical candidates include:

- File ingestion.
- Webhook handling.
- Payment updates.
- Assessment submission processing.
- Background jobs.
- External integration callbacks.

### 10.5 Concurrency

Optimistic locking/version checks should be used for mutable business objects where lost updates are possible.

---

## 11. Role Blueprint Invariants

`RoleBlueprint` is a central product object.

A Role Blueprint must represent a coherent version of an industry role and its requirements.

It may include:

- Role identity.
- Responsibilities.
- Competencies.
- Skills.
- Target proficiency.
- MUST / SHOULD / COULD / WON'T priority.
- Eligibility conditions.
- Evidence requirements.
- Practical evidence requirements.
- Training/intervention recommendations.
- Readiness conditions.
- Version information.

### 11.1 Versioning

A published Role Blueprint version must be immutable from the perspective of historical interpretation.

Changes that could change eligibility, matching or readiness must create or activate a new version according to the role-versioning policy.

### 11.2 MUST requirements

MUST requirements are blocking requirements unless the explicit role policy states otherwise.

The UI and reporting layers must not silently hide unmet MUST requirements behind an aggregate score.

### 11.3 Evidence requirements

A requirement that depends on practical capability should identify the required evidence class or condition rather than assuming course completion proves competence.

---

## 12. Skill and Competency Invariants

### 12.1 Canonical skills

Career360 must maintain a canonical skill taxonomy.

Aliases, alternate spellings and source-specific terms map to canonical skills rather than creating uncontrolled duplicate concepts.

### 12.2 Competency hierarchy

A competency may group several related skills.

Example:

```text
Competency: Backend API Development
    ├── HTTP
    ├── REST
    ├── Authentication
    ├── API Design
    ├── Error Handling
    └── API Testing
```

A competency is not simply another label for the same atomic skill.

### 12.3 Source provenance

Imported or AI-suggested skills must retain source/provenance metadata where required for later review.

---

## 13. Evidence Invariants

Evidence is a first-class product concept.

Authoritative capability claims must be traceable to one or more evidence records.

Potential evidence sources include:

```text
Assessment
Practical Lab
Project
Simulation
Certification
Course Completion
Internship
Mentor Evaluation
Faculty Evaluation
Employer Evaluation
Interview
```

Course completion or certification must not automatically be interpreted as practical competence unless the product policy explicitly defines that evidence as sufficient for the specific requirement.

Evidence should retain enough metadata to answer:

```text
What was demonstrated?
Who demonstrated it?
When was it demonstrated?
How was it evaluated?
Who/what evaluated it?
Against which requirement or skill?
What confidence/freshness applies?
```

---

## 14. Readiness Invariants

Readiness is **role-specific** and **requirement-aware**.

A generic student score must not be treated as a universal substitute for Role Readiness.

The platform may expose institutional metrics such as Placement Readiness Index (PRI), but PRI is a reporting/benchmarking measure and does not replace role-specific readiness.

### 14.1 Readiness inputs

A readiness result may consider:

- Required skills.
- Required proficiency.
- Requirement priority.
- Critical/MUST requirement satisfaction.
- Practical evidence.
- Evidence confidence.
- Evidence freshness.
- Applicable eligibility conditions.
- Relevant behavioral or soft-skill requirements where defined.

### 14.2 Readiness state model

The canonical lifecycle is:

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

A later `STALE` state may be introduced if evidence freshness rules require it.

State transitions must be deterministic and auditable.

### 14.3 No score laundering

An aggregate readiness percentage must not convert a failed MUST requirement into a passing overall result unless the explicit readiness policy permits such behavior.

### 14.4 Explainability

A readiness result must be explainable in terms of:

```text
Role version
Requirements considered
Evidence considered
Gaps found
Blocking requirements
Policy/version
Result
```

---

## 15. Assessment Invariants

Assessments are measurement instruments, not merely question forms.

An assessment definition may be versioned. Attempts must reference the exact version used.

Assessment result persistence must retain sufficient detail to reconstruct:

- Overall score.
- Per-skill breakdown.
- Attempt context.
- Assessment version.
- Evaluation policy.
- Submission time.

Reopening or reassessing an attempt must not overwrite the historical record required for auditability.

Where assessments produce skill observations, those observations must retain source linkage to the relevant attempt/version.

---

## 16. Learning and Training Invariants

Learning and training exist to close identified capability gaps.

### 16.1 Course vs Training Program

A **Learning Item/Course** is reusable learning content.

A **Training Program** is an intervention targeted at a role, cohort, organization or identified set of gaps and may include:

- Skill targets.
- Competency targets.
- Learning modules.
- Projects/labs.
- Workshops.
- Trainers.
- Schedule.
- Progress.
- Reassessment.
- Outcome measurement.

### 16.2 Gap linkage

Training recommendations should be traceable to the relevant skill/competency gaps whenever the recommendation claims to address a readiness issue.

### 16.3 Completion is evidence, not automatic mastery

Completion signals participation/progress. Practical competence requires the appropriate evidence according to the role/readiness policy.

### 16.4 Reassessment loop

When a training intervention is intended to improve readiness, the architecture must support reassessment and comparison against prior evidence.

---

## 17. Matching Invariants

Matching must be based on structured requirements and candidate capability information rather than opaque AI similarity alone.

A matching result should be explainable through factors such as:

```text
Eligibility
Required skills
Proficiency fit
MUST requirement satisfaction
Evidence availability
Evidence freshness/confidence
Role-specific readiness
```

Semantic/AI similarity may assist ranking or discovery, but it must not silently replace deterministic eligibility or readiness rules.

---

## 18. AI Invariants

AI is an **assistive intelligence layer**.

Allowed use cases include:

- JD → Role Blueprint extraction.
- Skill normalization suggestions.
- Gap explanations.
- Training plan proposals.
- Career guidance.
- Trend summaries.
- Narrative report generation.
- Semantic similarity.

AI must not independently become the authoritative final decision-maker for:

- Hiring decisions.
- Eligibility decisions.
- Assessment scores.
- Skill proficiency.
- Final readiness.

The required processing pattern is:

```text
Raw Input
   ↓
AI Proposal
   ↓
Schema Validation
   ↓
Domain Validation
   ↓
Deterministic Business Rules
   ↓
Authoritative Result
```

AI outputs must be treated as untrusted external input until validated.

Prompts, provider responses and secrets must not leak through API responses or logs.

---

## 19. API Invariants

The backend exposes versioned REST APIs.

Base API namespace should follow:

```text
/api/v1/...
```

### 19.1 Contract-first behavior

Public API behavior must be represented in OpenAPI and backed by request/response schemas.

### 19.2 Consistent responses

Successful and error responses must follow a stable envelope strategy defined by `docs/06_data_contracts.md`.

### 19.3 Validation

Input validation occurs at the API boundary and again in the domain where business constraints matter.

Boundary validation cannot replace domain validation.

### 19.4 Pagination

Collection endpoints must define explicit pagination semantics when result size can grow.

### 19.5 Idempotent reads

GET operations must not create or mutate business state.

### 19.6 No persistence leakage

Database entities must not automatically become the public API contract. API DTOs/contracts must be deliberate.

---

## 20. Persistence Invariants

PostgreSQL 18.x is the initial database platform.

The design may use:

- Hibernate ORM 7 for object-oriented persistence.
- jOOQ selectively for SQL-heavy, reporting or precision query cases.
- Flyway for schema migration.
- PostgreSQL full-text search.
- `pg_trgm` for text similarity/search use cases.
- `pgvector` for embedding-assisted retrieval where justified.

### 20.1 Migration discipline

Schema changes must be delivered through versioned migrations.

Manual production schema edits are prohibited except for controlled emergency procedures that are subsequently reconciled into migrations.

### 20.2 Relational integrity

Use database constraints where they materially protect correctness:

- Primary keys.
- Foreign keys.
- Unique constraints.
- Not-null constraints.
- Check constraints where appropriate.

### 20.3 Soft deletion

Where historical traceability requires retention, records should use the product's explicit lifecycle/deactivation policy rather than physical deletion by default.

Soft deletion must not be used to bypass business rules or foreign-key integrity.

### 20.4 Connection limits

The initial Aiven PostgreSQL Free environment has a constrained connection budget. HikariCP pool sizing must remain conservative and below the environment's maximum connection capacity.

Connection pool configuration must be measured and adjusted based on actual workload rather than copied from high-scale defaults.

---

## 21. Cache Invariants

The initial cache is local **Caffeine**.

Cache entries are accelerators, not sources of truth.

Caching rules must define:

- Key structure.
- Scope.
- Expiration/invalidation behavior.
- Whether stale values are acceptable.
- Whether authorization context affects the cache key.

Never cache tenant-sensitive data under a key that omits the relevant tenant/scope dimensions.

Redis/Valkey is intentionally deferred until measurable requirements justify a shared cache.

---

## 22. Asynchronous Processing Invariants

The initial asynchronous architecture uses a PostgreSQL-backed job queue with Spring workers.

Use asynchronous processing when the operation is long-running, retryable, or otherwise unsuitable for request/response execution.

Typical candidates include:

- Report generation.
- Large imports.
- Document processing.
- AI enrichment.
- Notifications.
- Recalculation jobs.
- Industry intelligence ingestion.

Jobs must have explicit lifecycle state, retry behavior, idempotency expectations and failure recording.

Kafka/RabbitMQ/other dedicated brokers are deferred until scale or reliability requirements justify them.

---

## 23. Object Storage Invariants

Cloudflare R2 is the initial object storage provider.

Files should be addressed through durable logical metadata rather than provider-specific URLs embedded throughout the domain.

The application should retain:

```text
Document identity
Owner / tenant
Business association
Object key
Content metadata
Upload state
Lifecycle state
Access policy
Checksum where required
```

Access to sensitive files must use controlled application authorization and appropriately scoped object access.

Do not store authoritative relational business state only inside object metadata.

---

## 24. External Provider Portability

The application should use ports/interfaces for infrastructure concerns where replacement is plausible.

Expected examples:

```text
AIProvider
StoragePort
EmailPort
QueuePort
IdentityProvider
CachePort
```

The implementation may initially use:

```text
Gemini API
Cloudflare R2
Email provider adapter
PostgreSQL-backed job queue
Spring Security JWT
Caffeine
```

A provider can later be replaced without changing the Career360 domain model.

Portability does not require prematurely building abstractions for every hypothetical provider. Create a port where the boundary is architecturally meaningful and likely to change.

---

## 25. Frontend Architecture Invariants

Frontend baseline:

```text
React 19.x
Vite 8.x
TypeScript
Tailwind CSS 4.x
shadcn/ui
TanStack Query
```

### 25.1 Server state

Remote/server state should be managed through TanStack Query rather than manually duplicated across unrelated component trees.

### 25.2 API contracts

Frontend API clients must follow the backend contract and must not infer undocumented behavior.

### 25.3 UI state model

Important data-driven screens must represent four explicit states:

```text
Idle
Loading
Error
Empty
```

A loaded-success state is separate from `Empty`.

### 25.4 Authorization

The frontend may hide or disable actions for usability, but the backend remains authoritative for authorization.

### 25.5 Design consistency

Shared visual behavior must come from the Career360 design-system tokens/components defined in `docs/13_design_system.md`.

---

## 26. Observability Invariants

Initial observability uses OpenTelemetry and cloud logging/metrics.

Production-relevant operations should be traceable across:

```text
Request
  ↓
Application use case
  ↓
Database / external provider
  ↓
Background work where applicable
```

Logs must be structured enough to support diagnosis without exposing secrets or sensitive personal data unnecessarily.

At minimum, operational diagnostics should distinguish:

- Request/trace identifier.
- Operation/use case.
- Tenant/organization scope where safe.
- Outcome.
- Duration.
- Error category.

Do not log passwords, tokens, API keys, full authentication credentials or unnecessary sensitive document contents.

---

## 27. Audit Invariants

The audit system records materially consequential events, especially where they affect security, readiness, eligibility, role configuration or institutional records.

Audit records should preserve:

```text
Actor
Action
Target
Tenant / scope
Time
Result
Relevant version/context
```

Audit data must itself be protected from unauthorized alteration.

---

## 28. Historical Integrity Invariant

Career360 is a historical system as well as a current-state system.

Past decisions must remain interpretable.

Therefore, historical records that affect interpretation should retain or reference the versions of:

- Role Blueprint.
- Assessment.
- Readiness policy.
- Requirement rules.
- Skill taxonomy mapping where material.
- Evidence evaluation context.

A current rule change must not silently rewrite the meaning of a past readiness result.

---

## 29. Reporting and Analytics Invariants

Reports are derived views over authoritative data.

Reporting code must not become a second hidden business-rule engine.

Where a report displays a business metric such as readiness or placement readiness, the metric definition must reference the approved product rule/policy.

For institutional metrics, the product may support dimensions such as:

```text
Student
Batch
Department
College
Role
Industry
Time period
```

Historical reporting should preserve the relevant snapshot/version semantics where a moving rule would otherwise alter past interpretation.

---

## 30. Search and Intelligence Invariants

PostgreSQL capabilities such as full-text search, `pg_trgm` and `pgvector` are supporting mechanisms, not the domain model.

Search results must be filtered through authorization and tenant scope before being returned.

Industry intelligence data must retain provenance such as:

```text
Source
Source date
Context
Normalization status
Confidence
```

A discovered trend is a signal, not automatically an authoritative requirement.

---

## 31. Security and Secret Hygiene

Secrets must be supplied through secure runtime configuration/secret management rather than committed to source control.

The repository must not contain:

- Production passwords.
- API keys.
- JWT signing secrets.
- Cloud credentials.
- Payment secrets.
- OAuth client secrets.
- Real user credentials.

Example configuration may be documented with placeholders, but production placeholders must not be mistaken for working implementations.

A feature is not production-ready if its security dependency is still represented by a hard-coded mock or credential embedded in code.

---

## 32. Production Placeholder Prohibition

The production codebase must not silently substitute:

```text
TODO return values
Mock service responses
Fake authentication success
Hard-coded readiness scores
Static fake dashboards
Pretend payment success
Synthetic provider responses presented as real
```

Development fixtures may exist in isolated test/seed paths, but they must be clearly separated from production execution.

A missing dependency must fail explicitly and safely rather than appear operational through fake behavior.

---

## 33. Error Handling Invariants

Errors must be:

- Predictable.
- Classified.
- Safe to expose.
- Logged at the appropriate boundary.
- Correlated with a request/trace identifier where applicable.

Do not return raw stack traces, SQL exceptions or provider secrets to end users.

Business-rule failures should be represented distinctly from infrastructure failures where the API contract requires the distinction.

---

## 34. Data Quality Invariants

Inputs may come from students, colleges, companies, imported files, external platforms and AI extraction.

Therefore all external data must be treated as untrusted until validated.

Validation layers:

```text
Transport validation
        ↓
Schema validation
        ↓
Domain validation
        ↓
Authorization
        ↓
Persistence constraints
```

Imported records must preserve source/provenance when it matters for later correction or review.

---

## 35. Document and File Processing Invariants

Secure document management is a product capability, not a generic file upload widget.

Documents must have:

- Explicit owner/scope.
- Business association.
- Controlled access.
- Upload/processing state.
- Retention/lifecycle policy.
- Audit trail where required.

Document extraction, AI processing and scanning may be asynchronous.

A file must not be treated as authoritative structured data merely because extraction succeeded; extracted content must undergo validation before it influences domain state.

---

## 36. Performance and Scalability Principles

The architecture should scale through measured bottleneck removal.

Initial strategy:

```text
Optimize SQL/query plans
        ↓
Use appropriate indexes
        ↓
Use Caffeine selectively
        ↓
Move long tasks to jobs
        ↓
Tune Cloud Run resources
        ↓
Scale application instances
        ↓
Introduce shared infrastructure only when justified
```

Do not introduce Redis, Kafka, RabbitMQ, Elasticsearch, Neo4j, Kubernetes, a dedicated vector database or a separate AI service simply because those technologies are common in large systems.

They are deferred until a concrete requirement exists.

---

## 37. Scaling and Extraction Rules

The modular monolith is designed to be extractable later.

A module becomes a service candidate when measurable evidence shows one or more of:

- Independent scaling requirement.
- Independent deployment cadence.
- High resource isolation requirement.
- Strong ownership boundary.
- Failure isolation requirement.
- Runtime or technology mismatch.
- Organizational need for separate lifecycle management.

Extraction must preserve domain contracts rather than duplicate business logic across services.

The first optimization target is architectural correctness inside the monolith, not distributed complexity.

---

## 38. Infrastructure Cost Invariants

Initial architecture must remain compatible with free or low-cost development/pilot operation where practical.

The baseline is:

```text
Cloudflare Pages
+
Google Cloud Run
+
Aiven PostgreSQL
+
Cloudflare R2
+
Gemini API
```

New paid infrastructure must have a documented product or scale requirement.

Cloud Run resource limits, database pools and background workload must be configured conservatively for the starting environment.

A migration to paid infrastructure must not require rewriting the Career360 business model.

---

## 39. Deployment Invariants

The application is containerized with Docker.

The backend deployment target is Google Cloud Run.

The frontend deployment target is Cloudflare Pages.

Infrastructure should remain reproducible through Terraform/OpenTofu-compatible definitions as infrastructure automation matures.

Deployment configuration must separate environments, such as:

```text
dev
staging
production
```

Production secrets and data must not be reused as development fixtures.

---

## 40. Testing Architecture

Testing strategy is layered.

```text
Unit Tests
   ↓
Application / Integration Tests
   ↓
Repository / Database Tests
   ↓
API / Contract Tests
   ↓
Browser / UI Tests
```

Baseline tooling:

```text
Backend: JUnit + Testcontainers
Frontend: Vitest + React Testing Library
End-to-end: Playwright
```

### 40.1 Unit tests

Focus on deterministic domain rules and pure business behavior.

### 40.2 Integration tests

Verify database, transactions, module boundaries and external adapter behavior.

### 40.3 Testcontainers

Use real PostgreSQL-compatible infrastructure in integration tests where database behavior materially affects correctness.

### 40.4 Contract tests

Protect API schemas and important integration contracts against accidental breaking changes.

### 40.5 Browser tests

Critical user workflows must be exercised through the real UI, not only through unit tests.

---

## 41. Verification Invariants

Verification operates at two levels.

### Fast verification

Used frequently during development:

- Compile/type check.
- Lint/format where configured.
- Targeted unit tests.
- Targeted API tests.

### Full verification

Required before a milestone is declared complete:

- Backend build/tests.
- Frontend build/tests.
- Integration verification.
- Critical Playwright flows.
- Contract/OpenAPI validation where applicable.
- Database migration verification.
- Production configuration sanity checks.

Verification must test behavior, not merely file existence.

---

## 42. UI Acceptance Invariants

A production feature is incomplete when only the backend exists.

For user-facing features, verification must consider:

```text
Data loading
Empty state
Validation
Authorization
Error handling
Success confirmation
Navigation
Responsive behavior
Critical interaction flow
```

The UI must never report success merely because a network request returned a generic HTTP success if the business operation itself failed validation.

---

## 43. API-to-UI Truth Invariant

The UI must render from authoritative API responses rather than reconstructing business truth from local assumptions.

Examples:

- Readiness status comes from readiness evaluation data.
- Skill gap values come from evaluated records.
- Application status comes from the application lifecycle.
- Training completion comes from recorded completion state.

Client-side derived presentation is allowed, but client-side invention of authoritative business state is not.

---

## 44. Event and Background Processing Invariants

Events and background jobs are for decoupling work, not for hiding transaction requirements.

When an operation needs atomic transactional state plus a follow-up asynchronous action, the implementation must ensure the job/event cannot be emitted in a way that references state that never committed.

A durable transaction/outbox-compatible pattern should be used when required by the operation's consistency needs.

The initial implementation may use PostgreSQL-backed jobs rather than a dedicated message broker.

---

## 45. Integration Invariants

External systems may include:

- Learning/certification providers.
- Identity providers.
- Email providers.
- Storage providers.
- AI providers.
- Payment providers.
- Industry data sources.

Every integration must define:

```text
Provider contract
Authentication method
Timeouts
Retry behavior
Idempotency behavior
Failure behavior
Data mapping
Ownership of resulting data
Audit requirements
```

External provider availability must not cause domain corruption.

---

## 46. Billing and Subscription Invariants

Billing state is financially consequential and must be represented explicitly.

Payment-provider callbacks must be authenticated/validated, idempotent and tied to the correct customer/organization context.

A client-side "payment successful" state is never authoritative on its own.

Subscription entitlements must be evaluated server-side.

---

## 47. Notifications Invariants

Notifications are derived from domain events or explicitly requested communications.

Notification delivery failure must not silently roll back unrelated core business transactions unless the notification is itself part of the required atomic operation.

Repeated delivery attempts must be safe and ideally idempotent at the provider boundary.

---

## 48. Non-Goals of the Initial Architecture

The following are intentionally not baseline dependencies:

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

They may be introduced later when a documented requirement justifies them.

The absence of these systems does not mean the architecture is incomplete.

---

## 49. Architecture Decision Rules

When choosing between two implementation options, prefer the option that:

1. Preserves domain boundaries.
2. Makes critical rules deterministic.
3. Keeps authoritative state in PostgreSQL.
4. Maintains tenant/security boundaries.
5. Preserves historical interpretability.
6. Minimizes provider lock-in.
7. Minimizes operational complexity.
8. Can be tested reliably.
9. Supports migration to higher-scale infrastructure later.
10. Solves a current product requirement rather than an imagined future problem.

---

## 50. Architecture Review Checklist

Before accepting a significant architecture-affecting change, verify:

```text
[ ] Owning domain module identified
[ ] Dependency direction remains valid
[ ] Tenant/authorization scope defined
[ ] Transaction boundary defined
[ ] Persistence ownership defined
[ ] API contract defined where applicable
[ ] Validation strategy defined
[ ] Error behavior defined
[ ] Audit requirements considered
[ ] Historical/version implications considered
[ ] AI role clearly non-authoritative where applicable
[ ] Provider boundary respected
[ ] Async/retry/idempotency behavior defined where needed
[ ] Tests defined at appropriate layers
[ ] Operational/observability impact considered
[ ] No unnecessary infrastructure introduced
[ ] No production placeholder introduced
```

---

## 51. Definition of Architectural Compliance

An implementation is architecturally compliant only when it satisfies the applicable invariants in this document and the more specific rules in the related domain specifications.

The document hierarchy is:

```text
AGENTS.md
   ↓
docs/00_product_vision.md
   ↓
docs/01_architecture_and_invariants.md
   ↓
Domain-specific specifications
   ↓
Active milestone: docs/16_active_sprint.md
```

More specific domain documents may refine behavior, but must not silently contradict core invariants. Any intentional exception must be documented as an explicit architecture/product decision.

---

## 52. Final Architecture Statement

Career360's initial production architecture is a **PostgreSQL-first, modular-monolith platform** with a React/TypeScript frontend and Spring Boot backend, deployed through Cloudflare Pages and Google Cloud Run, with Cloudflare R2 for object storage and Gemini as an assistive AI provider.

The architecture is deliberately designed around the product's core truth model:

```text
Role Requirement
      ↓
Capability Model
      ↓
Evidence
      ↓
Gap
      ↓
Intervention
      ↓
Reassessment
      ↓
Role Readiness
      ↓
Opportunity
      ↓
Outcome
```

The architecture must remain:

- Deterministic for authoritative decisions.
- Evidence-backed for capability claims.
- Role-specific for readiness.
- Secure and tenant-aware.
- Historically explainable.
- Provider-portable.
- Testable.
- Cost-conscious at initial scale.
- Extractable into services later when measurable requirements justify that complexity.

This is the baseline architecture against which subsequent Career360 implementation documents and milestones are evaluated.
