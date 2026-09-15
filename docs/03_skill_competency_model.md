# Career360 — Skill & Competency Model

**Document:** `docs/03_skill_competency_model.md`  
**Status:** Product/Engineering Capability Taxonomy Baseline  
**Applies to:** Career360 skill, competency, proficiency, evidence and role-readiness capabilities  
**Primary owner:** Product + Domain Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`

---

## 1. Purpose

This document defines how Career360 represents, normalizes, evaluates and uses **skills** and **competencies**.

The model is foundational because the entire closed-loop product depends on a reliable capability vocabulary:

```text
Industry Requirement
        ↓
Canonical Skills / Competencies
        ↓
Assessment
        ↓
Evidence
        ↓
Capability Level
        ↓
Skill Gap
        ↓
Learning / Training
        ↓
Reassessment
        ↓
Role Readiness
```

The model must prevent a common failure mode in career systems: accumulating inconsistent skill names without a stable definition of what those skills mean, how they are measured, what evidence supports them and how they relate to a target role.

---

## 2. Core Principle

> **A skill is a capability concept, not a text tag.**

Career360 must therefore distinguish between:

- raw skill terminology;
- canonical skill identity;
- broader competencies;
- required proficiency;
- observed proficiency;
- evidence supporting an observation;
- role-specific importance;
- and readiness implications.

A student profile that merely says:

```text
Java, SQL, AWS, Communication
```

is not enough for the product's core promise.

Career360 must be able to answer:

```text
Which skill?
At what required level?
Observed at what level?
Measured how?
Supported by what evidence?
For which role?
Is it a MUST requirement?
Is the evidence fresh enough?
What should the student do next?
```

---

## 3. Definitions

### 3.1 Raw Skill Term

A string extracted from a source such as a resume, JD, course or assessment.

Examples:

```text
RESTful API
REST APIs
REST API Development
REST
```

These may refer to the same or related capability.

### 3.2 Skill

A canonical atomic capability represented by Career360.

Example:

```text
REST API
```

### 3.3 Competency

A broader capability that may contain multiple related skills.

Example:

```text
Backend API Development
```

### 3.4 Proficiency

A defined level representing the degree to which a capability is demonstrated.

### 3.5 Skill Observation

An observation of a learner's capability from an assessment or another accepted evaluation source.

### 3.6 Capability Claim

A structured claim that a learner demonstrates a skill or competency at a specific level, backed by evidence.

### 3.7 Skill Requirement

A role-specific target stating that a skill is required at a given proficiency and priority.

---

## 4. Why Career360 Needs Both Skills and Competencies

A flat skill list is useful for search but weak for capability reasoning.

For example:

```text
Java
Spring Boot
REST API
JPA
SQL
Testing
```

can be grouped under a broader capability such as:

```text
Backend Application Development
```

This gives Career360 two useful views:

```text
Atomic view
Skill-by-skill gap and evidence

Capability view
What broader work can this person perform?
```

Neither view should replace the other.

---

## 5. Skill Taxonomy Principles

### 5.1 Canonical identity

Each canonical skill has a stable identifier independent of display wording.

### 5.2 Human-readable definition

Every active canonical skill should have a concise definition describing what the capability means in Career360.

### 5.3 Alias support

Multiple source terms may map to one canonical skill.

### 5.4 Context awareness

A term may have different meanings in different contexts. Context must be preserved when necessary before canonicalization.

### 5.5 Version awareness

Skill definitions or taxonomy relationships that materially affect scoring should be versioned or historically traceable.

### 5.6 Deactivation over destructive deletion

Retired skills should normally be deactivated and retained for history.

---

## 6. Skill Categories

Career360 may classify skills into categories to improve reporting and reasoning.

A baseline taxonomy may include:

```text
TECHNICAL
DOMAIN
APTITUDE
SOFT_SKILL
TOOLS
PLATFORM
PROCESS
WORKPLACE
```

The category describes classification, not proficiency.

For example:

```text
Skill: SQL
Category: TECHNICAL
```

and:

```text
Skill: Communication
Category: SOFT_SKILL
```

The exact taxonomy can evolve while preserving stable skill IDs.

---

## 7. Technical Skill vs Tool Skill

Career360 should distinguish where useful between:

```text
Conceptual capability
```

and

```text
Specific technology/tool familiarity
```

Example:

```text
Competency: Relational Data Access
    ├── SQL
    ├── Query Optimization
    └── Transaction Concepts

Tool Skill:
    └── PostgreSQL
