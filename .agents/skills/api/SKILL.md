---
name: api
description: Build and validate Career360 REST APIs and backend contracts.
---
# Career360 API Skill

## Purpose
Use for Spring Boot REST endpoints, DTOs, validation, application services, errors, pagination, idempotency, authorization, OpenAPI, and integration tests.

## Contract authority
Follow `docs/01_architecture_and_invariants.md`, `docs/06_data_contracts.md`, `docs/07_security_authorization.md`, and `.agents/rules/backend-contracts.md`.

## Endpoint baseline
Use `/api/v1/...` and canonical domain resource names such as `/roles`, `/role-blueprints`, `/assessments`, `/evidence`, `/opportunities`, `/applications`, and `/training-programs`.

## DTOs
Never expose persistence entities directly. Use explicit request/response DTOs and validate types, lengths, formats, ranges, enums, cross-field rules, and business constraints.

## Layering
Controllers handle transport concerns. Application/domain services own business logic and state transitions. Repositories do not own business policy.

## Errors
Use stable machine-readable error codes, safe messages, request/correlation IDs where useful, and field validation details where applicable. Never expose stack traces, SQL, or secrets.

## State and commands
Enforce valid resource transitions on the server. Use explicit commands for important actions such as publish, submit, approve, reject, enroll, apply, withdraw, and reassess.

## Security
Every protected endpoint enforces authentication, permissions, organization scope, and resource-level access where required. Frontend checks are not authorization.

## Idempotency and concurrency
Use idempotency for retryable duplicate-prone commands and database/locking mechanisms for concurrency-sensitive invariants.

## Async
For long-running work use the PostgreSQL-backed job model and return a trackable accepted/job state rather than holding requests open unnecessarily.

## OpenAPI and tests
Keep OpenAPI aligned with implementation and test success, validation, authorization, tenant isolation, invalid transitions, idempotency, and persistence integration.
