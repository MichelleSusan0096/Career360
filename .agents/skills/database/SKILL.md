---
name: database
description: Design, migrate, validate, and troubleshoot Career360 PostgreSQL persistence safely.
---
# Career360 Database Skill

## Purpose
Use for PostgreSQL schema design, Flyway migrations, constraints, indexes, query implementation, seed data, transactions, and database verification.

## Source of truth
Follow `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`, `docs/06_data_contracts.md`, and `docs/07_security_authorization.md`.

PostgreSQL is the authoritative application store.

## Schema rules
Every persistent domain object needs clear ownership/scope, correct relationships, constraints, and justified indexes. Use database constraints for invariants that must never be violated.

## Migrations
Every schema change uses Flyway. Migrations must be ordered, deterministic, forward-only, data-safe, and reviewed for destructive changes. Never bypass migrations as the normal workflow.

## Tenant isolation
Every tenant-owned query must preserve organization scope. A resource ID is never sufficient authorization.

## Historical integrity
Preserve Role Blueprint versions, skill mappings, evidence provenance, readiness history where required, application/outcome history, and auditability. Do not rewrite historical business facts merely to simplify persistence.

## Transactions
Use transactions for logically atomic operations such as assessment submission/result persistence, evidence verification with dependent updates, Role Blueprint publication, and application transitions with audit records.

## PostgreSQL capabilities
Use relational constraints, full-text search, `pg_trgm`, `pgvector`, transactions, and bounded JSONB where appropriate. Do not introduce another database merely for perceived scalability.

## Query implementation
Use JPA/Hibernate for normal domain persistence. Use jOOQ selectively for reporting, read-heavy queries, and PostgreSQL-specific operations.

## Seed data
Development seeds must be deterministic, fake, clearly non-production, and constraint-valid. Never use real credentials or personal data.

## Verification
Validate clean migration application, constraints, tenant isolation, important query behavior, and integration tests.