```

The same technology can be relevant to several competencies.

Do not assume that knowing the name of a tool automatically proves the broader capability.

---

## 8. Canonical Skill Entity

A conceptual `Skill` record should include at least:

```text
id
canonical_name
slug
category
short_definition
status
created_at
updated_at
```

Recommended metadata where needed:

```text
parent_skill_id
proficiency_scale_id
taxonomy_version
source/provenance
review_status
```

Not every field must exist on the first implementation, but the model must be able to support provenance and evolution.

---

## 9. Skill Alias Entity

A `SkillAlias` maps raw terminology to canonical skills.

Conceptual fields:

```text
id
raw_term
normalized_term
skill_id
context
source_type
confidence
review_status
```

Example:

```text
Raw term                 Canonical skill
------------------------------------------------
RESTful Services         REST API
REST APIs                REST API
REST endpoint development REST API
```

Aliases may be:

- manually curated;
- imported from trusted taxonomy sources;
- suggested by AI;
- inferred from approved usage.

AI-suggested aliases are not automatically authoritative.

---

## 10. Normalization Pipeline

The canonicalization flow should be:

```text
Raw Source
   ↓
Extract terms
   ↓
Normalize text
   ↓
Alias lookup
   ↓
Context analysis
   ↓
Candidate canonical skill
   ↓
Confidence / review policy
   ↓
Canonical Skill ID
```

For example:

```text
JD says:
"Experience developing RESTful APIs with Spring Boot"

Extraction:
RESTful APIs
Spring Boot

Normalization:
REST API
Spring Boot

Canonical mapping:
SKILL-REST-API
SKILL-SPRING-BOOT
```

The raw source should remain traceable where provenance matters.

---

## 11. Normalization Rules

Normalization must avoid both under-merging and over-merging.

### 11.1 Safe normalization

Usually safe examples:

```text
REST API
REST APIs
RESTful API
```

may map to a common canonical skill when domain review confirms equivalence.

### 11.2 Context-sensitive normalization

Terms such as:

```text
Java
Spring
Cloud
Analytics
Testing
```

may require context to determine the intended capability.

### 11.3 Do not blindly merge

The system must not treat related concepts as identical merely because semantic similarity is high.

Example:

```text
Data Analysis
Data Engineering
Data Science
```

may overlap but are not automatically one canonical skill.

---

## 12. Competency Model

A `Competency` represents a broader capability that may be decomposed into skills.

Example:

```text
Competency: Backend API Development

    HTTP
    REST API
    Authentication
    API Design
    Error Handling
    API Testing
```

The competency definition should capture:

- name
- description
- status
- taxonomy version
- constituent skills
- optional skill weights/importance
- optional proficiency derivation policy

---

## 13. Competency Composition

Competencies may use one of two relationships:

```text
Competency → Skill
```

or, in advanced cases:

```text
Competency → Competency → Skill
```

The initial implementation should avoid unnecessary deep hierarchy.

The common P0 pattern should be:

```text
Competency
   └── Skills
```

This is easier to reason about for assessment, gap and reporting use cases.

---

## 14. Competency Example

```text
Competency: Backend API Development

Skill                     Target importance
------------------------------------------------
HTTP                      Essential
REST API                  Essential
Authentication            High
API Design                High
Error Handling            Medium
API Testing               High
```

The exact values may be expressed through weights or structured role requirements depending on the consuming policy.

---

## 15. Skill-to-Competency Mapping

A mapping record should support:

```text
competency_id
skill_id
relationship_type
importance/weight
minimum_expected_level (optional)
version
```

A skill can belong to several competencies.

Example:

```text
SQL
 ├── Backend Data Access
 ├── Data Analysis
 └── Data Engineering
```

This means a skill's importance is contextual rather than globally fixed.

---

## 16. Proficiency Model

Career360 needs a consistent proficiency vocabulary so requirements and observations can be compared.

A practical baseline is a five-level scale:

```text
1 — FOUNDATIONAL
2 — DEVELOPING
3 — PROFICIENT
4 — ADVANCED
5 — EXPERT
```

The labels are intentionally generic because the evidence needed to demonstrate each level can differ by skill.

A future scale can be introduced through an explicit taxonomy/policy version rather than changing historical results in place.

---

## 17. Meaning of Proficiency Levels

### Level 1 — Foundational

Understands basic concepts and can perform guided/simple tasks.

### Level 2 — Developing

Can perform common tasks with limited guidance but may need support for unfamiliar problems.

### Level 3 — Proficient

Can independently perform expected role-level tasks for the capability within normal scope.

### Level 4 — Advanced

Can handle complex scenarios, diagnose problems and make sound implementation decisions.

### Level 5 — Expert

Can lead, design, evaluate or teach the capability at a high level and handle highly complex situations.

These definitions are default conceptual meanings, not automatic evidence rules.

---

## 18. Proficiency Is Contextual

A Level 3 in SQL does not necessarily mean Level 3 in data engineering.

Therefore:

```text
Observed Skill Proficiency
```

must not be blindly converted into:

```text
Competency Proficiency
```

A competency-level conclusion requires an explicit derivation rule or direct evidence.

---

## 19. Skill Requirement Model

A role uses `SkillRequirement` to state what is expected.

Conceptual structure:

```text
Role Blueprint Version
       │
       └── Skill Requirement
             ├── Skill
             ├── Target proficiency
             ├── Priority
             ├── Weight (optional)
             ├── Blocking policy
             └── Evidence condition
