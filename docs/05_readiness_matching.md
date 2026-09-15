# Career360 — Readiness & Matching Specification

**Document:** `docs/05_readiness_matching.md`  
**Status:** Product/Engineering Decision Model  
**Applies to:** Candidate capability evaluation, role readiness, skill-gap evaluation, matching, readiness lifecycle and explainability  
**Primary owner:** Product + Domain Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`, `docs/04_role_blueprint.md`

---

## 1. Purpose

Career360 must distinguish between:

- what a student claims to know,
- what an assessment measures,
- what evidence demonstrates,
- what a target role requires,
- and whether the available evidence is sufficient to consider the student ready.

The central model is:

```text
Role Blueprint
      ↓
Required Capabilities
      ↓
Candidate Capability Profile
      ↓
Evidence Evaluation
      ↓
Gap Analysis
      ↓
Role-Specific Readiness
      ↓
Matching / Opportunity Recommendation
```

The system must not collapse readiness and matching into one opaque AI score.

---

## 2. Product Principle

> **Readiness is a role-specific, evidence-backed decision state. Matching is a structured comparison between a candidate capability profile and a concrete role requirement set.**

A student can be highly capable for one role and not ready for another. Therefore:

```text
Student Readiness ≠ Universal Readiness

Student + Role Blueprint → Role-Specific Readiness
```

Career360 may expose institution-level metrics such as Placement Readiness Index (PRI), but PRI must not replace role-specific readiness.

---

## 3. Readiness Lifecycle

The canonical lifecycle is:

```text
NOT_ASSESSED
      ↓
ASSESSED
      ↓
GAP_IDENTIFIED
      ↓
IN_TRAINING
      ↓
PENDING_REASSESSMENT
      ↓
PROVISIONALLY_READY
      ↓
READY
```

A future extension may introduce:

```text
READY → STALE
```

when evidence freshness policies determine that a prior readiness state is no longer sufficiently current.

### State semantics

| State | Meaning |
|---|---|
| NOT_ASSESSED | Insufficient authoritative capability data |
| ASSESSED | Capability has been measured/evaluated |
| GAP_IDENTIFIED | One or more relevant gaps exist |
| IN_TRAINING | Candidate is actively following a development intervention |
| PENDING_REASSESSMENT | Training/evidence exists but final target capability has not been re-evaluated |
| PROVISIONALLY_READY | Readiness criteria are substantially satisfied but a final policy step remains |
| READY | All required readiness conditions are satisfied |
| STALE | Previous readiness cannot be treated as current under freshness policy |

State transitions must be explicit and auditable.

---

## 4. Core Objects

The readiness domain should reason over at least these conceptual objects:

```text
Role Blueprint
Candidate Capability
Evidence
Skill Gap
Readiness Assessment
Match Result
Readiness Decision
```

These should remain logically distinct even when implemented within one modular monolith.

---

## 5. Candidate Capability Profile

A Candidate Capability Profile is the current structured view of a candidate's demonstrated capabilities.

Conceptually:

```text
Candidate Capability
├── Skill
├── Observed proficiency
├── Competency contribution
├── Evidence set
├── Evidence confidence
├── Evidence freshness
├── Verification status
└── Last evaluated timestamp
```

The profile should be built from authoritative evidence rather than simply accepting self-declared values as verified capability.

Self-declaration can be retained as a signal, but must be distinguishable from assessed/verified capability.

---

## 6. Evidence Model

Evidence is the primary foundation of readiness.

Possible evidence sources include:

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

Evidence should contain sufficient provenance for decision explanation, including source, date, verification state and relevant result/score where applicable.

---

## 7. Evidence Confidence

Not all evidence has equal decision strength.

A conceptual confidence dimension may consider:

```text
Source authority
Verification strength
Assessment quality
Practical relevance
Recency
Consistency with other evidence
```

The exact scoring implementation must remain explainable and configurable.

The platform must never imply that confidence is objectively precise when it is only a domain heuristic.

---

## 8. Evidence Freshness

Capability evidence can become less representative over time, especially for fast-changing technologies.

A freshness policy can be attached to a role requirement or evidence type.

Conceptually:

```text
Evidence freshness
= current_date - evidence_date
```

Freshness should not be used as a universal hard-coded expiry rule. The relevant policy depends on the capability and role.

Where stale evidence matters, readiness may move to `STALE` or lose confidence until reassessment occurs.

---

## 9. Requirement Evaluation

For each role requirement, the readiness engine should determine:

```text
Required skill/competency
Target proficiency
Candidate demonstrated proficiency
Evidence coverage
Evidence confidence
Evidence freshness
Priority
Criticality
Gap
Satisfied?
Blocking?
```

A conceptual requirement evaluation looks like:

```text
Required = Level 3
Observed = Level 2

