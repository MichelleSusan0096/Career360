# Career360 Agent Rule: UI Craft

## Purpose
Make Career360 workflows understandable, trustworthy, accessible, and operationally useful.

## Design system first
Follow `docs/13_design_system.md`. Prefer shared tokens/components over one-off styles. Do not invent arbitrary colors, spacing, radii, shadows, typography, or interaction patterns when a project standard exists.

## UI priorities
Prioritize:
1. clarity
2. trust
3. task completion
4. evidence visibility
5. actionable next steps
6. consistency
7. accessibility
8. polish

Avoid decoration that does not improve a user task or decision.

## Data states
Data-driven screens must handle Idle, Loading, Error, Empty, and Success/populated states. Do not implement only the happy path.

## Role-aware UI
Student, faculty, placement officer, HOD, college admin, company, and admin experiences must expose only valid actions for the active scope.

Frontend hiding is not authorization; backend authorization remains authoritative.

## Readiness UI
A readiness view should make the basis understandable, including as appropriate: target role, readiness state, critical requirements, satisfied requirements, blocking gaps, evidence, evidence freshness/confidence, recommended next action, and reassessment status.

Never reduce readiness to an unexplained AI percentage.

## Matching UI
Show why a match is strong or blocked: strengths, unmet MUST requirements, relevant gaps, evidence quality, eligibility, and recommendation rationale.

## Assessment UI
Clearly communicate assessment type, purpose, instructions, time/attempt rules, progress, submission state, result availability, and the remediation/reassessment path. Do not reveal protected scoring or answer information contrary to domain rules.

## Evidence UI
Evidence views should identify evidence type, skill/competency relationship, issuer/evaluator, date, result, verification state where applicable, source, and role relevance.

Where supported, distinguish submitted, verified, stale, disputed, and rejected evidence.

## Tables and analytics
Use tables for comparison, filtering, scanning, operations, and export. Use charts for meaningful trends, distributions, gaps, and comparisons.

Every chart needs clear labels, context, meaningful units, a useful empty state, and an accessible summary.

## Forms
Forms must group related data, use clear labels, validate near the point of error, preserve recoverable input, distinguish required/optional fields, provide useful help text, and prevent impossible submissions.

## Destructive actions
For destructive/irreversible actions, explain impact, identify affected data/processes, require confirmation when appropriate, and prevent accidental activation.

## Accessibility
Support keyboard navigation, visible focus, semantic HTML, labels, adequate contrast, accessible errors, screen-reader-compatible controls, non-color-only status communication, and logical headings. Do not rely on hover alone for essential information.

## Responsive behavior
Support expected laptop, tablet, and mobile widths while preserving navigation, actions, forms, tables, and status information. Use appropriate responsive patterns for dense operational tables.

## Navigation
Every page should make clear the current context, organization/scope, workflow stage, and primary action. Avoid excessive nesting.

## Provenance and trust
When data is AI-generated, inferred, externally sourced, stale, or pending verification, the UI must communicate that clearly.

Where useful, show source, last update, verification state, confidence/quality, and human-review state.

## AI interaction
AI should feel like a copilot, not an invisible authority.

Use labels such as Suggested, Proposed, Needs review, and Based on provided requirements.

Do not imply certainty where the system is making an inference.

For AI proposals that can become authoritative, provide a review/confirmation path unless a documented domain rule safely defines automated approval.

## Performance
Avoid unnecessary network requests, rerenders, duplicate queries, and oversized client datasets. Use TanStack Query for server state and paginate/virtualize large operational datasets.

Do not move authoritative business logic to the browser to gain perceived speed.

## Interaction feedback
Give clear feedback for save, submit, publish, upload, enroll, apply, approve, reject, assign, and schedule actions. Use loading/disabled states to prevent duplicate submissions.

## Visual hierarchy
Readiness:

`Role → Readiness → Blocking gaps → Evidence → Next action`

College:

`Cohort → Readiness/Gaps → Priority → Intervention → Outcome`

Company:

`Role → Required capability → Candidate/Pool readiness → Gaps → Outcome`

## Avoid
Do not ship placeholder-looking cards, lorem ipsum, fake KPIs, decorative progress bars without domain meaning, excessive animation, modal-heavy workflows, tiny low-contrast text, hidden required actions, unexplained icons, charts without interpretation, or unexplained “AI magic”.

## UI acceptance checklist
Before completion, verify design-system compliance, all required data states, error handling, role/scope behavior, business-state explanation, keyboard accessibility, responsive behavior, truthful visualization, duplicate-submission prevention, real API/data paths, and browser validation for critical flows.

The objective is a correct, understandable Career360 workflow—not merely an attractive screen.
