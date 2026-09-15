# Career360 Agent Rule: Backend Contracts

## Purpose
Define mandatory API and backend contract standards for predictable, versioned, secure Career360 integrations.

## Contract ownership
Spring Boot is the authoritative application/API layer.

`Client → API Contract → Application Service → Domain Rules → Persistence`

Frontend code consumes backend contracts; it must not recreate authoritative business rules. Database schemas are not public contracts unless explicitly exposed.

## API versioning
Use `/api/v1/...` for external REST APIs. Prefer additive, backward-compatible changes. Do not silently change field meaning, type, requiredness, or semantics for existing consumers. Breaking changes require an explicit migration/versioning strategy.

## Request contracts
Every request DTO defines types, required/optional fields, validation constraints, enum values, and relevant semantic rules. Validate at the API boundary. Frontend validation is supplementary, never authoritative.

## Response contracts
Use explicit response DTOs. Do not expose persistence entities directly. Responses must not leak internal database structure, secrets, stack traces, or unrelated tenant data.

## Error contract
Use a stable machine-readable error code, safe human-readable message, correlation/request ID where appropriate, and field-level validation details when relevant. Never expose SQL, stack traces, exception internals, or secrets.

## HTTP semantics
Use status codes meaningfully: 200/201/202/204 for successful operations as appropriate; 400 for malformed input; 401 for missing/invalid authentication; 403 for insufficient permission; 404 where the resource is unavailable under the security policy; 409 for state/concurrency conflicts; 422 for applicable semantic validation failures; 429 for rate limits; 5xx for server failures.

Never return `200 OK` for a failed business operation merely to simplify frontend code.

## Resource naming
Use canonical Career360 terminology and noun-oriented paths such as `/api/v1/roles`, `/api/v1/role-blueprints`, `/api/v1/assessments`, `/api/v1/evidence`, `/api/v1/opportunities`, `/api/v1/applications`, and `/api/v1/training-programs`.

## Commands and queries
State-changing operations represent explicit business actions such as publish, submit, assign, approve, reject, enroll, apply, withdraw, and reassess. GET operations must not create hidden business state transitions.

## State transitions
Backend services enforce valid lifecycle transitions for Role Blueprints, Assessments, Opportunities, Applications, Training Programs, and Readiness. Invalid transitions return deterministic errors.

## Transactions
Multi-record business operations that must be atomic run inside a transaction. Examples include assessment submission/result recording, evidence verification with dependent state updates, Role Blueprint publication, and application/outcome changes.

## Idempotency
Retry-prone commands and webhooks must have an idempotency strategy. Repeated requests must not create duplicate authoritative records.

## Concurrency
Protect invariants with database constraints, optimistic locking/version checks, and transactional validation as appropriate. Do not rely on UI button state for concurrency control.

## Pagination/filtering
Large collections must be paginated. Filtering and sorting semantics must be explicit. Never load arbitrarily large institution, candidate, evidence, opportunity, or analytics datasets into the browser.

## Authorization
Every protected endpoint enforces authentication, permission, organization/tenant scope, and resource-level authorization where required. A resource ID never implies authorization.

## Sensitive resources
Private documents and object-storage URLs require authorization before access. Do not publish private student or organization files through unrestricted public URLs.

## Async APIs
Long-running work should follow:

`Command → 202 Accepted → Job/Resource Status → Completion/Failure`

Status should distinguish queued, running, completed, failed, and other supported states. Retry behavior must be safe.

## Internal events
Respect Spring Modulith boundaries. Prefer explicit application/domain events rather than direct access to another module's persistence internals. Event payloads must avoid unnecessary sensitive information and be evolvable.

## OpenAPI
Externally consumable REST contracts must be represented in OpenAPI. Documentation must describe actual behavior, not an idealized API that differs from runtime behavior.

## DTO mapping
Map transport DTOs intentionally. Never expose password hashes, tokens, internal audit metadata, or unrelated tenant data.

## Backward compatibility
Before a contract change, identify consumers, compatibility impact, migration steps, and deprecation needs. Avoid abrupt removal of fields or behavior.

## Observability
Support correlation/request IDs, latency/throughput metrics, error metrics, and audit records for sensitive state changes. Do not log sensitive request bodies indiscriminately.

## Contract testing
Critical endpoints require the relevant combination of DTO validation tests, API tests, authorization tests, integration tests, contract/OpenAPI checks, and frontend/browser verification.

## Acceptance checklist
Verify versioning, explicit DTOs, boundary validation, correct status codes, stable errors, authentication, tenant/resource authorization, transactionality, idempotency, concurrency protection, OpenAPI alignment, tests, and observability.