Gap = Level 1

Priority = MUST
Practical Evidence = Required
Practical Evidence = Missing

Result = BLOCKED
```

---

## 10. Skill Gap

The skill gap is the difference between required and demonstrated capability.

For proficiency-ordered models:

```text
Gap = max(Target Proficiency - Observed Proficiency, 0)
```

The system should also capture gap type:

```text
NO_EVIDENCE
UNDER_TARGET
STALE_EVIDENCE
INSUFFICIENT_CONFIDENCE
MISSING_PRACTICAL_EVIDENCE
ELIGIBILITY_BLOCK
```

A numerical gap alone is not enough to explain why a candidate is not ready.

---

## 11. Requirement Satisfaction

A requirement is considered satisfied only when its applicable domain conditions pass.

Conceptual rule:

```text
Requirement Satisfied
=
  capability threshold met
  AND evidence requirements met
  AND confidence threshold met
  AND freshness policy met
  AND practical evidence rule met
  AND eligibility constraints met
```

Not every requirement needs every condition. The Role Blueprint defines the applicable rules.

---

## 12. MUST Requirement Blocking

MUST requirements form the primary blocking set.

Conceptually:

```text
Any active MUST requirement
that is materially unsatisfied
→ READY = false
```

Exceptions, where explicitly supported by business policy, must be:

- authorized,
- recorded,
- explainable,
- time-bounded where appropriate,
- and auditable.

The system must not silently downgrade a MUST requirement to SHOULD because the candidate has a high overall score.

---

## 13. Readiness Decision

Readiness should be computed from structured requirement evaluations rather than from a single opaque score.

A conceptual result:

```text
Role Readiness
├── Status
├── Overall coverage
├── MUST requirements satisfied
├── MUST blockers
├── SHOULD gaps
├── Evidence confidence
├── Evidence freshness
├── Practical evidence coverage
├── Eligibility state
├── Last assessed time
└── Explanation
```

The decision should be reproducible from the blueprint version, candidate evidence and business rules used at the time.

---

## 14. Role-Specific Readiness Logic

A candidate can be evaluated against multiple roles:

```text
Candidate A
 ├── Backend Engineer → READY
 ├── Data Analyst → PROVISIONALLY_READY
 └── Product Analyst → GAP_IDENTIFIED
```

This is an intended product behavior, not an exception.

A universal student score may be useful for dashboards, but role-specific decisions must remain primary for career guidance, matching and readiness.

---

## 15. Placement Readiness Index (PRI)

Career360 may retain the institutional PRI model for reporting.

The documented baseline is:

```text
PRI = Technical × 40%
    + Aptitude × 40%
    + Soft Skills × 20%
```

The corresponding skill-gap baseline may be represented as:

```text
Skill Gap Score = (Student Score / Benchmark) × 100
```

PRI is useful for college-level benchmarking and reporting, but it must not be used as the sole authority for whether a student is ready for a specific role.

Role readiness remains blocker-aware and evidence-aware.

---

## 16. Readiness Explanation

Every important readiness result should be explainable in business terms.

Example explanation structure:

```text
Target role: Graduate Backend Engineer
Blueprint: v3

Ready requirements: 9 / 11
MUST blockers: 1

Blocker:
- REST API Testing
- Target: Level 2
- Observed: Level 1
- Practical evidence: missing