```

Example:

```text
Graduate Backend Engineer

Java        target 3   MUST
SQL         target 3   MUST
REST API    target 3   MUST
Testing     target 2   SHOULD
Cloud       target 2   SHOULD
```

---

## 20. Competency Requirement Model

A role may also require a competency directly.

Example:

```text
Backend API Development
Target proficiency: 3
Priority: MUST
```

When a competency is required, the readiness policy must define how the requirement is evaluated.

Possible strategies include:

```text
All required constituent skills must satisfy minimum levels
```

or

```text
Weighted competency derivation
```

The strategy must be explicit and versioned when it affects readiness.

---

## 21. MUST / SHOULD / COULD / WON'T

Career360 uses MoSCoW as a requirement-priority framework.

```text
MUST   = critical requirement
SHOULD = important requirement
COULD  = useful but non-critical
WONT   = explicitly excluded from current scope
```

Priority is not the same as proficiency.

For example:

```text
SQL
Target level: 3
Priority: MUST
```

means both:

- the target capability level is 3;
- and failure to meet it can block readiness under the role policy.

---

## 22. Evidence Model for Skills

A skill observation should always have a source.

Examples:

```text
Assessment Attempt
Practical Lab
Project Review
Simulation
Certification
Course Completion
Internship Evaluation
Mentor Evaluation
Faculty Evaluation
Employer Evaluation
Interview
```

Evidence should answer:

```text
What skill was evaluated?
At what level?
When?
By whom/what?
Using which method?
Against what rubric/policy?
With what confidence?
```

---

## 23. Evidence Strength

Not every evidence source has the same capability strength.

A role may define different evidence expectations.

For example:

```text
Course completion
    → demonstrates participation/completion

Certificate with assessment
    → stronger knowledge evidence

Practical project
    → stronger applied-capability evidence

Employer evaluation
    → real-world contextual evidence
```

Career360 should not hard-code one universal ranking for every use case.

Evidence strength is contextual and may be represented through a policy.

---

## 24. Capability Claim Model

The system may materialize a `CapabilityClaim` from one or more evidence records.

Example:

```text
Student: S123
Skill: REST API
Observed level: 3
Evidence:
  - practical project P901
  - assessment A455
  - mentor evaluation M31
Observed at: 2026-09-10
Confidence: HIGH
```

The claim is then used by readiness evaluation.

---

## 25. Evidence Freshness

Technical skills may change in relevance over time.

Career360 should support freshness metadata rather than pretending all evidence remains equally current forever.

A freshness model may include:

```text
observed_at
valid_from
valid_until (optional)
freshness_policy
freshness_state
```

A role policy may define that recent evidence is preferred for fast-changing capabilities.

---

## 26. Skill Gap Model

The core skill gap is the difference between required and demonstrated capability.

Conceptually:

```text
Required level - Observed level = Gap
```

Example:

```text
SQL
Required = 3
Observed = 2
Gap = 1
```

A gap can also include evidence insufficiency.

Example:

```text
Observed knowledge = 3
Practical evidence = missing
Result:
Capability knowledge satisfied
Practical readiness requirement unsatisfied
```

Therefore the gap model must not be reduced to arithmetic alone.

---

## 27. Gap Types

A useful classification is:

```text
NO_EVIDENCE
SKILL_GAP
PROFICIENCY_GAP
PRACTICAL_EVIDENCE_GAP
FRESHNESS_GAP
ELIGIBILITY_GAP
```

This allows training recommendations to target the real cause.

---

## 28. Gap Severity

Severity may be derived from:

- requirement priority;
- proficiency difference;
- evidence requirements;
- readiness policy.

A conceptual scale:

```text
BLOCKING
HIGH
MEDIUM
LOW
```

`BLOCKING` commonly corresponds to an unmet MUST requirement.

Exact thresholds should be policy-driven.

---

## 29. Student Skill Profile

The student skill profile should be a projection of validated capability observations and claims.

It should not be a manually editable list of authoritative scores.

Student-facing profile can show:

```text
Skill
Current level
Evidence
Last evaluated
Target role(s)
Target level
Gap
Recommended next action
```

Students may add self-declared interests or goals, but those must be visibly distinguished from validated capability.

---

## 30. Self-Declared vs Verified Skills

The model should distinguish:

```text
SELF_DECLARED
ASSESSED
EVIDENCE_VERIFIED
EMPLOYER_VERIFIED
```

A user saying:

```text
"I know Docker"
```

is not equivalent to:

```text
Practical project evidence demonstrates containerization capability
```

The product UI must avoid presenting both with identical visual authority.

---

## 31. Skill Provenance

Every authoritative observation or taxonomy mapping should retain provenance as appropriate.

Examples:

```text
SOURCE = assessment_attempt
SOURCE = project_review
SOURCE = employer_feedback
SOURCE = certification
SOURCE = manual_admin_mapping
SOURCE = ai_proposal
SOURCE = imported_jd
```

AI provenance is especially important because it indicates a proposal origin rather than an authoritative evaluation source.

---

## 32. AI-assisted Skill Extraction

AI can assist with extracting skills from:

- job descriptions
- resumes
- project descriptions
- course metadata
- employer feedback

The workflow should be:

```text
Raw Text
   ↓
