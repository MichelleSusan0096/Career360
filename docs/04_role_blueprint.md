# Career360 — Role Blueprint Specification

**Document:** `docs/04_role_blueprint.md`  
**Status:** Product/Engineering Domain Specification  
**Applies to:** Role definition, industry requirements, skill requirements, assessment alignment, learning/training planning, matching and readiness  
**Primary owner:** Product + Domain Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`

---

## 1. Purpose

The **Role Blueprint** is the central Career360 domain object that translates an industry role into an explicit, measurable capability contract.

Career360 must not treat a job title or uploaded job description as sufficient definition of a role. A Role Blueprint converts role demand into structured requirements that can drive assessment, evidence collection, learning/training, matching and role-specific readiness.

Core flow:

```text
Role / JD
   ↓
Role Blueprint
   ├── Responsibilities
   ├── Competencies
   ├── Skills
   ├── Target Proficiency
   ├── Priority (MUST / SHOULD / COULD / WON'T)
   ├── Eligibility / Constraints
   ├── Evidence Requirements
   ├── Practical Evidence Requirements
   ├── Development / Training Recommendations
   └── Readiness Conditions
          ↓
Assessment → Evidence → Gap → Learning/Training → Reassessment → Readiness
```

The Role Blueprint is therefore a **versioned domain contract**, not merely a form or administrative record.

---

## 2. Product Principle

> **A role becomes actionable when its expected capabilities can be identified, measured, evidenced and evaluated.**

A Role Blueprint must answer:

1. What is this role?
2. What work does the role perform?
3. Which competencies matter?
4. Which canonical skills support those competencies?
5. What proficiency is expected?
6. Which requirements are blockers?
7. What evidence can demonstrate the capability?
8. What training or intervention can close the gap?
9. What conditions must be satisfied before the candidate is considered ready?

---

## 3. Role Blueprint Lifecycle

A role definition may move through the following lifecycle:

```text
DRAFT
  ↓
UNDER_REVIEW
  ↓
APPROVED
  ↓
PUBLISHED
  ↓
ACTIVE
  ↓
RETIRED
```

### 3.1 DRAFT

The blueprint is being created or edited and is not authoritative for production matching/readiness.

### 3.2 UNDER_REVIEW

The blueprint is awaiting human review. AI-generated fields remain proposals until validated.

### 3.3 APPROVED

A responsible authority has reviewed the structure and meaning of the blueprint.

### 3.4 PUBLISHED

The approved blueprint is available for controlled use by authorized workflows.

### 3.5 ACTIVE

The version is currently valid for matching, readiness, training alignment or opportunity use.

### 3.6 RETIRED

The version is no longer active for new decisions but remains immutable for historical traceability.

A retired version must not be silently overwritten or reused as though it were current.

---

## 4. Versioning Rule

Role Blueprints are **versioned immutable decision inputs** once they have been published or used in an authoritative decision.

```text
Role Blueprint: Graduate Backend Engineer
v1 → Published
v2 → Published

Candidate decision in 2026-09-01
uses v1

Later role update
must create/use v2
```

Historical assessments, matches, readiness decisions and reports must retain the blueprint version against which they were produced.

Changing a published blueprint in place is prohibited when the change could alter the meaning of a historical decision.

---

## 5. Role Identity

A Role Blueprint must contain stable role identity information separate from volatile source text.

Recommended conceptual fields:

| Field | Purpose |
|---|---|
| `role_id` | Stable logical identity for the role |
| `blueprint_version` | Version of the capability contract |
| `title` | Human-readable role title |
| `normalized_title` | Standardized title used for search/matching |
| `organization_id` | Owning organization/tenant |
| `industry_domain` | Broad business/technical domain |
| `job_family` | Role family/category |
| `seniority` | Graduate/fresher/junior/etc. |
| `employment_context` | Relevant employment context |
| `location_scope` | Role location/remote/hybrid context when applicable |
| `status` | Lifecycle state |
| `source_type` | Manual/JD/imported/derived |
| `source_reference` | Traceability to source input |
| `effective_from` | Version validity start |
| `effective_to` | Optional version validity end |
| `created_at` | Audit timestamp |
| `updated_at` | Audit timestamp |
`

Exact persistence naming may evolve, but the semantics must remain stable.

---

## 6. Responsibilities

A blueprint should capture the major work outcomes expected from the role.

Each responsibility may include:

```text
Responsibility
├── statement
├── importance
├── related competencies
├── related skills
└── evidence expectations
```

Responsibilities should describe actual work rather than merely copy arbitrary sentences from a source JD.

Examples of structure, not fixed production content:

```text
Design and maintain backend APIs
Build and validate data-processing workflows
Collaborate with frontend and data teams
Investigate production incidents
```

The platform should preserve source traceability when responsibilities originate from an imported JD.

---

## 7. Competency Requirements

A role may require one or more competencies defined in the canonical competency model.

A competency requirement contains at least:

```text
Competency Requirement
├── competency_id
├── target_proficiency
├── priority
├── rationale
├── evidence_requirement(s)
└── notes/constraints
```

A competency is broader than an individual skill. One competency can be composed of multiple skills.

Example:

```text
Backend API Development
 ├── HTTP
 ├── REST
 ├── Authentication
 ├── Authorization
 ├── API Design
 ├── Error Handling
 └── API Testing
```

The role blueprint should prefer canonical IDs over free-text labels.

---

## 8. Skill Requirements

Each skill requirement defines what level is expected for the role.

Conceptual structure:

| Attribute | Meaning |
|---|---|
| Skill | Canonical skill reference |
| Target proficiency | Expected capability level |
| Priority | MUST / SHOULD / COULD / WON'T |
| Weight | Relative importance where the model requires weighting |
| Criticality | Whether failure can block readiness |
| Minimum evidence | Required evidence threshold |
| Practical evidence | Whether hands-on evidence is mandatory |
| Freshness policy | Whether stale evidence loses decision weight |

A role can require a skill even when that skill is not explicitly present in the source JD, provided the requirement is explicitly added and governed by an authorized role owner.

---

## 9. MoSCoW Requirement Priority

Career360 uses MoSCoW to express role requirement priority:

| Priority | Meaning | Readiness effect |
|---|---|---|
| MUST | Required for the role | Usually a blocker if unsatisfied |
| SHOULD | Strongly preferred | Materially improves readiness |
| COULD | Useful but optional | Supportive, non-blocking |
| WON'T | Explicitly excluded from the current scope | Must not be treated as a current requirement |

### 9.1 MUST Requirements

MUST requirements form the primary blocker set.

A candidate should not be labeled fully **READY** when a valid MUST requirement remains materially unsatisfied, unless a separate, explicit domain policy permits an exception and records it.

### 9.2 WON'T Requirements

WON'T requirements are scope exclusions. They must not accidentally enter scoring, matching or training recommendations as active requirements.

---

## 10. Target Proficiency

Target proficiency must use the canonical proficiency model defined in `docs/03_skill_competency_model.md`.

The blueprint specifies **expected** capability, not observed candidate capability.

```text
Role Requirement
    target = PROFICIENCY_3

Candidate Capability
    observed = PROFICIENCY_2

Gap
    target - observed = development need
```

The system must not assume that completing a course or holding a certification automatically proves the target proficiency.

---

## 11. Eligibility and Constraints

Some role conditions are not ordinary skills and should be represented separately from capability scoring.

Possible categories include:

```text
Eligibility
├── Academic constraints
├── Graduation/batch constraints
├── Experience constraints
├── Work authorization constraints
├── Location constraints
├── Schedule constraints
└── Organization-specific constraints
```

These may affect opportunity eligibility or application filtering without being mixed into skill proficiency.

Sensitive or legally significant eligibility rules must be explicitly governed and reviewed before automated enforcement.

---

## 12. Evidence Requirements

Each authoritative capability requirement may specify acceptable evidence types.

Supported evidence categories can include:

```text
Assessment
Practical Lab
Project
Simulation
Certification
Course Completion
Internship
Mentor Evaluation
Faculty Evaluation
Employer Evaluation
Interview
Portfolio Artifact
```

Evidence requirements should answer:

1. What evidence can prove this requirement?
2. Is one evidence item sufficient?
3. Is practical evidence mandatory?
4. How recent must the evidence be?
5. What confidence or verification level is required?

Evidence rules should be requirement-specific rather than universally hard-coded.

---

## 13. Practical Evidence

Practical evidence is especially important for technical and work-oriented capabilities.

Examples include:

```text
Project artifact
Code exercise
Simulation result
Case study
Hands-on lab
Work sample
Employer/faculty practical evaluation
```

A certification may support a capability claim but should not automatically replace practical evidence when the blueprint requires hands-on proof.

---

## 14. Readiness Conditions

A Role Blueprint defines the conditions used by the readiness domain.

Conceptual conditions:

```text
READY when
  required identity/eligibility conditions pass
  AND critical MUST requirements are satisfied
  AND required target proficiency thresholds are met
  AND required practical evidence exists
  AND evidence confidence is sufficient
  AND required evidence freshness is acceptable
  AND no active blocking condition remains
```

The exact readiness algorithm belongs to `docs/05_readiness_matching.md` and must not be duplicated inconsistently inside role management code.

---

## 15. Role Blueprint Sources

A blueprint can originate from several sources:

| Source | Description | Authority |
|---|---|---|
| Manual | Human-created role | Human authority |
| Job Description | Imported organization JD | Requires review |
| Structured Role Template | Existing governed template | Governed |
| AI Proposal | AI-extracted structure | Proposal only until validated |
| Historical Role | Previous approved version | Historical reference |

Source metadata should be preserved.

For imported or AI-assisted blueprints, the system should retain the original source and mapping trace where feasible.

---

## 16. AI-Assisted Blueprint Extraction

AI may accelerate role blueprint creation but cannot be the final authority.

Recommended pipeline:

```text
Raw JD / Input
      ↓
AI Extraction
      ↓
Structured Proposal
      ↓
Schema Validation
      ↓
Canonical Skill/Competency Mapping
      ↓
Domain Validation
      ↓
Human/Authorized Review
      ↓
Approved Role Blueprint
```

AI may propose:

- Role normalization.
- Responsibility extraction.
- Skill/competency candidates.
- Requirement priority proposals.
- Suggested proficiency ranges.
- Evidence recommendations.

AI must not silently publish an authoritative blueprint or change a live requirement without the governed approval path.

---

## 17. Traceability

Every non-trivial requirement should be traceable to its origin where possible.

```text
Role Requirement
     ↓
Source statement / business decision
     ↓
Canonical Skill / Competency
     ↓
Assessment / Evidence rule
     ↓
Readiness outcome
```

This is important for explainability and for diagnosing incorrect matches or readiness decisions.

---

## 18. Change Management

Changes to a role blueprint must be classified by impact.

### 18.1 Non-semantic change

Formatting, notes, display ordering and similar changes may be safe within the same version when they do not alter decision meaning.

### 18.2 Decision-impacting change

Any change to the following normally requires a new version:

- Required skill.
- Target proficiency.
- Priority.
- Criticality.
- Eligibility.
- Evidence threshold.
- Practical evidence rule.
- Readiness condition.

### 18.3 Historical Integrity

Historical readiness, matching, application and reporting records must continue to point to the exact role blueprint version used at decision time.

---

## 19. Aggregate and Boundary Guidance

The Role Blueprint should behave as a coherent domain aggregate for governed changes.

A logical aggregate may include:

```text
Role Blueprint
├── Role Identity
├── Responsibilities
├── Competency Requirements
├── Skill Requirements
├── Eligibility Rules
├── Evidence Requirements
├── Readiness Conditions
└── Version Metadata
```

Assessment results, candidate evidence and learning completion should remain separate aggregates/domains and reference the blueprint rather than becoming embedded mutable state inside it.

---

## 20. Role Blueprint ↔ Opportunity

A job/internship opportunity may reference a specific active Role Blueprint version.

```text
Opportunity
   ↓
Role Blueprint vN
   ↓
Requirements
   ↓
Matching / Eligibility
   ↓
Application
```

An opportunity must not depend on an implicit “latest role” lookup when reproducibility matters.

---

## 21. Role Blueprint ↔ College Planning

College workflows use role blueprints to answer:

```text
Which roles matter?
        ↓
Which competencies/skills do they require?
        ↓
How ready is this batch/department?
        ↓
Which gaps are common?
        ↓
What training program should be created?
```

This creates the role-driven institutional planning loop:

```text
Industry Role
   ↓
Cohort Benchmark
   ↓
Gap Analysis
   ↓
Training Track
   ↓
Reassessment
   ↓
Updated Cohort Readiness
```

---

## 22. Role Blueprint ↔ Learning/Training

Learning recommendations should resolve from requirement gaps.

```text
Role Requirement
      ↓
Candidate Gap
      ↓
Learning/Training Intervention
      ↓
Practical Evidence
      ↓
Reassessment
```

A generic course recommendation is weaker than a traceable recommendation explaining:

```text
Role Requirement
→ Missing capability
→ Recommended intervention
→ Expected evidence
→ Reassessment target
```

---

## 23. Role Blueprint ↔ Matching

Matching should compare a candidate's capability profile against the requirements of a concrete role blueprint version.

Matching should consider at least:

```text
Skill/competency fit
Requirement priority
Proficiency gap
Evidence coverage
Eligibility
Freshness
Blocking MUST requirements
```

Semantic similarity can help candidate retrieval, but authoritative matching outcomes must be grounded in structured requirements and domain rules.

---

## 24. Query and Reporting Views

The system may expose derived views such as:

- Role requirement summary.
- Skill demand by role.
- MUST skill coverage.
- Cohort readiness against a role.
- Top unmet requirements.
- Training demand by role.
- Candidate readiness pool.
- Historical blueprint changes.

These are derived representations and must not become competing sources of truth.

---

## 25. Required Invariants

The following are mandatory:

1. Every authoritative blueprint version has a unique identity and version.
2. Published decision inputs are immutable.
3. Skill and competency references resolve to canonical domain identifiers.
4. Every active requirement has an explicit priority.
5. Target proficiency is explicit where proficiency is applicable.
6. MUST requirements are identifiable as blockers.
7. WON'T requirements are excluded from active decision scoring.
8. AI-generated content is not authoritative until validated through the governed pipeline.
9. Historical decisions retain the blueprint version used at decision time.
10. Role definitions do not directly own candidate evidence or assessment results.
11. Readiness logic is centralized in the readiness domain.
12. Tenant ownership and authorization apply to all role operations.
13. A missing optional field must not be silently interpreted as an active requirement.
14. A deleted/retired role blueprint must remain reconstructible for historical records.

---

## 26. Minimum Implementation Shape

A production implementation should separate:

```text
Role Management
├── Role identity
├── Blueprint versions
├── Responsibilities
├── Requirement definitions
└── Approval/publication lifecycle

Capability References
├── Canonical skills
├── Competencies
└── Proficiency definitions

Decision Inputs
├── Evidence requirements
├── Eligibility rules
└── Readiness conditions
```

Persistence structure may use normalized relational tables and stable foreign keys. JSON is appropriate for bounded, genuinely flexible metadata, not as a substitute for core relational semantics.

---

## 27. Example Blueprint

Illustrative example only:

```text
Role: Graduate Backend Engineer
Version: 1

Responsibilities
- Build backend APIs
- Implement business services
- Write automated tests
- Work with relational data

MUST
- Java
- Spring Boot
- REST API development
- SQL

SHOULD
- Automated testing
- Git
- Cloud deployment fundamentals

Competency targets
- Backend API Development → Level 3
- Database Development → Level 3
- Software Testing → Level 2

Evidence
- Technical assessment
- Practical API exercise
- Project evidence

Practical evidence required
- Backend/API implementation

Readiness blockers
- Any unmet MUST skill at the minimum target
- Missing required practical evidence
```

This example illustrates the structure only; actual target levels and requirement sets must come from an approved role definition.

---

## 28. Acceptance Criteria

### AC-01 — Role Creation
**Given** an authorized role owner,  
**when** a role is created,  
**then** the system creates a draft blueprint with stable identity and version metadata.

### AC-02 — Requirement Canonicalization
**Given** a skill requirement,  
**when** it is added to a blueprint,  
**then** it references a canonical skill identifier rather than relying solely on free text.

### AC-03 — MoSCoW
**Given** a role requirement,  
**when** it becomes active,  
**then** it has an explicit MoSCoW priority.

### AC-04 — Publication
**Given** an AI-generated draft,  
**when** it has not passed the governed validation/review path,  
**then** it cannot become an authoritative published blueprint.

### AC-05 — Version Integrity
**Given** a published blueprint used by a readiness decision,  
**when** the role requirements change,  
**then** a new decision-relevant version is created rather than silently mutating historical inputs.

### AC-06 — Practical Evidence
**Given** a MUST requirement marked as requiring practical evidence,  
**when** a candidate has only course-completion evidence,  
**then** the system does not treat the practical-evidence requirement as satisfied solely by course completion.

### AC-07 — Historical Reproducibility
**Given** a historical application or readiness decision,  
**when** the role is later updated,  
**then** the historical decision still resolves to the blueprint version originally used.

---

## 29. Engineering Guidance

Implement Role Blueprint as a first-class domain capability, not as a JSON blob attached to a job posting.

Use relational identity for role, version, skill requirements, competency requirements, priorities and evidence rules. Keep source payloads or extraction metadata separately where flexibility is required.

Keep the following services/domain policies distinct:

```text
RoleBlueprintService
RoleBlueprintVersionPolicy
RoleRequirementService
BlueprintPublicationPolicy
BlueprintValidationService
```

The exact class decomposition may differ, but the boundaries should preserve the domain responsibilities defined here.

---

## 30. Final Definition

> **The Career360 Role Blueprint is a versioned, evidence-aware capability contract that translates an industry role into canonical competencies, skills, priorities, proficiency targets, evidence expectations and readiness conditions, and serves as the authoritative bridge between industry demand and student capability development.**