Recommended next step:
- Complete API testing practical
- Reassess requirement
```

The UI should expose evidence and rules behind the result rather than only showing a percentage.

---

## 17. Matching Purpose

Matching answers:

> **How well does this candidate's demonstrated capability fit this specific role opportunity?**

Matching is not identical to hiring.

Career360 should position matching as a decision-support capability that helps surface:

```text
READY candidates
PROVISIONALLY_READY candidates
TRAINABLE candidates
LOW-FIT candidates
```

Final hiring authority remains with the employer's governed process.

---

## 18. Matching Inputs

A structured matching model may use:

```text
Role requirements
Candidate capabilities
Requirement priority
Proficiency gaps
Evidence coverage
Evidence confidence
Evidence freshness
Eligibility
Practical evidence
Role/context preferences
```

Semantic similarity can support retrieval, especially when source text and candidate portfolios use different wording, but structured canonical capability mapping must remain the basis for authoritative requirement checks.

---

## 19. Match Classes

A useful conceptual classification is:

| Match class | Meaning |
|---|---|
| READY_MATCH | Candidate satisfies all required readiness conditions |
| PROVISIONAL_MATCH | Candidate is near-ready with explicitly remaining conditions |
| TRAINABLE_MATCH | Candidate has a credible path to readiness through known gaps |
| LOW_MATCH | Material capability mismatch |
| INELIGIBLE | Eligibility condition prevents application |

These labels should be backed by explicit rules and not assigned purely by generative AI.

---

## 20. Matching Score

Career360 may expose a normalized fit score for ranking, but the score must remain subordinate to rule evaluation.

A conceptual model could be:

```text
Fit Score
  = weighted capability coverage
    + evidence confidence contribution
    + freshness contribution
    + contextual fit contribution
```

MUST blockers must remain separately represented.

A candidate with a high fit score must not be labeled READY when a blocking requirement is unmet.

Do not implement unexplained formulas solely to make the product appear intelligent. Scoring weights must have a documented business rationale.

---

## 21. Trainability

Career360's closed-loop value includes a distinct **trainable** state.

Trainability asks:

```text
The candidate is not ready today.
Can the identified gaps be addressed through a realistic learning/training intervention?
```

Signals can include:

```text
Gap magnitude
Number of blockers
Available learning path
Training availability
Estimated intervention scope
Current evidence strength
Reassessment feasibility
```

Trainability is a planning signal, not a guarantee of future performance.

---

## 22. Gap-to-Training Loop

The preferred product loop is:

```text
Role Blueprint
     ↓
Readiness Evaluation
     ↓
Gap Identification
     ↓
Training Recommendation
     ↓
Learning / Training
     ↓
Practical Evidence
     ↓
Reassessment
     ↓
Updated Readiness
```

The learning recommendation should preserve traceability to the original role requirement.

---

## 23. Reassessment

Reassessment is a first-class part of the readiness lifecycle.

Training completion alone should not automatically transition a candidate to READY.

Example:

```text
Before training:
REST API Testing → Level 1

Training completed:
REST API Testing → unknown improvement

Practical reassessment:
REST API Testing → Level 2

Requirement:
Target Level 2 / MUST

Result:
Requirement satisfied
```

The actual transition should come from evidence/assessment results.

---

## 24. Readiness State Transition Rules

Example policy:

```text
NOT_ASSESSED
  └─ authoritative assessment/evidence exists → ASSESSED

ASSESSED
  ├─ gaps exist → GAP_IDENTIFIED
  └─ all assessed requirements satisfied → PROVISIONALLY_READY or READY

GAP_IDENTIFIED
  └─ intervention started → IN_TRAINING

IN_TRAINING
  └─ intervention completed and reassessment required → PENDING_REASSESSMENT

PENDING_REASSESSMENT
  ├─ target now satisfied → PROVISIONALLY_READY
  └─ target still unmet → GAP_IDENTIFIED / IN_TRAINING

PROVISIONALLY_READY
  └─ final readiness checks pass → READY

READY
  └─ freshness policy violated or requirement changed → STALE / re-evaluation required