AI Extraction
   ↓
Structured Skill Candidates
   ↓
Canonicalization
   ↓
Validation / Review
   ↓
Accepted Canonical Skills
```

The AI model must not be allowed to invent a new canonical skill silently without taxonomy governance.

---

## 33. Skill Taxonomy Governance

The taxonomy requires controlled governance.

A new skill should generally have:

```text
Name
Definition
Category
Aliases
Context
Owner/reviewer
Status
Created source
```

Possible lifecycle:

```text
PROPOSED
UNDER_REVIEW
ACTIVE
DEPRECATED
RETIRED
```

An alias can be introduced before a new canonical skill is needed.

---

## 34. Duplicate Skill Prevention

Before creating a new canonical skill, the system should check:

```text
Exact name
Normalized name
Known aliases
Potential semantic duplicates
Parent/related skills
```

Semantic similarity is a candidate-generation mechanism, not final authority.

Human/domain review or deterministic taxonomy policy should resolve ambiguous duplicates.

---

## 35. Relationship Types

Skill relationships can be modeled using explicit relation types such as:

```text
ALIAS_OF
RELATED_TO
PREREQUISITE_OF
SUBSKILL_OF
COMPLEMENTARY_TO
```

Only relationships required by product behavior should be implemented in P0.

Do not build a complex ontology simply because graph-like data is theoretically possible.

---

## 36. Prerequisite Skills

Some capabilities may have logical prerequisites.

Example:

```text
REST API Testing
   ↓
REST API
   ↓
HTTP
```

However, prerequisite relationships must not automatically imply proficiency levels unless a defined policy says so.

Knowing HTTP at Level 3 does not automatically grant REST API Level 3.

---

## 37. Skill Weighting

Weights are contextual.

A skill may be:

```text
Critical in Role A
Useful in Role B
Irrelevant in Role C
```

Therefore weight should generally be attached to a role requirement or competency mapping rather than treated as a universal property of the skill.

---

## 38. Competency Derivation

Career360 may derive a competency score from skills where useful, but the formula must be explicit.

Possible approach:

```text
Competency score = weighted combination of constituent skill levels
```

Example:

```text
Backend API Development
  HTTP              20%
  REST API          25%
  Authentication    15%
  API Design        15%
  Error Handling    10%
  API Testing       15%
```

This is only a conceptual example. Actual weighting must be defined per competency/policy and versioned when used authoritatively.

---

## 39. Blocking Competency Requirements

When a competency is a MUST requirement, a single average may be misleading.

For example:

```text
HTTP             5
REST API         1
Authentication   1
API Testing      5
```

An average could look acceptable while the role-critical parts remain weak.

Therefore a competency readiness rule may require:

```text
minimum level on critical constituent skills
AND
minimum competency-derived score
```

The exact rule must be explicit.

---

## 40. Role Skill Matrix

Career360 should support a role-specific matrix.

Example:

| Skill | Required | Target | Priority | Evidence requirement |
|---|---:|---:|---|---|
| Java | Yes | 3 | MUST | Assessment + project |
| SQL | Yes | 3 | MUST | Assessment |
| REST API | Yes | 3 | MUST | Practical project |
| Testing | Yes | 2 | SHOULD | Assessment/lab |
| Cloud | Yes | 2 | SHOULD | Course/project |

This becomes a key input to readiness and matching.

---

## 41. Student Capability Matrix

For a student, the corresponding view is:

| Skill | Required | Current | Gap | Evidence | Status |
|---|---:|---:|---:|---|---|
| Java | 3 | 3 | 0 | Strong | Met |
| SQL | 3 | 2 | 1 | Assessment | Gap |
| REST API | 3 | 1 | 2 | Project missing | Blocking |
| Testing | 2 | 2 | 0 | Lab | Met |
| Cloud | 2 | 1 | 1 | Course | Gap |

This is more actionable than a single readiness percentage.

---

## 42. Cohort Skill Matrix

College users need aggregated capability analysis.

The platform should support:

```text
Student
    ↓ aggregate
Batch
    ↓ aggregate
Department
    ↓ aggregate
