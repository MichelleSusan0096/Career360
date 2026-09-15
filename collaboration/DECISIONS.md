# Career360 — Operational Decisions Log

**Last Updated:** 2026-09-15  

> [!NOTE]
> This log records concise, accepted technical and operational decisions governing implementation. Major architectural changes that alter core boundaries, infrastructure, or domain invariants must be authored as formal ADRs in `decisions/` rather than buried here.

---

## Decision Log

### `DEC-001`: Relational First, PostgreSQL-Centric Persistence
- **Date:** 2026-09-15
- **Decision:** PostgreSQL is the single authoritative system of record. All core business entities must be modeled relationally using foreign keys, constraints, transactions, and Flyway migrations. JSONB is restricted to extensible metadata only.
- **Rationale:** Ensures referential integrity, strong consistency across the closed-loop readiness chain, and prevents uncontrolled document drift.
- **Affected Area:** `backend`, `db`
- **Source Reference:** `AGENTS.md` Sections 14, 15; `docs/01_architecture_and_invariants.md`.
- **Status:** ACCEPTED

---

### `DEC-002`: Modular Monolith Over Microservices
- **Date:** 2026-09-15
- **Decision:** Build backend as a Spring Boot 4.1.x modular monolith (Spring Modulith) on Java 25. Modules communicate via explicit service interfaces or application events; no distributed RPC or network calls between internal domains.
- **Rationale:** Minimizes operational complexity, simplifies transactional integrity across domain events, and fits initial development and pilot operations.
- **Affected Area:** `backend`
- **Source Reference:** `AGENTS.md` Sections 12, 13; `docs/01_architecture_and_invariants.md`.
- **Status:** ACCEPTED

---

### `DEC-003`: Non-Negotiable MUST Requirement Readiness Blocker
- **Date:** 2026-09-15
- **Decision:** In Role Blueprints, an unsatisfied `MUST` requirement is an absolute blocker for readiness. A candidate cannot be classified as `READY` if any `MUST` requirement is unmet, regardless of overall aggregate percentage score.
- **Rationale:** Protects industry trust; ensures candidates possess mandatory prerequisites without hiding deficiencies behind compensatory high scores in optional skills.
- **Affected Area:** `backend` (`roles`, `readiness`), `docs/04_role_blueprint.md`, `docs/05_readiness_matching.md`
- **Source Reference:** `AGENTS.md` Section 6, Section 9.
- **Status:** ACCEPTED

---

### `DEC-004`: Assistive-Only AI Boundaries & Untrusted AI Output
- **Date:** 2026-09-15
- **Decision:** AI is strictly an assistive proposal engine. LLM responses are treated as untrusted input and must pass schema validation, domain validation, and business rule evaluation before persisting state. AI must never directly decide hiring, authoritative proficiency, or final readiness.
- **Rationale:** Eliminates hallucination-driven mutations, guarantees deterministic business operations, and ensures auditability.
- **Affected Area:** `ai`, `backend`
- **Source Reference:** `AGENTS.md` Section 10; `.agents/rules/ai-boundaries.md`.
- **Status:** ACCEPTED

---

### `DEC-005`: Low-Cost Infrastructure Baseline
- **Date:** 2026-09-15
- **Decision:** Initial pilot infrastructure utilizes Cloudflare Pages (Frontend), Google Cloud Run (Backend), Aiven PostgreSQL Free (Database), Cloudflare R2 (Object Storage), and Gemini API (AI). Connection pool size is constrained to stay within Aiven free-tier limits (max 20 connections).
- **Rationale:** Enables zero-cost / low-cost development and pilot operations while maintaining clear migration paths to enterprise cloud equivalents.
- **Affected Area:** `infra`, `backend` (`application.yml`)
- **Source Reference:** `AGENTS.md` Sections 26, 27, 54.
- **Status:** ACCEPTED

---

### `DEC-006`: Deferred Distributed Infrastructure (No Kafka/Redis in V1)
- **Date:** 2026-09-15
- **Decision:** In V1, asynchronous processing uses a PostgreSQL-backed job queue with Spring background workers. Caching uses in-memory Caffeine for reference data. Kafka, RabbitMQ, and Redis/Valkey are deferred until measured scale demands them.
- **Rationale:** Avoids unnecessary infrastructure maintenance and costs before traffic patterns justify distributed message brokers and caches.
- **Affected Area:** `backend`
- **Source Reference:** `AGENTS.md` Sections 22, 23, 24, 63.
- **Status:** ACCEPTED

---

### `DEC-007`: Canonical Skill Taxonomy with Normalization Aliases
- **Date:** 2026-09-15
- **Decision:** Skills must reference stable canonical identifiers. Variant skill spellings and terms are resolved via `SkillAlias` mapping rather than duplicating skill rows or matching on uncontrolled free-text strings.
- **Rationale:** Prevents taxonomy fragmentation and ensures accurate matching between role blueprints, assessments, and evidence.
- **Affected Area:** `backend` (`skills`), `docs/03_skill_competency_model.md`
- **Source Reference:** `AGENTS.md` Section 7.
- **Status:** ACCEPTED

---

### `DEC-008`: Evidence-First Capability Claims
- **Date:** 2026-09-15
- **Decision:** Every capability claim must retain provenance linking to verified evidence (assessment, project, lab, certification, internship) with verification status and date. Course completion alone does not equal demonstrated practical competency.
- **Rationale:** Upholds integrity of talent profiles and prevents credential inflation.
- **Affected Area:** `backend` (`evidence`, `assessments`, `readiness`)
- **Source Reference:** `AGENTS.md` Section 8, Section 34.
- **Status:** ACCEPTED

---

### `DEC-009`: Repository-Controlled Operational Memory
- **Date:** 2026-09-15
- **Decision:** The `collaboration/` directory is the single operational memory for multi-agent and human pair-programming. Personal AI memory and chat transcripts are explicitly non-authoritative.
- **Rationale:** Prevents context loss across chat sessions, eliminates hallucinated task progress, and ensures full transparency in version control.
- **Affected Area:** `collaboration/`, `.agents/`, `AGENTS.md`
- **Source Reference:** `collaboration/README.md`, `AGENTS.md` Section 70.
- **Status:** ACCEPTED
