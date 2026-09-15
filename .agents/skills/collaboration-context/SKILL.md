---
name: collaboration-context
description: Manage and maintain Career360 repository operational memory, session startup, execution tracking, and handoffs.
---

# Career360 Collaboration Context Skill

## Purpose
Establishes the Career360 repository as the single shared source of truth for all AI-assisted engineering sessions. Enforces strict session lifecycle discipline so that any Antigravity session can seamlessly continue, verify, and document progress without relying on transient chat transcripts.

---

## 1. Start of Session (Context Ingestion & Discovery)

Before making any code changes or answering implementation questions:

1. **Read Core Governance:** Read `AGENTS.md` for global engineering principles, domain invariants, and non-negotiables.
2. **Read Operational State:**
   - Read `collaboration/CURRENT_STATE.md` (understand current project phase, baseline status, and active milestone).
   - Read `collaboration/TASK_BOARD.md` (identify active, blocked, and available tasks).
   - Read `collaboration/BLOCKERS.md` (check for open impediments affecting your area).
   - Read `collaboration/HANDOFF.md` (inspect previous session exit context and next recommended actions).
3. **Read Targeted Specifications:** Read only the specific documents in `docs/` relevant to the requested task (e.g. `docs/02_domain_model.md`, `docs/06_data_contracts.md`). Do not read all documents blindly.
4. **Inspect Working Tree:** Run `git status` and inspect actual code files on disk. Never assume a previous AI's statements or chat transcripts are correct without verifying repository evidence.
5. **Detect Stale or Contradictory State:** Check whether `TASK_BOARD.md`, `CURRENT_STATE.md`, or `HANDOFF.md` contradict reality on disk. If contradictions exist, resolve them adhering to `collaboration/README.md` Section 5.

---

## 2. Before Implementation (Planning & Scoping)

1. **Task Confirmation:** Ensure the active work item is represented in `collaboration/TASK_BOARD.md`. If picking up a new item from `docs/16_active_sprint.md`, move it to `IN_PROGRESS`.
2. **Check Decisions:** Inspect `collaboration/DECISIONS.md` and any formal ADRs in `decisions/` to align with accepted technical choices.
3. **Define File Scope:** Explicitly identify files to create, modify, or delete. Keep changes isolated to the active task.
4. **Plan Verification:** Identify deterministic tests and checks needed to prove correctness before writing code.

---

## 3. During Implementation (Living State Maintenance)

1. **Record Discoveries:** When important technical realities or constraints are uncovered, note them for inclusion in the handoff.
2. **Record Decisions:** If an architectural or implementation choice is agreed upon, record it immediately in `collaboration/DECISIONS.md` (or formal ADR if altering core architecture).
3. **Record Blockers Immediately:** If an external dependency, missing credential, or requirement conflict halts progress, record it in `collaboration/BLOCKERS.md` using the standard schema.
4. **Zero Justification Abuse:** Never use collaboration files to justify unauthorized or undocumented architecture/domain changes. Authoritative specs in `docs/` and `AGENTS.md` take precedence.
5. **Zero Placeholders:** Never commit `TODO`, `FIXME`, dummy mock responses, or stubbed security bypasses in production paths.

---

## 4. Before Completion (Verification & State Reconciliation)

1. **Execute Verification:**
   - Run lightweight security scan: `python .agents/hooks/security_check.py --changed`
   - Run scoped repository verification: `python .agents/hooks/verify.py --changed`
   - Run applicable unit, integration, build, and typecheck commands.
2. **Reconcile Task Board:** Update `collaboration/TASK_BOARD.md` to reflect verified task status (`READY_FOR_REVIEW` or `DONE`). **Never mark a task DONE without recorded verification evidence.**
3. **Update Current State:** If component maturity or phase changed, update `collaboration/CURRENT_STATE.md`.
4. **Update Decisions & Blockers:** Ensure `collaboration/DECISIONS.md` and `collaboration/BLOCKERS.md` are completely current.
5. **Write Comprehensive Handoff:** Update `collaboration/HANDOFF.md` with exact continuation details:
   - What was completed
   - What remains
   - Files changed
   - Verification commands and results
   - Known failures or limitations
   - Discoveries made
   - Exact next action for the continuing engineer/agent
6. **Report Evidence:** Present clean verification evidence and a list of modified files in your final response.

---

## 5. End of Session Discipline

- Leave the repository in a clean, buildable, and unambiguous state.
- Never exit with an ambiguous "I think this is done" or "The user can test this later".
- Ensure no accidental secrets, passwords, or temporary test scripts are left behind.
