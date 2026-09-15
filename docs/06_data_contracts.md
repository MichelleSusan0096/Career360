# Career360 — Data Contracts

**Document:** `docs/06_data_contracts.md`  
**Status:** Product/Engineering Contract Baseline  
**Applies to:** Backend APIs, frontend consumers, domain events, persistence boundaries, integrations and asynchronous jobs  
**Primary owner:** Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`, `docs/04_role_blueprint.md`, `docs/05_readiness_matching.md`

---

## 1. Purpose

This document defines the contracts through which Career360 modules exchange data.

The goal is to make data movement explicit, versionable, validated, secure and explainable across:

- React frontend and Spring Boot backend.
- Application services and domain modules.
- Domain modules and persistence adapters.
- Synchronous REST APIs and asynchronous jobs.
- AI-assisted extraction and authoritative business processing.
- External integrations such as object storage, email and learning providers.

A data contract is not merely a JSON shape. It defines the meaning, ownership, validation rules, nullability, lifecycle, authorization expectations, versioning behavior and error semantics of a data exchange.

---

## 2. Contract Principles

### 2.1 API contracts are explicit

Every public API must have a documented request and response schema. OpenAPI is the canonical transport description.

### 2.2 Domain models are not API models

Entities, JPA records and internal domain objects must not be exposed directly as public API contracts.

Use dedicated DTOs or contract records so internal persistence changes do not silently change the external API.

### 2.3 Validate at the boundary

Input must be validated before it enters application/domain processing.

Validation occurs at multiple levels:

```text
Transport validation
        ↓
Schema validation
        ↓
Authentication / authorization
        ↓
Application validation
        ↓
Domain invariants
        ↓