College
```

For each scope, the system can show:

- skill coverage
- median/current level
- gap prevalence
- blocking gap count
- practical evidence coverage
- improvement after training

The source research explicitly uses this hierarchy for skill-gap reporting.

---

## 43. At-Risk Analysis

At-risk status can be derived from skill and readiness indicators.

Possible signals include:

- multiple blocking gaps;
- low readiness;
- poor assessment trend;
- missed reassessment;
- low learning completion;
- insufficient practical evidence.

At-risk rules must be explicit, configurable and auditable.

They should not be created solely from an opaque AI score.

---

## 44. Improvement Velocity

The source research includes **Improvement Velocity** as an institutional metric.

A conceptual formulation is:

```text
Improvement Velocity = capability improvement / elapsed time
```

Exact calculation should be defined at implementation time.

It must use comparable measurement versions and avoid comparing incompatible assessment instruments without normalization.

---

## 45. Skill Gap Score

The source research defines a benchmark comparison concept:

```text
Skill Gap Score = (Student Score / Benchmark) × 100
```

This can be used as a reporting metric, but the model should distinguish:

```text
benchmark metric
```

from

```text
role requirement satisfaction
```

A student can have a good benchmark score while failing a role-specific MUST requirement.

---

## 46. Learning Recommendation Mapping

Learning should connect to gaps.

A recommendation can use:

```text
Gap skill
   ↓
Learning item mapping
   ↓
Expected improvement
   ↓
Practical activity
   ↓
Reassessment
```

Example:

```text
Gap: REST API Level 1 → target 3

Recommend:
1. REST API fundamentals
2. Spring Boot API lab
3. Authentication exercise
4. Practical backend project
5. Reassessment
```

A recommendation should state why it is relevant rather than simply matching text keywords.

---

## 47. Course Completion vs Skill Improvement

The model must preserve two distinct facts:

```text
Learning Completion
```

and

```text
Capability Improvement
```

A learner can complete a course without demonstrating improvement.

The strongest closed-loop evidence is:

```text
Baseline measurement
   ↓
Training
   ↓
Practical evidence
   ↓
Reassessment
   ↓
Observed improvement
```

---

## 48. Practical Evidence Mapping

A skill can require practical evidence when the role depends on applied capability.

Example:

```text
Skill: REST API
Required level: 3
Priority: MUST
Evidence:
  Practical project required
```

The readiness engine should evaluate both:

```text
Proficiency
AND
Evidence condition
```

---

## 49. Freshness-aware Capability

A capability claim should be treated as a time-stamped observation.

Example:

```text
Java Level 3
Observed: Jan 2026
```

and

```text
Java Level 3
Observed: Sep 2026
```

may have different relevance depending on role and policy.

The model therefore supports:

```text
Current capability
Historical capability
Evidence freshness
```

without rewriting history.

---

## 50. Capability History

Career360 should preserve capability progression:

```text
Jan → SQL Level 1
Mar → SQL Level 2
Jun → SQL Level 3
```

This enables:

- progress visualization;
- training effectiveness;
- improvement velocity;
- readiness transitions;
- evidence auditability.

Historical observations must not be overwritten by newer values.

---

## 51. Role-specific Capability

A skill's importance and target level are always interpreted in context.

Example:

```text
Data Analyst
  SQL = MUST / Level 3

Frontend Developer
  SQL = COULD / Level 1
```

This prevents Career360 from producing the misleading claim that a student is globally “good” or “bad” at a skill without knowing the target role.

---

## 52. Skill Profile Projection

The student-facing skill profile is a projection that may combine:

```text
Latest valid observations
Accepted capability claims
Evidence summaries
Role targets
Self-declared interests
```

It must visually distinguish:

```text
Self-declared
Assessed
Evidence-verified
Employer-verified
```

The projection can be cached but must be reconstructable from source data.

---

## 53. Matching Use of Skill Model

Matching should use skills as structured factors.

A simplified conceptual calculation may consider:

```text
Eligibility
+ MUST requirement satisfaction
+ proficiency fit
+ evidence sufficiency
+ readiness
+ semantic relevance
```

A semantic similarity score should not hide failed deterministic requirements.

---

## 54. Assessment Mapping

Assessment questions/items should map to one or more skills.

Example:

```text
Question Q1
   → SQL
Question Q2
   → SQL
Question Q3
   → Query Optimization
```

Where questions assess a competency indirectly, the mapping policy must specify how skill observations are derived.

The system should retain enough mapping information to explain how a per-skill score was produced.

---

## 55. Assessment → Skill Observation Pipeline

```text
Assessment Definition
        ↓
Assessment Version
        ↓
Attempt
        ↓
Responses
        ↓
Scoring
        ↓
Question-to-skill mapping
        ↓
Skill observations
        ↓
Evidence
        ↓
Capability claim
```

This pipeline is central to trustworthy skill mapping.

---

## 56. External Certification Mapping

A certification may map to one or more skills.

However:

```text
Certification
   ≠
