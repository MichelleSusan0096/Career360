# Career360 — Operations Runbook

**Document:** `docs/15_operations_runbook.md`  
**Status:** Production Operations Baseline  
**Applies to:** Local development, test, staging and production operations  
**Related documents:** `docs/01_architecture_and_invariants.md`, `docs/06_data_contracts.md`, `docs/07_security_authorization.md`, `docs/14_integrations.md`, `docs/16_active_sprint.md`

---

## 1. Purpose

This runbook defines the minimum operational procedures required to build, deploy, observe, recover and safely change Career360.

The target architecture is:

```text
Cloudflare Pages
      ↓
Google Cloud Run
      ↓
Aiven PostgreSQL
      ├── pgvector / pg_trgm / FTS where required
      └── durable application job queue
      ↓
Cloudflare R2
      ↓
Gemini API and other adapters
```

Operations must favor predictable, reversible changes over manual production intervention.

---

## 2. Environment Model

Minimum environments:

```text
LOCAL
TEST
STAGING / PRE-PRODUCTION
PRODUCTION
```

Environment-specific values must be externalized.

The same application artifact should be promoted through environments where practical rather than rebuilding different code per environment.

---

## 3. Required Configuration Classes

Configuration is divided into:

```text
Application configuration
Database configuration
Storage configuration
AI configuration
Email configuration
Security configuration
Observability configuration
Feature flags
```

Secrets must come from a secure environment-secret mechanism and never be stored in Git.

Examples include:

```text
DATABASE_URL / discrete datasource settings
JWT signing secret
R2 credentials
Gemini API key
Email provider credentials
OAuth client secrets
Webhook secrets
```

Never copy real production secrets into issue descriptions, documentation or test fixtures.

---

## 4. Deployment Flow

The preferred deployment flow is:

```text
Code Change
   ↓
Fast Verification
   ↓
Full Verification
   ↓
Build Artifact / Container
   ↓
Deploy Non-Production
   ↓
Smoke Tests
   ↓
Migration Check
   ↓
Production Deployment
   ↓
Health Verification
   ↓
Post-Deployment Observation
```

A deployment is not complete until health and critical user flows are verified.

---

## 5. Database Operations

PostgreSQL is the system of record.

Schema changes must use Flyway migrations.

Rules:

- No manual schema drift in production.
- Every migration is versioned.
- Destructive changes require explicit migration planning.
- Backward-compatible database changes are preferred for rolling deployments.
- Large data migrations should be separated from application startup when execution time could threaten availability.
- Backup and restore procedures must be periodically tested.

Connection pool sizing must remain compatible with the Aiven connection limit. The application must not exhaust the database through unbounded pools or per-request connections.

---

## 6. Migration Safety

Preferred sequence for risky schema changes:

```text
Add new structure
      ↓
Deploy code that supports old + new
      ↓
Backfill / migrate data
      ↓
Switch reads/writes
      ↓
Verify
      ↓
Remove obsolete structure later
```

Do not combine irreversible data deletion with an unverified application deployment.

---

## 7. Health Checks

The backend should provide operational health information appropriate to deployment needs.

At minimum distinguish:

```text
Application process healthy
Database dependency healthy
Required external dependency state
```

A liveness check should not fail merely because an optional external provider is unavailable.

A readiness check may fail when the application cannot safely serve required traffic.

---

## 8. Observability Baseline

Use OpenTelemetry-compatible tracing/metrics and platform logs.

Baseline signals:

### Application

- request rate;
- latency;
- error rate;
- HTTP status distribution;
- active requests.

### Database

- connection utilization;
- query latency;
- failed connections;
- transaction duration;
- lock contention where observable.

### Jobs

- queue depth;
- oldest job age;
- success/failure count;
- retry count;
- permanently failed jobs.

### Integrations

- request latency;
- timeout rate;
- provider failures;
- webhook failures.

### Business safety

Monitor critical workflow failures such as:

```text
Assessment submission failures
Readiness computation failures
Training completion processing failures
Opportunity/application processing failures
Outcome recording failures
```

---

## 9. Logging Rules

Logs must be structured and searchable.

Useful fields:

```text
timestamp
level
service/module
environment
correlation_id
request_id
user_id where permitted
organization_id / tenant where permitted
operation
result
latency
error_code
```

Never log:

- passwords;
- raw authentication tokens;
- private keys;
- full payment credentials;
- sensitive document contents;
- unnecessary personal information.

---

## 10. Incident Severity

Use a simple severity model:

```text
SEV-1  Critical: broad outage, data integrity risk, security incident
SEV-2  Major: significant feature unavailable or materially degraded
SEV-3  Minor: limited functionality impact with workaround
SEV-4  Informational: non-urgent defect or improvement
```

Severity should reflect user/business impact, not engineering inconvenience.

---

## 11. Incident Response Flow