```

The exact transition guards should be implemented centrally.

---

## 25. Decision Snapshot

An authoritative readiness decision should create a reproducible snapshot reference containing at least:

```text
Candidate identity
Role identity
Role blueprint version
Evaluation timestamp
Requirement results
Evidence references
Rule/configuration version
Final readiness state
Explanation/decision summary
```

This protects historical reports when current rules later change.

---

## 26. Recalculation and Idempotency

Readiness recalculation must be deterministic with respect to the same authoritative inputs and rule version.

Re-running the same calculation should not create contradictory domain state.

Where asynchronous recalculation is used, jobs should be idempotent and safe to retry.

A candidate's readiness should not oscillate because of unstable AI-generated scoring.

---

## 27. Batch and Cohort Readiness

Readiness can be aggregated from student-level evaluations.

Hierarchy:

```text
Student
   ↓
Batch
   ↓
Department
   ↓
College
```

And role alignment can be projected across the hierarchy:

```text
Industry Role
   ↓
College
   ↓
Department
   ↓
Batch
   ↓
Student
```

Useful derived metrics include:

```text
% READY for role
% PROVISIONALLY_READY
% TRAINABLE
Top MUST gaps
Average capability coverage
Practical evidence coverage
Training completion
Post-training improvement
```

These are reporting views derived from authoritative student/role decisions.

---

## 28. College Skill-Gap Planning

For a college, readiness should answer not only who is ready, but why the cohort is not ready.

Example:

```text
Target Role: Graduate Backend Engineer

Batch readiness: 42% READY

Top MUST gaps
1. REST API Testing
2. Spring Security
3. SQL Query Optimization

Training demand
→ API testing workshop
→ Security practical
→ SQL lab
```

This supports the closed-loop institutional planning model.

---

## 29. Industry Feedback Loop

Employer feedback can enrich future readiness evaluation.

Conceptually:

```text
Role Blueprint
    ↓
Assessment + Training
    ↓
Readiness
    ↓
Interview / Hiring
    ↓
Employer Feedback
    ↓
Outcome Analysis
    ↓
Role/Skill/Training Improvement
```

Employer feedback must not retroactively mutate a past readiness decision. It can contribute to future model/rule revisions under governance.

---

## 30. AI Role in Matching and Readiness

AI may assist with:

- Semantic similarity.
- JD/role text interpretation.
- Gap explanations.
- Suggested learning paths.
- Candidate-profile summarization.
- Role-to-skill normalization.

AI must not be the sole authority for:

- final hiring decisions,
- authoritative assessment scores,
- eligibility determinations with consequential policy effects,
- canonical proficiency assignment without governed evidence,
- final readiness state,
- silent override of MUST blockers.

Required pattern:

```text
Raw Input
   ↓
AI Assistance
   ↓
Structured Proposal
   ↓
Schema Validation
   ↓
Domain Validation
   ↓
Deterministic Business Rules
   ↓