Automatic mastery
```

The mapping can support:

- skill association;
- supporting evidence;
- recommendation relevance;
- profile enrichment.

Where the role requires practical proficiency, additional evidence may still be necessary.

---

## 57. Project Evidence Mapping

Projects can be one of the strongest evidence sources when properly structured.

A project record may specify:

```text
Project
 ├── problem
 ├── tasks performed
 ├── technologies
 ├── skills demonstrated
 ├── artifacts
 ├── reviewer/evaluator
 └── evaluation result
```

The important distinction is between:

```text
Technology mentioned
```

and

```text
Capability demonstrated through evaluated work
```

---

## 58. Employer Feedback Mapping

Employer feedback can produce skill observations when structured and authorized.

Example:

```text
Employer evaluation
  → API design: Level 3
  → debugging: Level 2
  → communication: Level 4
```

Employer feedback should not silently overwrite assessment history. It becomes another evidence source.

---

## 59. Skill Source Confidence

Some skill mappings are more reliable than others.

Potential confidence classes:

```text
HIGH
MEDIUM
LOW
```

Confidence can apply to:

- extraction;
- normalization;
- evidence;
- evaluation.

Confidence must not be confused with proficiency.

Example:

```text
Skill mapping confidence = HIGH
Observed proficiency = 2
```

These are different dimensions.

---

## 60. Canonicalization Confidence vs Evidence Confidence

Keep these separate.

```text
Canonicalization confidence
= "Did we correctly map this raw term to the canonical skill?"

Evidence confidence
= "How strongly does this evidence support the capability claim?"
```

A high-confidence mapping does not mean high competence.

---

## 61. Recommended Data Objects

The initial domain model should support concepts equivalent to:

```text
Skill
SkillAlias
SkillRelationship
SkillTaxonomyVersion
Competency
CompetencySkillMapping
ProficiencyScale
ProficiencyLevel
RoleSkillRequirement
RoleCompetencyRequirement
SkillObservation
CapabilityClaim
Evidence
EvidenceSkillMapping
```

The exact table structure may be normalized differently, but these concepts should not be collapsed merely to reduce table count.

---

## 62. Recommended Policy Objects

Where behavior is configurable or role-specific, use explicit policy concepts such as:

```text
ProficiencyPolicy
CompetencyDerivationPolicy
EvidencePolicy
FreshnessPolicy
ReadinessPolicy
MatchingPolicy
```

These policies should be versioned when they affect historical results.

---

## 63. Skill Lifecycle

A canonical skill lifecycle may be:

```text
PROPOSED
   ↓
UNDER_REVIEW
   ↓
ACTIVE
   ↓
DEPRECATED
   ↓
RETIRED
```

A retired skill remains available for historical references but should generally not be used for new requirements unless explicitly allowed.

---

## 64. Competency Lifecycle

Competencies may follow the same basic lifecycle:

```text
PROPOSED
UNDER_REVIEW
ACTIVE
DEPRECATED
RETIRED
```

Changes in constituent skill composition should be versioned when they could alter readiness interpretation.

---

## 65. Taxonomy Versioning

Career360 should support taxonomy versions conceptually:

```text
Taxonomy v1
   ├── Skill IDs
   ├── aliases
   ├── competency mappings
   └── definitions

Taxonomy v2
   ├── additions
   ├── revised definitions
   └── changed mappings
```

Historical evidence and readiness calculations should remain linked to the relevant taxonomy/policy context when necessary.

---

## 66. Merge and Split Rules

Skill taxonomy evolution may require:

```text
Skill Merge
A + B → C

Skill Split
A → B + C
```

These operations must preserve historical references.

Existing observations should not silently change their meaning.

Migration mappings should be explicit.

---

## 67. Role Blueprint Integration

The skill/competency model becomes useful when a role references it.

Example:

```text
Role: Graduate Backend Engineer
Blueprint v3

Competency:
  Backend API Development — MUST, Level 3

Skills:
  Java — MUST, Level 3
  SQL — MUST, Level 3
  REST API — MUST, Level 3
  Testing — SHOULD, Level 2
```

The Role Blueprint does not redefine what “SQL” means; it references the canonical skill.

---

## 68. College Skill Mapping Use Case

College users need to see:

```text
Role Demand
    ↓
Required Skills
    ↓
Batch Capability
    ↓
Gap Distribution
    ↓
Priority Gaps
    ↓
Training Plan
```

Example:

```text
Role: Graduate Backend Engineer
Batch: CSE 2027

Top gaps:
1. REST API
2. Testing
3. SQL
```

This supports targeted training rather than generic course allocation.

---

## 69. Company Use Case

Companies can use the model to define:

```text
Role
 → required competencies
 → required skills
 → target proficiency
 → evidence requirements
 → readiness conditions
```

Then candidate comparison becomes capability-based rather than resume-keyword-only.

---

## 70. Student Use Case

Students can use the model to answer:

```text
Target Role
   ↓
