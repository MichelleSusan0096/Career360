# Career360 — Integrations Specification

**Document:** `docs/14_integrations.md`  
**Status:** Product/Engineering Integration Baseline  
**Applies to:** External systems, provider adapters, webhooks, imports/exports, identity, learning, storage, AI, notifications and future integrations  
**Related documents:** `docs/01_architecture_and_invariants.md`, `docs/06_data_contracts.md`, `docs/07_security_authorization.md`, `docs/10_industry_intelligence.md`, `docs/12_outcomes_analytics.md`

---

## 1. Purpose

This document defines how Career360 integrates with external systems without allowing vendor-specific behavior to become the product's domain model.

Career360 follows a **port-and-adapter** approach:

```text
Career360 Domain / Application Logic
                │
                ▼
        Internal Integration Port
                │
        ┌───────┴────────┐
        ▼                ▼
   Provider Adapter   Provider Adapter
        │                │
        ▼                ▼
   External System   External System
```

The product must remain capable of changing providers without rewriting core career-readiness logic.

---

## 2. Integration Principles

1. External systems are dependencies, not sources of domain authority unless explicitly designated for a particular fact.
2. Every integration has an owner, purpose, contract, security model and failure policy.
3. Provider-specific DTOs must stay at the adapter boundary.
4. External identifiers must not replace Career360 identifiers.
5. Inbound data must be validated, normalized and attributed with provenance.
6. Webhooks must be authenticated, idempotent and replay-safe.
7. Outbound requests must use bounded timeouts and explicit retry policy.
8. Integration failures must not corrupt authoritative Career360 transactions.
9. Sensitive integration credentials must never be committed to source control or returned to the frontend.
10. User-visible state must distinguish pending, successful, failed and unavailable integrations.

---

## 3. Initial Integration Baseline

The initial production-oriented stack uses these external capabilities:

| Capability | Initial provider/technology | Integration role |
|---|---|---|
| PostgreSQL | Aiven PostgreSQL | Transactional system of record |
| Object storage | Cloudflare R2 | Documents, evidence files, exports |
| Backend hosting | Google Cloud Run | Application runtime |
| Frontend hosting | Cloudflare Pages | Web delivery |
| AI | Gemini API | Assistive extraction/recommendation |
| Email | Provider adapter; concrete provider selected by deployment | Transactional notifications |
| Identity | Spring Security/JWT initially | Application authentication |

A specific SaaS provider must not be hard-coded into business services merely because it is used initially.

---

## 4. Integration Categories

Career360 integrations are grouped into:

```text
Identity
Storage
Learning
AI
Communication
Payments
Industry Data
Assessment
Calendar / Scheduling
Institutional Systems
Analytics / Export
```

Not every category is P0.

P0 integrations are limited to infrastructure and workflows required by the active milestone.

---

## 5. Identity Integration

### Initial approach

Spring Security with Career360-managed authentication and authorization is the initial baseline.

### Future federation

The architecture may later support:

- Google OAuth/OIDC
- Microsoft Entra ID / OIDC
- institutional SSO
- enterprise identity providers
- Keycloak or another dedicated IdP

Authentication integration must map an external subject to an internal `User` identity without making the external identifier the primary domain key.

```text
External Identity
      ↓
Identity Adapter
      ↓
Verified External Subject
      ↓
User / Membership Mapping
      ↓
Career360 Authorization
```

### Rules

- Authentication and authorization remain separate concerns.
- Organization membership is evaluated by Career360.
- An authenticated external identity does not automatically grant tenant access.
- Identity-provider claims must be validated before use.
- Account-linking operations require explicit, secure flows.

---

## 6. Object Storage Integration

Documents, assessment attachments, evidence artifacts and generated exports belong in object storage rather than PostgreSQL binary fields for normal use.

Initial provider: **Cloudflare R2**.

The application should interact through an internal abstraction such as:

```text
ObjectStoragePort
├── putObject
├── getObjectMetadata
├── createDownloadReference
├── deleteObject
└── copyObject
```

The domain stores metadata such as:

```text
Document ID
Owner / Tenant
Object key
Media type
Size
Checksum
Upload status
Created timestamp
Retention classification
```

### Security

- Prefer short-lived signed URLs.
- Do not expose bucket credentials to browsers.
- Validate file type, size and checksum.
- Scan or validate uploaded files before making them authoritative.
- Authorize document access through Career360 before issuing a download reference.

---

## 7. AI Integration

Gemini is an assistive integration.

Primary supported uses include:

- Job description extraction.
- Candidate-facing gap explanations.
- Learning-plan proposals.
- Industry trend summaries.
- Semantic similarity and discovery.
- Report narrative generation.

AI must follow:

```text
Raw Input
   ↓
AI Proposal
   ↓
Schema Validation
   ↓
Domain Validation
   ↓
Business Rules
   ↓
Persist / Present as appropriate
```

AI output cannot by itself become authoritative:

- hiring decision;
- eligibility decision;
- assessment score;
- canonical skill proficiency;
- final readiness result.

### AI integration failure

The product must continue to operate for deterministic workflows when AI is unavailable. AI-dependent features should fail in a controlled, explicit state rather than silently fabricating output.

---

## 8. Learning and Certification Integrations

Career360 may integrate with external learning providers.

The integration must distinguish:

```text
External Course
External Completion
External Certificate
        ≠
Practical Competence
```

A provider completion event may update learning progress or evidence, but it must not automatically satisfy practical-role readiness unless a Career360 policy explicitly permits that evidence type for that requirement.

### Provider contract

External learning adapters should normalize:

