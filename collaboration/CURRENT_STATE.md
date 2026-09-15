# Career360 — Current Repository State

**Current Date:** 2026-09-15  
**Last Meaningful Update:** 2026-09-15  
**Overall Project Phase:** Phase 1 — Foundation Baseline  
**Active Milestone:** Milestone 1 — Repository, Backend & Frontend Baseline (`docs/16_active_sprint.md`)

---

## 1. Completed Foundation Milestones

- **Repository Scaffolding & Configuration:**
  - Workspace structure established (`backend/`, `frontend/`, `docs/`, `db/`, `infra/`, `.agents/`, `collaboration/`).
  - `.antigravityignore` configured for safe agent operation.
  - Complete domain, product, architecture, and security specifications documented in `docs/00_product_vision.md` through `docs/16_active_sprint.md`.
  - Comprehensive engineering protocol established in `AGENTS.md`.

- **Agent Governance & Verification Hooks:**
  - Modular agent rules in `.agents/rules/` (`ai-boundaries.md`, `backend-contracts.md`, `domain.md`, `security.md`, `standards.md`, `ui-craft.md`).
  - Specialized agent roles in `.agents/agents/` (`auditor.md`, `builder.md`, `product-validator.md`).
  - Domain skills in `.agents/skills/` (18 specialized skills).
  - Python-based verification hooks configured in `hooks.json` and implemented in `.agents/hooks/`:
    - `verify.py` (repository hygiene, frontend/backend builds and tests)
    - `security_check.py` (credential and dangerous pattern scanner)
    - `ui_verify.py` (frontend typecheck and linting)

- **Database Migration Baseline:**
  - Flyway initial migration authored: `backend/src/main/resources/db/migration/V1__initial_schema.sql` (40KB defining relational core tables for users, organizations, memberships, roles, skills, competencies, assessments, evidence, readiness, training, opportunities, and applications).

- **Backend Baseline Skeleton:**
  - Java 25 / Spring Boot 4.1 bootstrap application created: `Career360BackendApplication.java`.
  - Maven configuration (`pom.xml`) with Spring Boot, Web, Security, Data JPA, Flyway, Validation, Actuator.
  - Configuration template: `application.yml` referencing environment variables (`DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `SERVER_PORT`).
  - Baseline test class: `Career360BackendApplicationTests.java`.

- **Frontend Baseline Skeleton:**
  - Vite 8.x + React 19.x + TypeScript application initialized.
  - Tailwind CSS 4.x configured (`index.css`).
  - shadcn/ui initialized (`components.json`, `components/ui/button.tsx`, `lib/utils.ts`).
  - ESLint and TypeScript configs (`tsconfig.json`, `tsconfig.app.json`, `tsconfig.node.json`).

---

## 2. Component Status

| Component | Status | Details |
|---|---|---|
| **Backend** | Baseline Skeleton | Application bootstrap exists; no domain entity controllers/services implemented yet. |
| **Frontend** | Baseline Shell | Vite starter page present; shadcn button available; routing/auth context pending. |
| **Database** | Migration Ready | `V1__initial_schema.sql` written; live database connection not yet configured in local environment. |
| **AI Layer** | Defined in Docs | Specifications defined in `docs/01_architecture_and_invariants.md`; `ai/` directory reserved. |
| **Infra** | Defined in Docs | Specifications defined (Cloud Run, Cloudflare Pages, Aiven PG, R2); `infra/` directory reserved. |

---

## 3. Active Architecture State

- **Pattern:** Modular Monolith in Spring Boot.
- **Language & Runtime:** Java 25 LTS, Spring Boot 4.1.x.
- **Primary Database:** PostgreSQL 18 with relational tables, `pgvector`, `pg_trgm`, full-text search.
- **Object Storage:** Cloudflare R2 abstraction.
- **AI Provider:** Gemini API behind `AIProvider` interface.
- **Job Engine:** PostgreSQL-backed Job Queue + Spring asynchronous workers (no Redis/Kafka in V1).
- **Caching:** In-memory Caffeine cache (no distributed cache in V1).

---

## 4. Active Design-System State

- **Framework:** React 19 + TypeScript + Vite 8.
- **Styling:** Tailwind CSS 4.x.
- **Component Primitives:** shadcn/ui.
- **Mandatory UI States:** `IDLE`, `LOADING`, `ERROR`, `EMPTY` for all data-driven components.

---

## 5. Known Verification State

- `python .agents/hooks/security_check.py --changed`: **PASS** (Zero credentials, secrets, or dangerous patterns).
- `python .agents/hooks/verify.py --changed`: **PASS** (Repository structure and hygiene verified).
- Git Working Tree: Clean on branch `main`.

---

## 6. Next Recommended Continuation Point

1. Maintain operational memory through `collaboration/` layer.
2. Advance Milestone 1 according to `docs/16_active_sprint.md`:
   - Set up local Docker Compose for local PostgreSQL + pgvector testing.
   - Run and verify `V1__initial_schema.sql` against the local database.
   - Implement the first vertical domain slice: Organization, User, and Membership models, repository, service, and authenticated REST endpoints following API contracts in `docs/06_data_contracts.md`.
