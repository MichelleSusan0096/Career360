# Career360 Agent Rule: Domain Integrity

## Purpose
Prevent domain drift across backend, frontend, database, analytics, and AI workflows.

## Canonical concepts
Use established terminology consistently:

Organization, College, Department, Batch, Student, Company, User, Membership, Skill, Competency, Role, Role Blueprint, Assessment, Assessment Attempt, Evidence, Skill Gap, Readiness, Learning Path, Course, Training Program, Opportunity, Application, Interview, Outcome, Employer Feedback.

Do not introduce competing names for established concepts.

## Role Blueprint
Role Blueprint is the central role-requirement object. It may contain role identity, responsibilities, competencies, skills, target proficiency, MUST/SHOULD/COULD/WON'T priority, eligibility, evidence requirements, practical evidence requirements, training recommendations, readiness conditions, and version information.

A raw JD is not the authoritative blueprint.

`Raw Requirement → Structured Role Blueprint → Validation → Versioned Requirement Set`

## Skills and competencies
A Skill is a specific capability. A Competency is a broader capability composed of related skills.

Example:

`Backend API Development`
may include HTTP, REST API design, authentication/authorization, validation, error handling, and testing.

Do not collapse competencies into single skills for convenience.

## Canonical taxonomy
Aliases, abbreviations, synonyms, and employer vocabulary should map to canonical skills where valid. Do not create duplicate canonical skills for capitalization, punctuation, aliases, or minor naming variants.

## Evidence-first capability
Authoritative capability claims must be traceable to evidence.

Evidence can originate from assessments, labs, projects, simulations, certifications, course completion, internships, mentor/faculty evaluations, employer evaluations, and interviews.

Course completion/certification alone does not automatically prove practical competence.

Evidence should preserve source, date, subject, supported skill/competency, result, evaluator, and relevant trust/freshness information.

## Skill gaps and MoSCoW
A gap exists when demonstrated capability is below the applicable Role Blueprint requirement.

Priority semantics:
- MUST: can block readiness
- SHOULD: material development need
- COULD: optional enhancement
- WON'T: excluded from current scope

Do not replace role-specific requirements with arbitrary universal thresholds.

## Readiness
Readiness is role-specific and should consider, where applicable, skill fit, critical requirement satisfaction, practical evidence, evidence confidence, evidence freshness, and eligibility/behavioral requirements.

PRI is an institutional/reporting metric and must not silently replace role-specific readiness.

Canonical state progression:

`NOT_ASSESSED → ASSESSED → GAP_IDENTIFIED → IN_TRAINING → PENDING_REASSESSMENT → PROVISIONALLY_READY → READY`

A later `STALE` state may be introduced by product policy.

Do not jump to `READY` solely because of course completion, AI prediction, or manual preference.

## Reassessment
The intended loop is:

`Gap → Intervention → Practice → New Evidence → Reassessment → Updated Readiness`

Training completion is not automatically evidence.

## Matching
Keep semantic similarity, requirement satisfaction, readiness, and eligibility distinct. A high similarity score cannot override a MUST requirement.

## Industry intelligence
Preserve source, observation date, context, normalization state, confidence, and role/skill mapping for industry signals. Inferred trends must be labeled appropriately.

## Opportunities and applications
An Opportunity has its own owner, lifecycle, requirements, dates, eligibility, and application rules. An Application records participation in one opportunity. Do not merge opportunity state with application state.

## Course and Training Program
A Course is reusable learning content. A Training Program is contextual intervention that can target a role/cohort and include skills, gap rationale, modules, trainers, schedule, assignments, evidence, and reassessment.

## Shared domain, multiple perspectives
Student, college, and company screens must consume the same domain truth rather than duplicate business models.

## Historical integrity
Material requirement changes must be versioned where applicable. Do not silently rewrite historical decisions. Historical outcomes must remain interpretable under the applicable requirement version.

## Scope and tenancy
Tenant-owned entities require explicit ownership/scope. Typical hierarchies:

`College → Department → Batch → Student`

`Company → Role/Opportunity`

Cross-organization relationships must be deliberate and authorized.

## AI boundary
AI can propose structured domain objects but cannot silently create authoritative truth.

Example:

`JD → AI Role Blueprint Proposal → Validation → Versioned Role Blueprint`

Apply the same principle to skill normalization, gap explanations, training proposals, and trend summaries.

## Domain change checklist
Before accepting a domain change, verify canonical terminology, module ownership, scope, evidence provenance, versioning, MUST blockers, readiness state transitions, separation of similarity from readiness, historical interpretability, and auditability.