Persistence constraints
```

### 2.4 Server is authoritative

The frontend may calculate presentation-only values, but authoritative state such as readiness, eligibility, assessment outcome, role requirement satisfaction and matching must be determined by the backend.

### 2.5 Stable identifiers

Business resources use opaque, stable identifiers. Clients must not rely on database sequence semantics or implementation-specific identifiers.

### 2.6 Explicit versioning

Changes that alter API meaning must be versioned or otherwise handled through a documented compatibility strategy.

### 2.7 Time is explicit

Timestamps must be represented with timezone-aware semantics. Backend persistence should use UTC. APIs should serialize timestamps using an unambiguous ISO-8601 representation.

### 2.8 Money is not floating point

Monetary values must use exact decimal semantics and an explicit currency.

### 2.9 Collections are bounded and paginated

List endpoints must not return unbounded collections. Pagination, filtering and sorting contracts must be explicit.

### 2.10 Errors are structured

Clients must be able to reliably distinguish validation, authentication, authorization, conflict, not-found and server failures without parsing human prose.

---

## 3. Canonical API Envelope

Career360 should use a consistent envelope for successful API responses where an envelope improves consistency.

Conceptual form:

```json
{
  "data": {},
  "meta": {
    "requestId": "..."
  }
}
```

For collections:

```json
{
  "data": [],
  "meta": {
    "page": 0,
    "pageSize": 20,
    "totalElements": 125,
    "totalPages": 7,
    "requestId": "..."
  }
}
```

The exact envelope may evolve during API implementation, but the semantics must remain consistent.

### 3.1 Request identifier

Every API request must be traceable through a request/correlation identifier.

The identifier should appear in logs and error responses where appropriate.

---

## 4. Canonical Error Contract

The backend must expose machine-readable errors.

Conceptual shape:

```json
{
  "error": {
    "code": "ROLE_BLUEPRINT_NOT_PUBLISHED",
    "message": "The role blueprint must be published before matching can begin.",
    "fieldErrors": [],
    "requestId": "..."
  }
}
```

### 4.1 Required error fields

| Field | Meaning |
|---|---|
| `code` | Stable machine-readable code |
| `message` | Human-readable explanation safe for the client |
| `fieldErrors` | Optional field-level validation details |
| `requestId` | Correlation identifier |

Error codes must be stable enough for frontend logic and tests.

### 4.2 Error categories

At minimum:

```text
VALIDATION_ERROR
UNAUTHORIZED
FORBIDDEN
NOT_FOUND
CONFLICT
UNPROCESSABLE_ENTITY
RATE_LIMITED
INTERNAL_ERROR
DEPENDENCY_ERROR
```

Business-specific codes may sit beneath these categories.

---

## 5. Identifier Contract

Business resources should expose identifiers in a format that does not reveal infrastructure details.

Examples:

```text
userId
organizationId
membershipId
studentId
roleId
roleBlueprintId
skillId
competencyId
evidenceId
assessmentId
assessmentAttemptId
readinessId
trainingProgramId
opportunityId
applicationId
outcomeId
```

The exact physical database key type may be UUID or another stable identifier strategy, but it must remain consistent within the system.

Clients must not construct identifiers.

---

## 6. Nullability and Optionality

A field is nullable only when absence is meaningful.

Do not use `null` as a substitute for:

- empty collections,
- unknown state,
- not-applicable state,
- omitted optional input,
- authorization redaction.

For input DTOs, distinguish where necessary between:

```text
field omitted
field explicitly null
field supplied with value
```

especially for PATCH-style updates.

---

## 7. Enum Contract

Enums exposed through APIs must use stable string values.

Example:

```json
{
  "status": "PROVISIONALLY_READY"
}
```

Clients must not depend on ordinal values.

When a new enum value is introduced, frontend code must have a safe unknown/fallback presentation state rather than crashing.

---

## 8. Pagination, Filtering and Sorting

Collection endpoints should use a consistent query contract.

Conceptual parameters:

```text
page
pageSize
sort
filter
search
```

Server-side defaults and maximum page sizes must be defined.

Sorting must be deterministic. When the requested sort field contains ties, a stable secondary key should be applied.

---

## 9. PATCH and Update Semantics

Every mutable resource must define whether updates are:

- full replacement,
- partial update,
- command-style mutation.

For business state transitions, command endpoints are preferred over allowing arbitrary status updates.

Example:

```text
POST /role-blueprints/{id}/publish
```

is preferred to:

```text
PATCH /role-blueprints/{id}
{
  "status": "PUBLISHED"
}
```

because publishing has business rules and side effects.

---

## 10. Core Resource Contracts

### 10.1 User summary

A user summary may expose:

```text
id
name
emailDisplayValue
accountStatus
```

Sensitive authentication/security fields must never be exposed through ordinary user DTOs.

### 10.2 Organization

Conceptual contract:

```json
{
  "id": "org_...",
  "name": "Example College",
  "type": "COLLEGE",
  "status": "ACTIVE"
}
```

Tenant context must be derived from trusted authorization context rather than accepted blindly from a request body.

### 10.3 Student profile

May include:

```text
studentId
user reference
college membership context
department
batch
career preferences
portfolio summary
capability summary
```

Highly sensitive personal data should be minimized and permission-filtered.

### 10.4 Skill

Conceptual contract:

```text
id
canonicalName
category
status
aliases
version metadata
```

Skill definitions are reference data and should not be casually duplicated in dependent entities.

### 10.5 Competency

Conceptual contract:

```text
id
name
description
category
skillComposition
status
version metadata
```

The composition must preserve the relationship between competency and constituent skills.

### 10.6 Role Blueprint

The Role Blueprint contract must be version-aware.

Conceptual structure:

```json
{
  "id": "rb_...",
  "roleId": "role_...",
  "version": 3,
  "status": "PUBLISHED",
  "title": "Graduate Backend Engineer",
  "requirements": [],
  "competencies": [],
  "readinessPolicy": {},
  "evidenceRequirements": [],
  "eligibility": {}
}
```

Clients must receive enough information to explain role requirements, but must not be trusted to compute authoritative readiness.

### 10.7 Assessment

Contract must separate assessment definition from attempt/result.

```text
Assessment
  ↓
Assessment Attempt
  ↓
