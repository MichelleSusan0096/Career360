# Career360 Agent Rule: Engineering Standards

## Purpose
Non-negotiable engineering standards for Career360 implementation. These rules supplement `AGENTS.md` and the `docs/` specification set.

## Architecture alignment
All implementation must align with `AGENTS.md`, `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, and the relevant `docs/02–16` document.

Baseline:

`React + TypeScript → Spring Boot → PostgreSQL`

Core choices include Spring Modulith, PostgreSQL as the system of record, Flyway, REST/OpenAPI, Spring Security, Cloudflare R2, Caffeine, PostgreSQL-backed jobs, and Gemini as assistive AI.

Do not add deferred infrastructure without a documented product or scale requirement.

## Production-first
Production behavior must not depend on fake responses, hard-coded business data, unfinished required paths, silent exception swallowing, fake persistence, mock production authentication, or insecure development shortcuts.

Demo fixtures must be isolated and explicitly identified.

## Java/Spring
Use Java 25, Spring Boot 4.x, Spring Security, Spring Modulith, Hibernate/JPA for ordinary persistence, jOOQ selectively for reporting/read-heavy/SQL-specific access, Flyway, validation, and explicit REST DTOs.

Controllers handle transport concerns. Domain/application services own business logic. Repositories do not own business policy.

## Database
PostgreSQL is authoritative.
- Every schema change is a Flyway migration.
- Use foreign keys and unique constraints to enforce real invariants.
- Justify indexes by access patterns.
- Tenant scoping must be explicit in tenant-owned queries.
- Preserve historical traceability where required.
- Store timestamps consistently in UTC.
- Logically atomic changes must be transactional.
- Do not introduce another source-of-truth database without approval.

## API
Use `/api/v1/...` with explicit DTOs, boundary validation, stable error envelopes, correct HTTP status codes, authorization, tenant isolation, idempotency where duplicate requests are possible, and OpenAPI documentation.

Never expose persistence entities directly as public API contracts.

## Errors
Errors must be deterministic, safe for users, observable, and useful for diagnostics. Never expose stack traces, SQL details, secrets, or internal exception messages to clients. Never turn failures into fake success responses.

## Async jobs
Initial async processing uses PostgreSQL-backed jobs and Spring workers. Jobs need stable identity, status, retries, attempts, timestamps, failure information, and safe retry/idempotent execution.

## AI
AI follows:

`Input → AI proposal → schema validation → domain validation → business rules → authoritative result`

AI can assist with role blueprint extraction, skill normalization, gap explanation, training proposals, report narratives, and semantic similarity. It cannot be the sole authority for hiring, eligibility, assessment scores, proficiency, or final readiness.

## Testing and verification
Use the relevant unit, domain/service, repository/database, API, security, frontend, and browser tests. Use Testcontainers for PostgreSQL integration.

Fast verification covers formatting/lint, type checking, targeted tests, compile/build, and affected modules.

Full verification covers backend/frontend builds, relevant tests, migration checks, security checks, browser validation, contract checks, and documentation/status updates.

Never claim a verification step that was not actually run.

## Observability
Production-critical workflows need structured logs, request/correlation IDs, useful metrics, error monitoring, and required audit records. Never log passwords, tokens, private keys, secrets, sensitive documents, or unnecessary personal data.

## Dependency/configuration discipline
Before adding a dependency, document the product need, alternatives, operational impact, lock-in, and security/upgrade cost.

Configuration comes from environment/configuration management. Never commit credentials or production secrets.

## Code quality
Prefer cohesive modules, explicit names, canonical Career360 terminology, clear validation, testable functions, and minimal cleverness. Avoid giant services, duplicated business rules, generic utility dumping grounds, unexplained magic values, and premature abstraction.

## Definition of done
A feature is complete only when required domain behavior, persistence, API contract, authorization, validation, error handling, tests, observability, UI states, and documentation are implemented to the active sprint scope.

## Agent behavior
Inspect relevant project documentation before ambiguous changes. Do not invent incompatible behavior. Record significant assumptions. If a request conflicts with an invariant, surface the conflict rather than bypassing it.