Required Skills
   ↓
My Current Capability
   ↓
Evidence
   ↓
Gap
   ↓
Next Action
   ↓
Reassessment
   ↓
Readiness
```

The skill page therefore becomes a decision-support surface rather than a static profile list.

---

## 71. Skill Dashboard Requirements

A meaningful skill dashboard should expose, where authorized:

- current proficiency;
- target proficiency;
- gap;
- evidence count/type;
- last evaluated date;
- confidence/freshness indicators;
- role relevance;
- recommended next action.

Avoid dashboards where a skill is shown only as an unlabeled progress bar.

---

## 72. Readiness Inputs from the Skill Model

The readiness engine consumes:

```text
Role requirements
       +
Current capability observations/claims
       +
Evidence conditions
       +
Freshness/confidence
       +
Eligibility
       ↓
Role Readiness
```

A skill model is therefore one of the most important inputs to the product's central readiness decision.

---

## 73. No Global Skill Score

Do not store a universal authoritative field such as:

```text
student.sql_score = 82
```

without defining:

```text
assessment source
version
scale
timestamp
role context where applicable
evidence
```

A score without context is not a reliable capability fact.

---

## 74. No AI-only Skill Scoring

AI may estimate or infer skill relevance from text, but authoritative proficiency should come from approved evaluation/evidence processes.

Allowed:

```text
Resume text → candidate skill list
JD → skill candidates
Project description → evidence candidates
```

Not sufficient by itself:

```text
LLM says candidate is Level 4 in Java
```

The authoritative model must be grounded in evidence.

---

## 75. Data Quality Rules

Canonical skill data should enforce:

- non-empty name;
- stable identifier;
- definition for active skills;
- unique canonical identity;
- valid category;
- valid lifecycle state;
- no circular unsupported hierarchy;
- valid competency mappings;
- historical references preserved.

Aliases should not create accidental canonical duplicates.

---

## 76. API Representation Guidance

When APIs expose skills, prefer structured objects over plain strings.

Example conceptual response:

```json
{
  "skillId": "skill-rest-api",
  "name": "REST API",
  "category": "TECHNICAL",
  "currentLevel": 2,
  "targetLevel": 3,
  "gap": 1,
  "evidence": {
    "count": 2,
    "lastEvaluatedAt": "2026-09-10"
  }
}
```

The actual contract should follow the API standards in the architecture document.

---

## 77. Reporting Representation

Reports may aggregate skills at multiple scopes:

```text
Student
Batch
Department
College
Company
Role
```

Common derived metrics include:

```text
coverage
median proficiency
gap prevalence
blocking-gap prevalence
evidence coverage
improvement over time
```

Metrics must document whether they use:

- all observations;
- latest valid observation;
- role-specific observation;
- or a historical snapshot.

---

## 78. Snapshot Principle

Institutional dashboards may use periodic snapshots so that historical reporting remains stable.

Example:

```text
PRI Snapshot — 2026-09-01
```

The snapshot should record the calculation context sufficiently to explain later differences from live state.

---

## 79. Search Index Representation

PostgreSQL FTS, pg_trgm and vector embeddings may index skills and related objects.

The index should contain derived searchable representations such as:

```text
canonical name
aliases
definition
related terms
embedding
```

The canonical skill table remains authoritative.

---

## 80. Vector Similarity Guidance

Vector similarity can support:

- JD-to-skill candidate discovery;
- raw-term normalization suggestions;
- related-skill discovery;
- learning recommendation ranking;
- semantic opportunity matching.

It must not be treated as an authoritative taxonomy mapping without deterministic or reviewed acceptance.

---

## 81. Relationship to Learning Engine

Learning items should map to capabilities.

Example:

```text
Learning Item: Spring Boot REST API Lab
      ↓ addresses
Skill: REST API
Skill: Spring Boot
Competency: Backend API Development
```

This enables traceable recommendations.

A learning catalog entry that has no capability linkage may still be discoverable, but it is weaker for gap-driven planning.

---

## 82. Relationship to Training Programs

Training programs should specify target capabilities.

Example:

```text
Training Program:
Graduate Backend Engineer Readiness — Batch CSE 2027

Target competencies:
Backend API Development

Target skills:
REST API
Testing
SQL
```

The system can then evaluate whether training actually changed those target capabilities.

---

## 83. Relationship to Reassessment

Reassessment must compare like with like where possible.

A baseline and follow-up result should identify:

```text
skill
assessment/policy version
baseline observation
follow-up observation
elapsed time
intervention(s)
```

Improvement claims must not compare incompatible scales without normalization.

---

## 84. Relationship to Employer Outcomes

The long-term value of the skill model is validated by outcomes.

Possible loop:

```text
Skill requirement
   ↓
Assessment
   ↓
Training
   ↓
Reassessment
   ↓
Readiness
   ↓