Result / Skill Breakdown
```

A student must not be able to modify an authoritative submitted attempt through a normal client update operation.

### 10.8 Evidence

Conceptual fields:

```text
id
candidateId
sourceType
sourceReference
skillClaims
verificationStatus
capturedAt
observedAt
expiresAt or freshness metadata
createdBy
```

Uploaded file references must point to object-storage metadata, not expose internal storage credentials.

### 10.9 Readiness

Readiness is a derived domain result and should include traceability information such as:

```text
candidate
role
roleBlueprintVersion
state
requiredCapabilities
satisfiedCapabilities
gaps
blockingGaps
evidenceSummary
policyVersion
calculatedAt
```

### 10.10 Match Result

A match result should distinguish between:

```text
eligibility
capability fit
evidence fit
readiness state
missing requirements
confidence / similarity signals
```

A single opaque percentage is insufficient for decision explanation.

---

## 11. Data Versioning Contract

Career360 contains domain objects whose meaning changes over time. These must be versioned deliberately.

Primary version-sensitive objects include:

- Role Blueprint.
- Role requirements.
- Skill taxonomy.
- Competency definitions.
- Assessment definitions/rubrics.
- Readiness policies.
- Matching policies.
- Industry normalization rules where they affect historical interpretation.

Historical results must preserve the versions needed to reconstruct why a decision was reached.

Conceptually:

```text
Readiness Result
    ├── roleBlueprintVersion
    ├── skillTaxonomyVersion
    ├── assessment/rubric version where relevant
    └── readinessPolicyVersion
```

---

## 12. Evidence-to-Decision Contract

A readiness result should be explainable through a chain such as:

```text
Role requirement
      ↓
Canonical skill / competency
      ↓
Observed capability
      ↓
Evidence
      ↓
Evaluation
      ↓
Requirement satisfied / gap
      ↓
Readiness state
```

A result must not reference evidence that was unavailable at the time of the decision.

This makes `calculatedAt`, evidence timestamps and policy versions important audit fields.

---

## 13. AI Proposal Contract

AI-generated data must be represented as a proposal, not silently persisted as authoritative domain truth.

Conceptual contract:

```json
{
  "proposalId": "proposal_...",
  "sourceType": "JOB_DESCRIPTION",
  "sourceReference": "document_...",
  "model": "...",
  "structuredOutput": {},
  "confidenceSignals": {},
  "validationStatus": "PENDING_REVIEW"
}
```

The required flow is:

```text
Raw input
   ↓
AI extraction
   ↓
Schema validation
   ↓
Canonical normalization
   ↓
Domain validation
   ↓
Business rules
   ↓
Authoritative persistence
```

AI output must never bypass domain validation.

---

## 14. File Contract

Files must be represented as metadata plus an opaque storage reference.

Conceptual structure:

```text
fileId
objectKey
contentType
size
checksum
storageProvider
createdAt
uploadedBy
securityClassification
```

The frontend must never receive storage-provider credentials.

Signed download/upload URLs, when used, must be short-lived and permission-checked.

---

## 15. Asynchronous Job Contract

The initial architecture uses PostgreSQL-backed durable jobs and Spring workers.

Conceptual job record:

```text
jobId
type
payload
status
attemptCount
availableAt
lockedAt
completedAt
lastError
correlationId
```

Job payloads must be versionable and self-describing.

Workers must be idempotent wherever possible.

```text
QUEUED → RUNNING → SUCCEEDED
              ↘
               FAILED → RETRYING
```

Permanent failure must be distinguishable from transient retryable failure.

---

## 16. Event Contract

Internal domain/application events may be used for decoupling within the modular monolith.

Examples:

```text
AssessmentSubmitted
EvidenceVerified
ReadinessCalculated
TrainingCompleted
RoleBlueprintPublished
OpportunityPublished
ApplicationSubmitted
HiringOutcomeRecorded
EmployerFeedbackRecorded
```

Events must communicate business facts, not implementation instructions.

Prefer:

```text
ReadinessCalculated
```

over:

```text
UpdateStudentReadinessTable
```

Event payloads should contain stable identifiers and the minimum data necessary for consumers.

---

## 17. Transaction Contract

A transaction boundary must encompass every mutation that must become true together.

Examples:

```text
Publish Role Blueprint
    ├── validate completeness
    ├── transition status
    └── record audit event
```

```text
Submit Assessment Attempt
    ├── persist answers/result
    ├── persist skill breakdown
    ├── finalize attempt
    └── enqueue downstream recalculation if required