```text
Detect
  ↓
Classify
  ↓
Contain
  ↓
Protect data integrity
  ↓
Restore service
  ↓
Verify
  ↓
Communicate
  ↓
Root-cause analysis
  ↓
Prevent recurrence
```

During an active incident, prioritize:

1. Safety of data.
2. Service restoration.
3. Clear status communication.
4. Evidence preservation.
5. Root-cause work after stabilization.

Do not perform speculative destructive changes during an incident.

---

## 12. Rollback Strategy

Application rollback should be possible by redeploying a known-good artifact.

Database rollback is not assumed to mean reversing a migration automatically.

For every risky migration, define before execution:

```text
Forward change
Compatibility window
Recovery action
Data restoration plan if necessary
Validation queries/tests
```

When data integrity is affected, restoring from backup may be safer than attempting an ad-hoc reverse mutation.

---

## 13. Backup and Restore

The PostgreSQL environment must have configured backups appropriate to the deployment tier.

Operations must document:

- backup retention;
- backup ownership;
- restore procedure;
- restore destination;
- expected recovery time;
- expected recovery point;
- verification procedure.

A backup is not considered reliable merely because a provider reports that it exists. Restore testing is required.

Object storage data requiring retention must have documented lifecycle and recovery behavior.

---

## 14. Job Queue Operations

The initial durable asynchronous mechanism is PostgreSQL-backed jobs with Spring workers.

A job should record:

```text
job_id
type
payload/reference
state
attempt_count
available_at
locked_at
completed_at
last_error
created_at
```

Typical states:

```text
QUEUED
RUNNING
SUCCEEDED
RETRYING
FAILED
CANCELLED
```

Workers must use bounded retries and idempotent processing.

A permanently failed job must remain observable rather than disappearing silently.

---

## 15. Common Operational Procedures

### Restart backend

Use the platform deployment/restart mechanism. Verify health after restart.

### Pause a problematic worker

Disable only the affected job type/worker where the architecture supports it. Do not stop unrelated application traffic unless required.

### Recover failed jobs

1. Inspect failure reason.
2. Confirm whether the failure is transient or deterministic.
3. Correct configuration/code/data issue.
4. Replay only when idempotency is verified.
5. Confirm final domain state.

### Storage incident

Do not issue broad deletions. Verify object metadata, access policy and provider status first.

### AI provider outage

Disable or degrade AI-dependent features gracefully. Deterministic platform workflows should remain usable.

---

## 16. Security Operations

When a credential is suspected to be exposed:

```text
Revoke / rotate credential
      ↓
Identify affected systems
      ↓
Inspect audit/log evidence
      ↓
Restore service with replacement secret
      ↓
Document incident
```

Do not paste the leaked secret into an incident document.

For authorization anomalies, preserve the relevant audit information and investigate before changing historical records.

---

## 17. Audit and Data Integrity

High-impact domain actions must produce audit records according to the security specification.

Examples:

- role blueprint publication;
- requirement changes;
- assessment version publication;
- score/result corrections;
- evidence verification changes;
- readiness result changes;
- opportunity status transitions;
- application decisions;
- outcome changes;
- administrative membership changes.

Do not edit historical audit records as a normal application operation.

---

## 18. Performance Guardrails

The initial system intentionally avoids premature infrastructure expansion.

Do not add Redis, Kafka, RabbitMQ, Elasticsearch/OpenSearch, Kubernetes, Neo4j or a dedicated vector database solely to solve an unmeasured problem.

Use PostgreSQL, Caffeine, Spring workers and indexed relational queries until metrics demonstrate the need for another component.

---

## 19. Cost Guardrails

The baseline is cost-conscious.

Rules:

- Prefer free/low-cost tiers during development and pilot stages.
- Set provider billing alerts where supported.
- Avoid unnecessary always-on resources.
- Limit Cloud Run resources appropriately.
- Control database connection count.
- Monitor storage growth and AI usage.
- Do not introduce a paid dependency without documenting its product or scale requirement.

---

## 20. Deployment Verification Checklist

Before production completion:

```text
[ ] Build succeeded
[ ] Automated tests passed
[ ] Migration validated
[ ] Configuration verified
[ ] Secrets resolved
[ ] Health endpoints verified
[ ] Critical API smoke tests passed
[ ] Critical browser flow verified
[ ] Logs/traces visible
[ ] Error rate normal
[ ] Job queue healthy
[ ] Database connections normal
[ ] Storage integration verified where applicable
```

---

## 21. Operational Definition of Done

A production change is done only when:

- implementation is complete;
- automated verification passes;
- security/authorization checks pass;
- migrations are safe;
- deployment succeeds;
- observable health is confirmed;
- active milestone acceptance criteria are satisfied;
- relevant documentation has been updated.

---

## 22. Emergency Principle

> **Protect data integrity first, restore service second, and preserve evidence for explanation and recovery throughout the incident.**