Hiring
   ↓
Employer feedback
   ↓
Compare expected vs observed capability
```

This can later improve role blueprints and training intelligence.

---

## 85. Governance of Employer-Derived Skills

Employer feedback may suggest new or changed skills, but employer data should enter the taxonomy through the same governance process.

```text
Employer signal
   ↓
Skill candidate
   ↓
Normalization
   ↓
Taxonomy review
   ↓
Canonical skill
```

No single employer should silently redefine the global taxonomy.

---

## 86. Governance of College-Derived Skills

Colleges may have local curriculum terminology.

Local terms can be mapped to global canonical skills where applicable.

Example:

```text
Local course label: Web Services
Canonical skill: REST API
```

The local label can remain as source metadata while capability comparisons use the canonical identity.

---

## 87. Governance of Student-Declared Skills

Students should be able to express interests and self-declared skills without contaminating authoritative capability data.

A good representation is:

```text
Interest
Self-declared
Assessed
Evidence-verified
Employer-verified
```

These labels help the student understand the difference between intent and demonstrated readiness.

---

## 88. Skill Confidence Presentation

Do not expose internal confidence values as if they were mathematical truth.

Instead use understandable product language such as:

```text
Verified through assessment
Supported by project evidence
Self-declared
Recently evaluated
Evaluation may be outdated
```

The underlying model can retain precise confidence metadata.

---

## 89. Security and Privacy Considerations

Skill and evidence data can be sensitive.

Access must respect:

- student privacy settings;
- college authorization scope;
- company candidate-access rules;
- document/evidence access policies;
- audit requirements.

A company should not automatically see every student skill observation merely because the student exists in Career360.

---

## 90. Performance Considerations

The model should support efficient queries for:

```text
student → skills
role → requirements
role + student → gap
batch → aggregate skill coverage
opportunity → eligible/ready candidates
skill → learning recommendations
```

Common read models can be materialized/cached when justified.

Authoritative data remains in PostgreSQL.

---

## 91. Testing Requirements

The skill/competency model requires tests for:

### Unit tests

- normalization rules;
- alias resolution;
- proficiency comparisons;
- gap calculations;
- competency derivation;
- evidence policy evaluation.

### Integration tests

- persistence constraints;
- version references;
- cross-module capability flows;
- tenant isolation.

### Contract tests

- skill API representations;
- readiness responses;
- learning recommendation contracts.

### UI/browser tests

- role-to-skill matrix;
- gap visualization;
- evidence labeling;
- self-declared vs verified distinction.

---

## 92. Skill/Competency Invariants

The following are mandatory:

1. A canonical skill has a stable identity.
2. Raw aliases do not automatically create duplicate canonical skills.
3. Competencies are broader than atomic skills.
4. Skill importance is contextual.
5. Proficiency requires a defined scale.
6. Authoritative observations retain source/provenance.
7. Capability claims are evidence-backed.
8. Self-declared skills are distinct from verified skills.
9. Evidence confidence is distinct from proficiency.
10. Canonicalization confidence is distinct from evidence confidence.
11. Course completion is not universal proof of mastery.
12. Role requirements reference canonical skills/competencies.
13. Historical observations are not overwritten.
14. Taxonomy evolution preserves historical meaning.
15. AI may propose mappings but cannot silently create authoritative capability facts.

---

## 93. Initial P0 Scope

The first production implementation should prioritize:

```text
Canonical Skill
Skill Alias
Competency
Competency ↔ Skill mapping
Proficiency scale
Role skill requirement
Skill observation
Evidence mapping
Skill gap calculation
Student skill profile
Cohort skill aggregation
Learning-to-skill mapping
```

Advanced ontology features should wait until there is a demonstrated product need.

---

## 94. P1 Expansion

P1 can introduce:

```text
Advanced normalization
JD ingestion
Semantic skill matching
Skill trend analysis
Employer-derived signals
Evidence freshness policies
Advanced competency derivation
Employer feedback skill observations
Time-to-Ready analytics
```

---

## 95. P2 Expansion

P2 can introduce:

```text
Cross-institution skill benchmarking
Advanced workforce competency models
Industry-specific taxonomies
Predictive skill demand
Skill graph analytics
Advanced career pathway inference
```

These should build on the same canonical skill identity and evidence model.

---

## 96. Final Skill & Competency Statement

Career360's skill model is not a list of keywords.

It is a structured capability system:

```text
Raw Term
   ↓
Canonical Skill
   ↓
Competency
   ↓
Role Requirement
   ↓
Observed Capability
   ↓
Evidence
   ↓
Gap
   ↓
Learning / Training
   ↓
Reassessment
   ↓
Readiness
   ↓
Outcome
```

The model is successful when a skill mentioned by an employer can be normalized to a stable capability, measured through credible evidence, compared against a role requirement, connected to a targeted intervention and verified again before readiness is claimed.