```

Cross-resource state must never be partially committed unless the workflow explicitly supports eventual consistency.

---

## 18. Idempotency Contract

Operations that may be retried due to browser retries, network failures, worker retries or webhook redelivery must define idempotency behavior.

Candidates include:

- payment callbacks,
- learning completion webhooks,
- evidence ingestion,
- assessment submission,
- asynchronous job execution,
- email event processing.

An idempotency key or deterministic unique constraint should be used where appropriate.

---

## 19. Optimistic Concurrency

Where concurrent edits are possible, contracts should support version or timestamp checks.

Example:

```json
{
  "version": 7,
  "title": "Graduate Backend Engineer"
}
```

A stale update should result in `CONFLICT`, not silently overwrite another user's change.

---

## 20. Security Contract at the Data Boundary

Sensitive fields must be classified.

Conceptual classifications:

```text
PUBLIC
ORGANIZATION_VISIBLE
ROLE_SCOPED
PERSONAL
SENSITIVE
SECURITY_SENSITIVE
```

Serialization must be permission-aware.

Examples of fields that must never be exposed in ordinary API responses:

- password hashes,
- JWT signing secrets,
- MFA secrets,
- provider credentials,
- internal storage credentials,
- raw AI provider secrets.

---

## 21. Audit Contract

Authoritative business transitions should produce an audit record where auditability is required.

At minimum, useful audit context includes:

```text
actor
organization
action
resource type
resource id
timestamp
result
request/correlation id
```

Audit records should be append-oriented and protected from ordinary user mutation.

---

## 22. API Compatibility Rules

### Backward-compatible changes

Generally acceptable without a major contract version change:

- adding optional response fields,
- adding new enum values only when clients safely tolerate them,
- adding optional request fields,
- performance improvements without semantic changes.

### Potentially breaking changes

Require explicit versioning/migration planning:

- renaming fields,
- changing field meaning,
- changing nullability,
- changing enum semantics,
- removing fields relied on by clients,
- changing pagination behavior materially,
- changing authorization behavior.

---

## 23. Contract Testing

Critical APIs must have automated contract coverage.

Minimum verification should include:

```text
Request schema validation
Response schema validation
Authorization behavior
Success behavior
Validation failures
Not-found behavior
Conflict behavior
Pagination behavior
```

Frontend integration tests should consume the same documented API semantics rather than duplicating hidden assumptions.

---

## 24. OpenAPI Requirements

All public REST endpoints must be represented in OpenAPI.

OpenAPI documentation should include:

- endpoint summary,
- request parameters,
- request body schema,
- response schema,
- authentication requirement,
- authorization notes where useful,
- error responses,
- pagination semantics,
- examples for complex payloads.

Generated OpenAPI documentation must reflect the actual running API.

---

## 25. Contract Ownership

Every important contract has an owner.

```text
Resource semantics → Domain owner
Transport schema → API/application owner
Persistence mapping → Infrastructure owner
Security visibility → Security/authorization policy
```

No module should silently redefine another module's core resource semantics.

---

## 26. Frontend State Contract

The frontend must explicitly model at least:

```text
IDLE
LOADING
SUCCESS
ERROR
EMPTY
```

For collection screens, `EMPTY` is a valid domain/UI state and must not be represented as an error.

Server-generated readiness, scores and status should display the backend timestamp/version when historical interpretation matters.

---

## 27. Contract Checklist

A new API or integration is not considered complete until the following questions have clear answers:

- Who owns the data?
- What is the request schema?
- What is the response schema?
- Which fields are required, optional or nullable?
- What validations apply?
- Who can read the data?
- Who can mutate it?
- Is the mutation idempotent?
- Does it require a transaction?
- Does it create an audit record?
- Does it publish an event or job?
- What happens on retry?
- What happens under concurrent modification?
- What is the versioning strategy?
- Can the frontend render success, empty and failure states safely?

---

## 28. Final Data-Contract Rule

> **A Career360 data contract must describe not only what data looks like, but what that data means, who owns it, who may act on it, how it changes, how it is validated, and how historical decisions remain explainable.**
