## Summary
<!-- Provide a concise description of what this PR introduces, fixes, or updates. -->

---

## Task & Scope
- **Task Board ID:** <!-- e.g. TASK-004 from collaboration/TASK_BOARD.md -->
- **Sprint / Milestone:** <!-- e.g. Milestone 1 (Foundation Baseline) -->
- **Scope Alignment:** <!-- Confirmed against docs/16_active_sprint.md -->

---

## Files / Modules Changed
<!-- Group by area: e.g. backend, frontend, db, docs, collaboration, .agents -->
- 

---

## Impact Analysis

### Architectural or Contract Impact
- [ ] No contract or architectural changes.
- [ ] Yes (Explain: <!-- describe OpenAPI contract, Modulith boundary, or domain changes -->)

### Security Impact
- [ ] Authentication / Authorization changes reviewed.
- [ ] No secrets, tokens, or credentials committed.
- [ ] Endpoint access controls verified (no accidental open endpoints).

### Database Impact
- [ ] No database changes.
- [ ] Flyway migration included and backward-compatible.
- [ ] Indexes and constraints verified.

### UI / UX Impact
- [ ] No frontend UI changes.
- [ ] Four mandatory UI states implemented: `IDLE`, `LOADING`, `ERROR`, `EMPTY`.
- [ ] Responsive design and accessibility verified.

---

## Verification Evidence

### Verification Commands Executed
```bash
# Paste exact commands run
python .agents/hooks/security_check.py --changed
python .agents/hooks/verify.py --changed
```

### Verification Results
```text
# Paste concise output or exit status
```

---

## Collaboration State Reconciled
- [ ] `collaboration/TASK_BOARD.md` updated with verification evidence.
- [ ] `collaboration/CURRENT_STATE.md` updated (if milestone status advanced).
- [ ] `collaboration/DECISIONS.md` updated (if non-ADR decisions were made).
- [ ] `collaboration/BLOCKERS.md` updated (if blockers were discovered or resolved).
- [ ] `collaboration/HANDOFF.md` updated with current continuation context.

---

## Risks / Known Limitations
<!-- Note any edge cases, missing environment prerequisites, or deferred items. -->

---

## Reviewer Notes
<!-- Specific guidance for the reviewer or next AI session. -->