Authoritative Result
```

---

## 31. Explainability Requirements

For a readiness or matching result, the user should be able to answer:

```text
What role was evaluated?
Which blueprint version was used?
Which requirements passed?
Which requirements failed?
Which evidence supported each decision?
What blockers remain?
What training is recommended?
When was the result calculated?
```

Explanations should be generated from structured decision data. AI may improve wording but should not invent unsupported reasons.

---

## 32. Security and Privacy

Readiness data can be sensitive because it describes an individual's evaluated capability.

Required controls include:

```text
Role-based access control
Organization/tenant isolation
Least-privilege data access
Audit logging for authoritative decisions
Controlled export
Protected evidence/document links
```

A college user should see only the student/readiness scope they are authorized to access. An industry user should not receive unrelated private student information merely because semantic matching is being performed.

---

## 33. Tenant and Scope Rules

Readiness and matching must enforce organization scope.

A candidate's data may be visible through a matching workflow only when the requesting principal and workflow are authorized.

Cross-tenant matching must be an explicit domain capability with explicit consent/visibility rules; it must not occur because two rows happen to share a role ID.

---

## 34. Performance Model

Typical readiness queries should be optimized around deterministic relational data.

Important access patterns:

```text
Candidate → current capability profile
Role → active requirements
Role + candidate → requirement evaluation
Batch + role → cohort readiness
Organization → top role gaps
```

PostgreSQL indexing should support these patterns.

Precomputed aggregates may be introduced when measured workload justifies them.

Do not introduce a separate search/vector system merely to support basic readiness evaluation.

---

## 35. Event and Async Model

Readiness recalculation may be asynchronous for workloads such as:

```text
Large cohort assessment import
Bulk evidence ingestion
Batch reassessment
Cohort readiness recalculation
Industry feedback processing
```

Initial implementation may use a PostgreSQL-backed job queue and Spring workers.

The business outcome should remain deterministic regardless of whether the calculation is executed synchronously or asynchronously.

---

## 36. Matching Workflow

Recommended production workflow:

```text
1. Select opportunity.
2. Resolve exact Role Blueprint version.
3. Determine candidate eligibility.
4. Load candidate capability/evidence profile.
5. Evaluate every active requirement.
6. Identify MUST blockers.
7. Calculate structured capability coverage.
8. Determine readiness class.
9. Produce explanation.
10. Persist decision snapshot where required.
11. Expose result to authorized workflow.
```

AI-assisted semantic retrieval can occur before or alongside step 4, but structured evaluation remains authoritative.

---

## 37. Candidate Ranking

For a pool of candidates, ranking should preserve hard blockers and make ranking criteria visible.

Example ordering:

```text
1. READY candidates
2. PROVISIONALLY_READY candidates
3. TRAINABLE candidates
4. LOW_MATCH candidates
5. INELIGIBLE candidates excluded from normal ranked pools
```

Within a class, structured fit metrics may rank candidates.

The product must avoid presenting a single unexplained number as though it were an objective measure of human potential.

---

## 38. Match Freshness

A match is a point-in-time comparison.

A candidate may become more or less suitable as:

```text
skills change
new evidence arrives
role blueprint changes
requirements change
eligibility changes
```

The platform should therefore distinguish:

```text
Current readiness
Historical readiness
Historical match
Current recomputed match
```

---

## 39. Decision Precedence

When signals conflict, the platform should follow an explicit precedence order.

Recommended baseline:

```text
1. Eligibility / hard policy constraints
2. MUST requirement blockers
3. Required proficiency thresholds
4. Required practical evidence
5. Evidence confidence/freshness
6. SHOULD requirements
7. COULD requirements
8. Soft contextual ranking signals
9. AI semantic similarity
```

This prevents semantic similarity from overriding domain requirements.

---

## 40. Example Evaluation

Illustrative example only:

```text
Role: Graduate Backend Engineer
Blueprint: v2

Requirements
- Java → Level 3 → MUST
- Spring Boot → Level 3 → MUST
- REST API Development → Level 3 → MUST
- SQL → Level 2 → MUST
- Testing → Level 2 → SHOULD

Candidate
- Java → Level 3 → verified assessment + project
- Spring Boot → Level 3 → project evidence
- REST API Development → Level 2 → project evidence
- SQL → Level 2 → assessment
- Testing → Level 2 → course + lab

Evaluation
- Java → PASS
- Spring Boot → PASS
- REST API Development → BLOCKER
- SQL → PASS
- Testing → PASS

Readiness
→ GAP_IDENTIFIED

