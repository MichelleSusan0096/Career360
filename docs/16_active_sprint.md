# Career360 — Active Sprint / Execution Contract

**Document:** `docs/16_active_sprint.md`  
**Status:** Living execution contract  
**Owner:** Project team  
**Purpose:** Define exactly what the current Antigravity implementation milestone may and may not change.

---

## 1. Why This File Exists

Career360 contains a large production-oriented target architecture. That architecture is intentionally broader than any single implementation milestone.

This file prevents Antigravity from treating the entire product vision as the current coding task.

**Only work explicitly activated in this document is in scope.**

Future features remain specifications, not implementation requirements.

---

## 2. Current Execution Mode

### Mode

**Foundation / production baseline implementation.**

The current milestone establishes a real, executable foundation for the Career360 platform rather than building every domain module at once.

The implementation should prioritize:

```text
Repository foundation
        ↓
Application bootstrap
        ↓
Database baseline
        ↓
Identity / tenant foundation
        ↓
Skill / role foundation
        ↓
API + UI verification foundation
```

The active milestone must remain small enough to verify completely.

---

## 3. Active Milestone Objective

Build and verify the minimum backend/frontend foundation needed to begin the Career360 closed-loop domain implementation safely.

The milestone should produce a working vertical slice of the architectural foundation, not a collection of placeholder screens.

---

## 4. In Scope

The following foundation capabilities are active:

### Repository and tooling

- project structure;
- root agent/rule loading;
- reproducible local development;
- formatting/lint/test commands;
- Docker development/runtime baseline where required;
- environment configuration without committed secrets.

### Backend foundation

- Java/Spring Boot application bootstrap;
- Spring Security baseline;
- typed configuration;
- validation/error handling;
- OpenAPI baseline;
- modular package boundaries;
- persistence baseline;
- Flyway migration baseline;
- transactional service patterns;
- health/readiness endpoints appropriate to the environment.

### Database foundation

- PostgreSQL connection;
- baseline schema strategy;
- organization/user/membership foundation;
- audit foundation where required by implemented mutations;
- indexes and constraints for implemented entities.

### Frontend foundation

- React + TypeScript + Vite application;
- Tailwind/shadcn design-system foundation;
- typed API client layer;
- authentication/session shell;
- routing/layout shell;
- required Idle / Loading / Error / Empty states;
- browser verification foundation.

### Initial domain foundation

The milestone may implement only the smallest verified subset of:

```text
Organization
User
Membership
Skill
Role Blueprint foundation
```

The exact entity subset must follow the implementation task currently assigned to the team. Unused future domain entities must not be scaffolded merely for completeness.

---

## 5. Explicitly Out of Scope for This Milestone

Unless this file is updated, do not implement full versions of:

- advanced industry intelligence;
- full assessment authoring engine;
- complex learning marketplace;
- training marketplace;
- comprehensive internship/job marketplace;
- predictive analytics;
- advanced matching;
- billing/subscriptions;
- external learning-provider integrations;
- enterprise SSO;
- dedicated Redis/Valkey;
- Kafka/RabbitMQ;
- Elasticsearch/OpenSearch;
- Kubernetes;
- dedicated vector database;
- separate AI service;
- microservice decomposition.

These remain future specifications.

---

## 6. No Placeholder Rule

Do not create fake production behavior merely to make a page appear complete.

Prohibited examples:

```text
hard-coded dashboard numbers
fake readiness scores
invented student records shown as real data
mock application success presented as persisted state
placeholder authentication that bypasses security
pretend API responses for core flows
```

Fixtures are permitted only in clearly defined test/demo environments and must never be confused with production data paths.

---

## 7. Implementation Order

Prefer this dependency order:

```text
1. Repository/tooling
2. Backend bootstrap
3. Configuration + secrets model
4. Database + migrations
5. Identity + authorization foundation
6. API contract/error model
7. Frontend shell
8. Initial domain vertical slice
9. Automated tests
10. Browser verification
11. Documentation/status update
```

Do not start from visual dashboards and retrofit the domain afterward.

---

## 8. Verification Gates

### Gate A — Fast verification

Run the smallest relevant checks after each meaningful change.

Examples:

- compile/type-check;
- targeted unit tests;
- targeted lint/format checks;
- migration validation.

### Gate B — Full verification

Before declaring the milestone complete:

```text
Backend tests
Frontend tests
Integration tests
Security/authorization tests
Database migration verification
API contract verification
Browser/UI verification
```

### Gate C — Acceptance

Every active acceptance criterion must have evidence of completion.

---

## 9. Acceptance Criteria

The foundation milestone is complete only when all of the following are true:

```text
[ ] Application starts from a clean environment using documented configuration.
[ ] Backend communicates with PostgreSQL through the approved persistence approach.
[ ] Database schema is created/updated only through versioned migrations.
[ ] Authentication does not rely on frontend-only trust.
[ ] Authorization is enforced on protected backend operations.
[ ] Tenant/organization boundaries are enforced for implemented data.
[ ] API responses follow the established data/error contract.
[ ] Frontend consumes backend APIs rather than hard-coded production data.
[ ] Loading, empty and error states are implemented for active data screens.
[ ] Tests cover the implemented critical business/security paths.
[ ] Browser verification confirms the primary happy path and failure states.
[ ] No real secret is committed to source control.
[ ] No future infrastructure is introduced without an active requirement.
```

---

## 10. Change Control

This file is the scope gate.

When a new capability is required:

```text
Requirement identified
        ↓
Determine whether active milestone needs it
        ↓
Update this document if scope changes
        ↓
Define acceptance criteria
        ↓
Implement
        ↓
Verify
```

Do not silently expand scope because a referenced architecture document describes a future capability.

---

## 11. Active Work Record

Antigravity should maintain the following record during the sprint:

```text
Current work item:
Owner:
Started:
Status:
Files changed:
Tests run:
Browser verification:
Known blockers:

Acceptance evidence:
- 
- 
- 
```

A work item may be marked complete only after its verification evidence is recorded.

---

## 12. Blocker Policy

When blocked by missing product information, environment access, credentials or contradictory specifications:

1. Do not invent a business rule.
2. Preserve the last verified state.
3. Record the blocker.
4. Continue only with independent work that does not depend on the missing decision.

Infrastructure should not be added merely to work around an unspecified requirement.

---

## 13. Definition of Done

For the current milestone, “done” means:

```text
Implemented
   +
Contract-compliant
   +
Authorized
   +
Tested
   +
Browser-verified where UI exists
   +
Operationally observable
   +
Documented
```

A feature is not done because its code exists.

---

## 14. Next-Milestone Discipline

When the current milestone is complete, update this file before beginning the next milestone.

The update should state:

- new objective;
- newly activated modules;
- newly activated infrastructure;
- acceptance criteria;
- explicit out-of-scope items;
- verification requirements.

This preserves a single execution truth even while the broader product specification remains stable.

---

## 15. Current Sprint Principle

> **Build the smallest real vertical slice that proves the architecture, then expand the product through verified milestones.**