```text
provider_id
external_course_id
course_title
skill_mapping
completion_status
completion_timestamp
credential_reference
verification_status
source_metadata
```

Webhook or polling completion should be idempotent.

---

## 9. Notification Integration

Notifications are delivered through application-owned notification services.

Supported channels may include:

```text
Email
In-app notification
Future: SMS / push / messaging providers
```

Domain actions create notification intents; provider adapters handle delivery.

The application must retain delivery status without making the email provider the system of record for notification history.

Recommended lifecycle:

```text
Notification Intent
      ↓
Persist
      ↓
Queue Job
      ↓
Provider Send
      ↓
Delivery Result
      ↓
Audit / Status Update
```

---

## 10. Payment Integration

Billing is not part of the core readiness decision loop.

When enabled, payment providers must be isolated behind:

```text
PaymentPort
```

Career360 should store its own:

- customer/account reference;
- subscription state;
- invoice/payment state needed by the product;
- provider event reference;
- reconciliation status.

Do not store raw card credentials.

Payment webhooks must be signature-verified and idempotent.

---

## 11. Industry Data Integrations

Industry intelligence may ingest:

- employer-provided role definitions;
- structured job descriptions;
- approved external labor-market datasets;
- placement outcomes;
- employer feedback;
- approved partner datasets.

Every imported signal must preserve provenance:

```text
source
source_type
source_reference
observed_at
ingested_at
organization/context
normalization_version
confidence
```

Raw external language must not overwrite the canonical skill taxonomy.

---

## 12. Import and Export

The platform must support controlled imports/exports where useful.

Typical formats:

```text
CSV
JSON
PDF reports
Spreadsheet-compatible exports
```

Imports follow:

```text
Upload
  ↓
Schema Check
  ↓
Row Validation
  ↓
Normalization
  ↓
Conflict Detection
  ↓
Preview
  ↓
Atomic Commit
  ↓
Import Result
```

Partial silent commits are prohibited for transactional bulk operations unless the specific import contract explicitly supports row-level rejection and reports every rejected row.

Exports must apply authorization and data-minimization rules.

---

## 13. Webhook Rules

All inbound webhooks must support:

- signature/authentication verification;
- timestamp/replay protection where provider supports it;
- provider event ID capture;
- idempotent processing;
- durable receipt before irreversible business processing;
- bounded retries;
- dead-letter or failed-event visibility;
- auditability.

Canonical flow:

```text
Webhook Request
      ↓
Authenticate / Verify Signature
      ↓
Persist Event Receipt
      ↓
Idempotency Check
      ↓
Queue / Process
      ↓
Domain Validation
      ↓
State Change
      ↓
Integration Result
```

---

## 14. Outbound HTTP Rules

Every external HTTP integration must define:

- connection timeout;
- response timeout;
- maximum payload size;
- retryable status/error categories;
- retry count or bounded backoff;
- circuit/failure behavior where appropriate;
- logging policy;
- correlation ID behavior;
- redaction rules.

Do not retry non-idempotent operations blindly.

---

## 15. Idempotency

Repeated external events must not duplicate domain state.

Use a durable key such as:

```text
integration_name + provider_event_id
```

For client-originated mutation requests, use an application idempotency key where the operation is safe and requires protection from duplicate submission.

Idempotency records must have explicit retention behavior.

---

## 16. Provider Portability

The domain must not contain code such as:

```text
if (provider == "specific-vendor") { ...business rule... }
```

Provider differences belong in adapters.

The preferred structure is:

```text
application/
  ports/
    ObjectStoragePort
    EmailPort
    PaymentPort
    LearningProviderPort
    AiInferencePort

adapters/
  r2/
  email/
  payment/
  learning/
  gemini/
```

The exact package structure may evolve, but the dependency direction must remain.

---

## 17. Integration Observability

Every external call should be traceable by correlation ID and integration name.

Metrics should include, where applicable:

- request count;
- success rate;
- latency;
- timeout count;
- retry count;
- provider error count;
- webhook receipt count;
- failed job count;
- backlog age.

Do not log access tokens, passwords, private documents or sensitive personal data unnecessarily.

---

## 18. Integration State Model

Integrations should expose explicit states where appropriate:

```text
NOT_CONFIGURED
CONFIGURED
ACTIVE
DEGRADED
FAILED
DISABLED
```

Business records that depend on asynchronous integration should also have explicit processing state such as:

```text
PENDING
PROCESSING
SUCCEEDED
FAILED
```

---

## 19. Testing Requirements

Each integration must have:

1. Adapter unit tests.
2. Contract tests for normalized input/output.
3. Failure-path tests.
4. Idempotency tests.
5. Security/signature tests for webhooks.
6. Integration tests using sandbox/test endpoints where available.
7. Browser/UI verification for user-visible workflows.

Do not make production tests dependent on a real paid provider account unless that is explicitly part of the environment.

---

## 20. Integration Decision Gate

Before adding an integration, record:

```text
Business capability required
Why PostgreSQL/application logic is insufficient
Provider or standard selected
Free-tier/cost impact
Security impact
Failure behavior
Data ownership
Portability plan
Exit/migration plan
Test strategy
```

New infrastructure is not justified merely because a provider offers a feature that Career360 could already implement reliably with existing components.

---

## 21. Non-Goals

The initial product must not introduce, without an active milestone requirement:

- a dedicated integration platform;
- a microservice for every provider;
- Kafka solely for integration events;
- a workflow engine solely for connector orchestration;
- multiple identity systems;
- multiple databases for one domain concept.

---

## 22. Integration Invariant

> **External systems may deliver data, capability or transport; Career360 owns its domain state, business rules, authorization and authoritative readiness decisions.**
