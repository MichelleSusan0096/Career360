# Career360 — Contributing Guidelines

Welcome to the Career360 repository. This project operates on an **AI-first, human-governed engineering workflow** designed for high velocity, rigorous type-safety, and strict architectural integrity.

---

## 1. Collaborative Operating Model

In Career360:
- **Humans** define requirements, prioritize the active sprint (`docs/16_active_sprint.md`), approve architectural proposals, and review integration pull requests.
- **AI Agents (Antigravity)** execute implementation, author tests, maintain documentation, update operational memory (`collaboration/`), and run verification hooks.

Neither operates in isolation. The repository itself is the single source of truth connecting human decisions and AI execution.

---

## 2. Branching Strategy & Isolation

1. **Protected `main` Branch:**
   - The `main` branch represents stable, verified, passing software.
   - **Direct commits or pushes to `main` are prohibited.**
2. **Feature & Task Branches:**
   - Always create a fresh branch from the latest `main` before starting work.
   - Use clear, descriptive branch names indicating area and purpose (e.g. `feat/identity-models`, `fix/flyway-constraints`, `docs/collaboration-layer`).
   - Limit branch scope to one logical feature, vertical slice, or sprint task.
3. **Rebasing and Pulling:**
   - Keep feature branches up-to-date with `main` to prevent drift.
   - Never force-push (`git push --force`) to shared or protected branches.

---

## 3. Pre-Implementation Workflow

Before touching source code:
1. **Review Sprint Contract:** Check `docs/16_active_sprint.md` to ensure the requested capability is actively in scope.
2. **Review Operational State:**
   - Read `collaboration/CURRENT_STATE.md`
   - Claim or update the task in `collaboration/TASK_BOARD.md` (`IN_PROGRESS`)
   - Check `collaboration/BLOCKERS.md` and `collaboration/DECISIONS.md`
3. **Inspect Specifications:** Read the relevant domain documents in `docs/` and adhere strictly to `AGENTS.md`.

---

## 4. Implementation Rules

1. **Zero Placeholders:**
   - Never commit `TODO`, `FIXME`, mock endpoints, stubbed return values, or fake data in production code paths.
2. **Strict Type Safety:**
   - Java: No raw types, swallowed exceptions, or unchecked casts.
   - TypeScript: Strict mode enforced. `any`, `@ts-ignore`, and unsafe casts are forbidden.
3. **Architectural Invariants:**
   - Changes to core domain models, security policies, API data contracts, or infrastructure must be explicitly approved and documented.
   - Adhere to the closed-loop readiness invariants: `MUST` requirements can never be bypassed or diluted.
4. **Security & Secrets:**
   - **Never commit real credentials, passwords, private keys, API keys, or tokens.**
   - All code and configuration must pass `python .agents/hooks/security_check.py --changed`.

---

## 5. Pre-Merge Verification Gate

Before raising or merging a Pull Request, the contributor (or AI agent) must run deterministic verification:

1. **Security Scan:**
   ```bash
   python .agents/hooks/security_check.py --changed
   ```
2. **Repository & Build Hygiene:**
   ```bash
   python .agents/hooks/verify.py --changed
   ```
3. **Component Tests:**
   - Backend: Unit and integration tests passing (`mvn test` or `./mvnw test` / `mvnw.cmd test`).
   - Frontend: Lint, typecheck, and unit tests passing (`npm run lint`, `npm run typecheck`, `npm run test`).
4. **Update Operational Memory:**
   - Reconcile `collaboration/TASK_BOARD.md` with verification evidence.
   - Update `collaboration/CURRENT_STATE.md` if milestone boundaries advanced.
   - Record newly accepted decisions in `collaboration/DECISIONS.md`.
   - Update `collaboration/HANDOFF.md` with clear exit state.

---

## 6. Pull Request Protocol

1. **Use the PR Template:** Open all pull requests using `.github/PULL_REQUEST_TEMPLATE.md`.
2. **Reference Tasks & Evidence:** Every PR description must link to the specific task ID on `collaboration/TASK_BOARD.md` and include exact verification command outputs.
3. **Review & Approval:**
   - PRs modifying architectural boundaries, database schemas, security configurations, or data contracts require explicit human review.
   - Merge only when required automated hooks, security checks, and code reviews pass.
