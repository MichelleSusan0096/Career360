# Career360 — Operational Task Board

**Last Updated:** 2026-09-15  
**Board Status:** Active  

> [!NOTE]
> All tasks must derive from `docs/16_active_sprint.md` or active project initialization requirements. Tasks must never be marked `DONE` without deterministic verification evidence recorded in the repository.

---

## Task Summary Matrix

| Status | Count |
|---|---|
| **IN_PROGRESS** | 0 |
| **READY_FOR_REVIEW** | 0 |
| **BLOCKED** | 0 |
| **TODO** | 6 |
| **DONE** | 4 |

---

## 1. IN_PROGRESS

*(No tasks currently in progress)*


---

## 2. READY_FOR_REVIEW

*(No tasks currently awaiting review)*

---

## 3. BLOCKED

*(No tasks currently blocked)*

---

## 4. TODO (Milestone 1 — Foundation Baseline)

### `TASK-005`: Local Development Database Environment (Docker Compose)
- **Description:** Provide a local containerized PostgreSQL 18 environment with `pgvector` enabled for local backend testing and migration validation.
- **Area / Module:** `infra` / `db`
- **Dependencies:** None
- **Verification State:** Not started
- **Owner:** Unassigned

### `TASK-006`: Database Migration Execution & Verification
- **Description:** Validate execution of `V1__initial_schema.sql` against PostgreSQL, confirming all core tables, constraints, foreign keys, and indexes build cleanly.
- **Area / Module:** `backend` / `db`
- **Dependencies:** `TASK-005`
- **Verification State:** Not started
- **Owner:** Unassigned

### `TASK-007`: Identity, Organization & Membership Backend Domain Slice
- **Description:** Implement JPA entities, repositories, transactional services, and REST controllers for `Organization`, `User`, and `Membership` per `docs/02_domain_model.md` and `docs/06_data_contracts.md`.
- **Area / Module:** `backend` (`identity`, `organizations`)
- **Dependencies:** `TASK-006`
- **Verification State:** Not started
- **Owner:** Unassigned

### `TASK-008`: Spring Security & Authentication Filter Baseline
- **Description:** Implement stateless JWT authentication, password hashing, user details service, and RBAC authorization filters following `AGENTS.md` Section 18.
- **Area / Module:** `backend` (`identity`, `security`)
- **Dependencies:** `TASK-007`
- **Verification State:** Not started
- **Owner:** Unassigned

### `TASK-009`: Standardized REST Response & Problem Details Envelope
- **Description:** Implement global response advice and exception handler conforming to Career360 API Contract (`docs/06_data_contracts.md` and `AGENTS.md` Section 30).
- **Area / Module:** `backend` (`api`, `common`)
- **Dependencies:** `TASK-007`
- **Verification State:** Not started
- **Owner:** Unassigned

### `TASK-010`: Frontend Shell & Auth Context
- **Description:** Implement client-side routing, layout shell with responsive navigation, auth token management context, and shadcn state components (`IDLE`, `LOADING`, `ERROR`, `EMPTY`).
- **Area / Module:** `frontend` (`shell`, `auth`)
- **Dependencies:** `TASK-008`, `TASK-009`
- **Verification State:** Not started
- **Owner:** Unassigned

---

## 5. DONE (Verified in Repository)

### `TASK-001`: Initial Project Scaffolding
- **Description:** Set up directory layout (`backend/`, `frontend/`, `docs/`, `db/`, `infra/`, `.agents/`), Maven wrapper, Vite configuration, and `.antigravityignore`.
- **Area / Module:** Repository Root
- **Verification State:** Verified by git commit `b47a80c` and repository inspection.
- **Owner:** Repository Init

### `TASK-002`: Product, Architecture & Security Specifications
- **Description:** Author canonical documentation set `docs/00_product_vision.md` through `docs/16_active_sprint.md` and master `AGENTS.md`.
- **Area / Module:** `docs/`
- **Verification State:** Verified on disk in `docs/` and `AGENTS.md`.
- **Owner:** Repository Init

### `TASK-003`: Agent Governance & Engineering Skills
- **Description:** Author `.agents/rules/`, `.agents/agents/`, `.agents/skills/`, and Python verification hooks (`verify.py`, `security_check.py`, `ui_verify.py`).
- **Area / Module:** `.agents/`
- **Verification State:** Verified by git commit `cf852dc` and execution of `.agents/hooks/verify.py`.
- **Owner:** Repository Init

### `TASK-004`: AI Collaboration & Operational Memory System Setup
- **Description:** Establish repository-controlled collaboration system (`collaboration/`), contributor guide (`CONTRIBUTING.md`), PR template (`.github/PULL_REQUEST_TEMPLATE.md`), collaboration skill (`.agents/skills/collaboration-context/SKILL.md`), and update `AGENTS.md`.
- **Area / Module:** Repository Governance / AI Collaboration
- **Dependencies:** None
- **Verification State:** VERIFIED (passed `security_check.py --changed`, `verify.py --changed`, git status and diff inspection clean).
- **Owner:** Antigravity AI Session