Recommended intervention
→ REST API practical training + reassessment
```

The example demonstrates why a high aggregate score should not hide a MUST blocker.

---

## 41. Acceptance Criteria

### AC-01 — Role-Specific Readiness
**Given** a candidate and two different role blueprints,  
**when** readiness is calculated,  
**then** the result is maintained separately for each role/version.

### AC-02 — MUST Blocker
**Given** an unsatisfied MUST requirement,  
**when** readiness is calculated,  
**then** the candidate cannot become READY unless an explicit governed exception policy applies.

### AC-03 — Evidence Requirement
**Given** a role requirement that requires practical evidence,  
**when** the candidate has only course completion,  
**then** the requirement remains unsatisfied.

### AC-04 — Reassessment
**Given** a candidate in training,  
**when** training completion is recorded,  
**then** the system does not automatically mark the candidate READY when reassessment is required.

### AC-05 — Historical Reproducibility
**Given** a previous readiness decision,  
**when** the role blueprint is later updated,  
**then** the historical decision remains reproducible from its original blueprint version and decision snapshot.

### AC-06 — AI Boundary
**Given** an AI-generated match suggestion,  
**when** the structured requirement engine finds a MUST blocker,  
**then** the candidate is not promoted to READY solely because the AI similarity score is high.

### AC-07 — Explanation
**Given** a readiness result,  
**when** an authorized user opens the explanation,  
**then** the system shows the role/version, requirement outcomes, blockers and supporting evidence references.

### AC-08 — Tenant Isolation
**Given** two organizations,  
**when** one organization performs matching,  
**then** candidate evidence from another organization is not exposed unless an explicit authorized cross-organization workflow permits it.

---

## 42. Engineering Boundary

Keep the following concerns separate even inside the same modular monolith:

```text
Capability Service
Evidence Service
Readiness Evaluation Service
Readiness Policy
Matching Service
Ranking Service
Training Recommendation Service
Decision Snapshot Service
```

A readiness calculation may call capability/evidence repositories, but domain rules should remain centralized and testable.

Do not scatter readiness conditions across controllers, SQL fragments and UI code.

---

## 43. Testing Strategy

Critical tests should cover:

```text
Unit tests
- Requirement evaluation
- Gap calculation
- MUST blocking
- Evidence sufficiency
- Freshness policies
- State transitions
- Ranking precedence

Integration tests
- Role + candidate + evidence evaluation
- Historical snapshot reconstruction
- Tenant isolation
- Persistence transactions

End-to-end tests
- Assessment → gap → training → reassessment → READY
- Opportunity → matching → application
- College cohort readiness workflow
```

Property-based or table-driven testing is valuable for requirement combinations and edge cases.

---

## 44. Observability and Audit

Authoritative readiness changes should emit sufficient audit information to answer:

```text
Who initiated the evaluation?
What inputs were used?
What blueprint version was used?
What rule/configuration version was used?
What was the previous state?
What was the new state?
When did this happen?
```

Operational metrics may include:

```text
Readiness calculations
Calculation latency
Calculation failures
Reassessment completion
Ready-rate by role
Top blockers
Training-to-readiness conversion
Match-to-application conversion
```

These metrics are product/operational signals and must not replace individual decision records.

---

## 45. Future Extension: Time-to-Ready

Once sufficient historical data exists, Career360 can calculate **Time-to-Ready**:

```text
Start: GAP_IDENTIFIED
End: READY

Time-to-Ready = READY timestamp - gap identification timestamp
```

This becomes valuable for:

- student planning,
- college training efficiency,
- employer cohort planning,
- intervention effectiveness,
- training-provider comparison.

Time-to-Ready must be based on observed lifecycle timestamps rather than predictive estimates presented as historical fact.

---

## 46. Future Extension: Outcome Feedback

Readiness can eventually be evaluated against downstream outcomes:

```text
Readiness
   ↓
Application
   ↓
Interview
   ↓
Hire
   ↓
Employer Outcome
   ↓
Feedback
```

This supports future improvement of role blueprints, assessments and training recommendations.

Outcome feedback should inform future rules; it should not be used to rewrite historical truth.

---

## 47. Final Invariants

1. Readiness is role-specific.
2. Published role blueprint versions are immutable decision inputs.
3. MUST requirements are explicit blockers.
4. Course completion does not automatically prove practical competence.
5. Readiness must be grounded in authoritative evidence.
6. AI cannot be the sole authority for final readiness or hiring.
7. Matching and readiness are related but distinct concepts.
8. Historical decisions must remain reproducible.
9. Tenant and authorization checks apply to every readiness/matching access path.
10. State transitions are explicit and auditable.
11. Training completion does not bypass required reassessment.
12. Explanations are derived from structured decision data.
13. Universal PRI is not a substitute for role-specific readiness.
14. Deterministic business rules outrank semantic similarity when signals conflict.
15. Recalculation must be idempotent for the same authoritative inputs and policy version.

---

## 48. Final Definition

> **Career360 Readiness & Matching is an evidence-backed, role-specific decision capability that compares demonstrated candidate competencies against a versioned Role Blueprint, identifies blockers and development gaps, guides training and reassessment, and produces explainable readiness and fit results without delegating authoritative decisions to opaque AI.**
