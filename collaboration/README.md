# Career360 — Collaboration Protocol & Operational Memory

## 1. Purpose of the Collaboration Layer

The `collaboration/` directory serves as the **authoritative, repository-controlled operational memory** for all AI agents, engineers, and contributors working on Career360.

In multi-session and multi-agent development:
- Personal AI memory is transient, fragmented, and **never authoritative**.
- Chat logs and session transcripts are ephemeral and **never the source of truth**.
- **Committed repository files are the single shared source of truth.**

This collaboration layer tracks live project status, active tasks, agreed operational decisions, blockers, and handoff state directly in version control. Every AI session starts by reading this state and finishes by updating it.

---

## 2. Source-of-Truth Hierarchy & Precedence

When evaluating project direction or resolving discrepancies, apply the following strict hierarchy:

```text
1. AGENTS.md
   └── Root project governance, architectural rules, and session protocols.

2. docs/ (Product & Domain Specifications)
   └── Canonical definitions of product vision, architecture, domain models, contracts, security, and sprint scope.

3. decisions/ (Formal ADRs)
   └── Formal Architecture Decision Records (when present).

4. collaboration/ (Operational Project Memory)
   └── Living state of the codebase:
       ├── CURRENT_STATE.md  (What is true right now)
       ├── TASK_BOARD.md     (Current work items and status)
       ├── DECISIONS.md      (Concise accepted decisions not requiring full ADRs)
       ├── BLOCKERS.md       (Active blockers and impediments)
       └── HANDOFF.md        (Session continuation bridge)

5. Task-Specific Implementation Context
   └── Prompts and active ticket/task instructions.

6. Personal AI Memory / Chat History (Lowest)
   └── NEVER authoritative; must be validated against repository files.
```

> [!IMPORTANT]
> The `collaboration/` operational layer cannot override or loosen architectural, security, or domain invariants established in `AGENTS.md` and `docs/`.

---

## 3. Collaboration Files Overview

| File | Purpose | Update Cadence |
|---|---|---|
| [`CURRENT_STATE.md`](./CURRENT_STATE.md) | High-level snapshot of project phase, modules, migrations, and readiness. | When milestone, phase, or major architectural status changes. |
| [`TASK_BOARD.md`](./TASK_BOARD.md) | Work breakdown tracking tasks through `TODO`, `IN_PROGRESS`, `BLOCKED`, `READY_FOR_REVIEW`, `DONE`. | Before picking up a task, upon state transitions, and after verification. |
| [`DECISIONS.md`](./DECISIONS.md) | Log of concise accepted technical and domain decisions. | Whenever a non-ADR technical decision is agreed upon. |
| [`BLOCKERS.md`](./BLOCKERS.md) | Record of active impediments preventing progress. | Immediately when a blocker is discovered or resolved. |
| [`HANDOFF.md`](./HANDOFF.md) | Self-contained continuation context for the next session. | At the conclusion of every session or meaningful chunk of work. |

---

## 4. Required Session Procedures

Every AI agent working in this repository must adhere to the following three procedures:

### A. Startup Procedure (Start of Session)

1. **Read Root Governance**: Inspect `AGENTS.md` to refresh global engineering protocol and constraints.
2. **Read Operational State**:
   - `collaboration/CURRENT_STATE.md` (understand current baseline and active milestone)
   - `collaboration/TASK_BOARD.md` (see what tasks are active and available)
   - `collaboration/BLOCKERS.md` (check for open blockers)
   - `collaboration/HANDOFF.md` (inspect the last session's exit state and next actions)
3. **Inspect Git Status**: Run `git status` and check branch/modified files to observe real working tree state.
4. **Detect Contradictions / Stale Context**: Compare documented state with physical files on disk (see Section 5).
5. **Read Specific Specs**: Read only the relevant `docs/*.md` files needed for the active task.
6. **Confirm Task**: Ensure the intended work is reflected on `TASK_BOARD.md` under `IN_PROGRESS`.

### B. Implementation Procedure (During Session)

1. **Scope Discipline**: Stay strictly within the scope of the active milestone defined in `docs/16_active_sprint.md`.
2. **Zero Inventions**: Do not invent decisions, requirements, teammate names, assignees, or completed features.
3. **Immediate Blocker Recording**: If an environmental, dependency, or specification issue halts work, record it immediately in `collaboration/BLOCKERS.md`.
4. **Immediate Decision Recording**: If an architectural or design choice is made within allowed authority, record it in `collaboration/DECISIONS.md`.
5. **Zero Placeholders**: No `TODO`, `FIXME`, dummy responses, or bypasses in production code paths.

### C. Completion & Handoff Procedure (End of Session)

1. **Execute Verification**: Run deterministic checks (`python .agents/hooks/security_check.py --changed`, `python .agents/hooks/verify.py --changed`, plus applicable unit/build commands).
2. **Update Task Board**: Transition task status in `TASK_BOARD.md` only with evidence of verification.
3. **Update Current State**: If milestone or component status advanced, update `CURRENT_STATE.md`.
4. **Update Blockers**: Mark resolved blockers as closed in `BLOCKERS.md`.
5. **Write Handoff**: Update `collaboration/HANDOFF.md` with:
   - What was accomplished
   - What remains
   - Files changed
   - Verification commands and results
   - Important discoveries
   - Blockers encountered
   - Exact next continuation action
6. **Clean State**: Ensure no temporary test artifacts, secrets, or unstaged unintended edits remain.

---

## 5. Stale-Context & Contradiction Detection

AI agents must actively detect discrepancies between documented collaboration state and reality on disk.

### Common Contradictions to Catch:
- `TASK_BOARD.md` claims an item is `DONE`, but the corresponding files or tests do not exist.
- `CURRENT_STATE.md` states a migration exists, but no migration file is present in `backend/src/main/resources/db/migration/`.
- `HANDOFF.md` references non-existent files or outdated branch names.
- `DECISIONS.md` records an approach that contradicts an invariant in `AGENTS.md` or `docs/`.
- `BLOCKERS.md` lists an issue as open that has already been verified and resolved.

### Contradiction Resolution Protocol:
1. **Never silently choose one side.**
2. **Preserve authoritative documentation**: `AGENTS.md` and `docs/` always win over operational notes.
3. **Inspect disk evidence**: Actual implementation and passing tests define reality over text claims.
4. **Update the record**: Reconcile the discrepancy in the appropriate `collaboration/*.md` file and document the correction in `HANDOFF.md`.

---

## 6. Git & Branching Collaboration Rules

To enable safe multi-agent and human collaboration:

1. **Stable Main Branch**: The `main` branch is protected and contains only verified, passing code.
2. **Feature Branches**: Every task or milestone is implemented on an isolated branch created from latest `main`.
3. **Fresh Start**: Before starting, verify `git status` and pull the latest changes.
4. **Atomic Scope**: One feature or logical slice per branch. Avoid bundling unrelated refactors.
5. **Reconciliation**: Reconcile `collaboration/` files before raising a Pull Request.
6. **No Overwriting**: Never overwrite or delete another contributor's in-progress work. If work overlaps, surface it in `BLOCKERS.md`.
7. **Pull Request Gate**: All contributions merge to `main` via PR using `.github/PULL_REQUEST_TEMPLATE.md`.

---

## 7. Security Invariants

- **Zero Secrets**: Never commit passwords, tokens, API keys, credentials, or private personal data to any file in `collaboration/` or across the repository.
- **Verification Hook**: All changes must pass `python .agents/hooks/security_check.py --changed`.
