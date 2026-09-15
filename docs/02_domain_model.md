# Career360 — Domain Model

**Document:** `docs/02_domain_model.md`  
**Status:** Product/Engineering Domain Baseline  
**Applies to:** Career360 platform and all implementation milestones  
**Primary owner:** Engineering + Product  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`

---

## 1. Purpose

This document defines the business-domain model for Career360.

It identifies the principal entities, value objects, aggregates, relationships, ownership boundaries, lifecycle states and cross-domain flows required to implement the product without losing its core meaning.

The domain model is intentionally aligned to the product thesis:

> **Don't just tell students what to learn. Prove when they're ready.**

The domain therefore treats **Role Blueprint, Skills, Competencies, Evidence and Role Readiness** as first-class concepts rather than secondary metadata around a job portal or learning platform.

This document is a conceptual and implementation-guiding model. Exact table names, package names and API DTO names may evolve during implementation, but the business meaning and invariants defined here must remain stable unless an explicit architecture/product decision changes them.

---

## 2. Domain North Star

Career360 connects three primary actors:

```text
Student                College                    Company
   │                      │                          │
   │ capability           │ cohort capability        │ role demand
   ▼                      ▼                          ▼
Skills / Competencies / Evidence / Readiness / Role Blueprint
                     │
                     ▼
             Learning + Training
                     │
                     ▼
              Reassessment
                     │
                     ▼
                Opportunity
                     │
                     ▼
               Application
                     │
                     ▼
                 Outcome
                     │
                     ▼
             Employer Feedback
                     │
                     └──────────────► Industry Intelligence
```

The model must support both directions:

```text
Industry → Academia
Role requirements → skills → gaps → training → readiness

Academia → Industry
Capability → evidence → readiness → candidate matching → outcome → feedback
```

---

## 3. Domain Map

The initial domain map is:

```text
Identity & Access
        │
        ├──────────────► Organizations
        │                     │
        │                     ├── Colleges
        │                     └── Companies
        │
        ├──────────────► Students / Staff
        │
        ▼
Skills ───────────► Competencies ───────────► Roles
   │                       │                    │
   │                       │                    ├── Role Blueprint
   │                       │                    └── Requirements
   │                       │
   ▼                       ▼                    ▼
Assessments ───────────► Evidence ◄──────── Learning / Training
        │                    │                    │
        └────────────────────┴──────────────┐     │
                                            ▼     │
                                         Readiness
                                            │
                                            ▼
                                         Matching
                                            │
                                            ▼
                                       Opportunities
                                            │
                                            ▼
                                        Applications
                                            │
                                            ▼
                                         Outcomes
                                            │
                                            ▼
                                     Industry Feedback
```

Reporting, Notifications, Documents, Billing and Audit support the core domain rather than redefine it.

---

## 4. Core Domain Concepts

The core concepts are:

| Concept | Meaning | Domain importance |
|---|---|---|
| User | A human identity using Career360 | Supporting/core |
| Membership | User's relationship to an organization and role/scope | Core infrastructure |
| Organization | A tenant/organizational boundary | Core infrastructure |
| College | Academic institution context | Core |
| Company | Industry/employer context | Core |
| Student Profile | Student-specific career and capability context | Core |
| Role | Conceptual job/work role | Core |
| Role Blueprint | Versioned structured definition of a role and its capability requirements | **Central** |
| Skill | Atomic capability | **Central** |
| Competency | Broader capability composed of related skills | **Central** |
| Assessment | A defined measurement instrument | Core |
| Assessment Attempt | One execution of an assessment | Core |
| Evidence | Proof supporting a capability claim | **Central** |
| Readiness | Role-specific capability determination | **Central** |
| Learning Item | Reusable learning content | Core |
| Learning Path | Ordered/grouped learning sequence | Core |
| Training Program | Gap-driven intervention for a role/cohort/group | Core |
| Opportunity | Job/internship opening | Core |
| Match | Deterministic/semantic candidate-role fit result | Core |
| Application | Student/candidate application lifecycle | Core |
| Outcome | Result of training, application, internship or hiring | Core |
| Industry Signal | Normalized external/internal demand evidence | P1 core |
| Employer Feedback | Post-outcome capability/work-readiness feedback | P1 core |

---

## 5. Identity and Access Domain

### 5.1 User

`User` represents an authenticated human identity.

Conceptual attributes:

- `id`
- display name
- email/phone identity as applicable
- authentication status
- account status
- created/updated timestamps
- security metadata

The `User` entity must not encode organization-specific permissions directly when those permissions belong to memberships.

### 5.2 Membership

`Membership` represents a user's participation in an organization.

It connects:

```text
User ── Membership ── Organization
             │
             ├── Role
             └── Scope
```

A user may have multiple memberships where product policy permits it.

Examples:

- Faculty member in College A.
- Placement Officer in College B.
- Recruiter in Company C.

### 5.3 Organization

`Organization` is the top-level tenancy boundary for institution/company data.

Important concepts:

- organization identity
- organization type
- lifecycle status
- configuration
- tenant isolation metadata

Organization types initially include:

```text
COLLEGE
COMPANY
```

Additional types can be introduced without changing the core model.

---

## 6. College Domain

A `College` is an organization specialized for academic operation.

The college structure supports:

```text
College
 ├── Departments
 │    ├── Batches
 │    │    └── Students
 │    └── Faculty
 ├── Placement Office
 └── Programs / Training Activities
```

### 6.1 Department

Represents an academic department within a college.

Examples:

- Computer Science and Engineering
- Information Technology

### 6.2 Batch

Represents a cohort/year/group of students.

A batch may be linked to:

- department
- academic period
- graduation year
- placement cycle

### 6.3 Faculty / Placement Staff

Faculty and placement staff are users with organization memberships and scoped responsibilities.

They should not become separate authentication identities.

---

## 7. Company Domain

A `Company` represents an industry organization using Career360 to define roles, evaluate capability and participate in hiring/training.

A company may own:

- role blueprints
- opportunities
- training programs
- employer feedback
- interview/selection workflows
- hiring outcomes
- industry demand signals

The model must distinguish between the **company** as an organization and individual **company users** such as recruiters or hiring managers.

---

## 8. Student Domain

### 8.1 Student Profile

`StudentProfile` augments the base user with career and academic context.

Possible attributes include:

- college membership
- department
- batch
- academic program
- graduation information
- profile completeness
- career preferences
- profile visibility controls

Capability claims must not be stored as uncontrolled free-text profile fields. Skills, evidence and readiness are represented by dedicated domain structures.

### 8.2 Student Career Target

A student may target one or more roles.

The model should represent:

```text
Student
   │
   └── Career Target
          │
          └── Role / Role Blueprint Version
```

The target can drive:

- relevant skill gap analysis
- recommended learning
- practical projects
- readiness views
- relevant opportunity matching

A student may have multiple targets, but each readiness calculation is always relative to a particular role blueprint/version.

---

## 9. Skill Domain

`Skill` is the canonical atomic capability vocabulary of Career360.

A skill should have:

- canonical identifier
- canonical name
- description
- category/type where useful
- proficiency scale definition or reference
- active status

Examples:

```text
Java
SQL
REST API
Authentication
Problem Solving
Communication
```

A skill may have aliases from:

- job descriptions
- course catalogues
- assessment banks
- employer terminology
- AI extraction
- imported source systems

Aliases must resolve to canonical skills instead of creating duplicate canonical concepts without review.

---

## 10. Competency Domain

`Competency` is a higher-level capability grouping.

Example:

```text
Competency: Backend API Development
  ├── HTTP
  ├── REST API
  ├── Authentication
  ├── API Design
  ├── Error Handling
  └── API Testing
```

Competencies help Career360 model what a person can do as a cohesive capability rather than only a list of tools.

A competency may contain:

- constituent skills
- expected proficiency relationships
- descriptions
- role relevance
- assessment mappings
- evidence mappings

A competency may also have versions when its composition or interpretation changes materially.

---

## 11. Role Domain

### 11.1 Role

`Role` is the conceptual identity of a job/work role.

Examples:

- Graduate Backend Engineer
- Data Analyst
- QA Engineer
- Cloud Support Associate

The `Role` represents stable identity across multiple requirement versions.

### 11.2 Role Blueprint

`RoleBlueprint` is a versioned structured definition of what a role requires.

A Role Blueprint may contain:

```text
Role identity
Responsibilities
Competencies
Skills
Target proficiency
MUST / SHOULD / COULD / WON'T priority
Eligibility
Evidence requirements
Practical evidence requirements
Readiness conditions
Training recommendations
Version metadata
```

The distinction is important:

```text
Role
  = stable role identity

Role Blueprint Version
  = a version of the requirements for that role
```

### 11.3 Requirement

`RoleRequirement` represents one requirement within a blueprint version.

It may target:

- skill
- competency
- eligibility criterion
- evidence requirement
- practical capability requirement

Conceptual fields:

- requirement id
- blueprint version
- target concept
- target proficiency
- priority
- blocking/non-blocking policy
- evidence condition
- weight where applicable
- rationale/source metadata

### 11.4 Priority

Use MoSCoW categories:

```text
MUST
SHOULD
COULD
WONT
```

`MUST` generally indicates a blocking requirement for readiness and eligibility unless an explicit role policy says otherwise.

---

## 12. Assessment Domain

### 12.1 Assessment

An `Assessment` defines a measurement instrument.

Assessment types may include:

```text
TECHNICAL
SOFT_SKILLS
DOMAIN_KNOWLEDGE
INDUSTRY_BENCHMARK
APTITUDE
PRACTICAL
```

An assessment can be associated with:

- skills
- competencies
- roles
- organizations
- training programs

### 12.2 Assessment Version

Questions, scoring rules and mappings that materially affect a result must be versioned.

A published version should be immutable for historical interpretation.

### 12.3 Assessment Attempt

An `AssessmentAttempt` records one execution by a learner/candidate.

It should retain:

- assessment version
- participant
- start/submission timestamps
- status
- overall result
- per-skill observations/results
- evaluation metadata

### 12.4 Skill Observation

A skill observation is a measurement generated from an assessment or other authoritative evaluation.

It should preserve:

```text
Skill
Observed level/score
Source assessment attempt
Assessment version
Timestamp
Evaluation method
Confidence where applicable
```

The observation is evidence for capability, not necessarily the final readiness decision.

---

## 13. Evidence Domain

### 13.1 Evidence

`Evidence` represents a record supporting a capability claim.

Evidence may be derived from:

- assessment result
- practical lab
- project
- simulation
- certification
- course completion
- internship
- faculty evaluation
- mentor evaluation
- employer evaluation
- interview

The evidence model should distinguish evidence **type**, **source**, **claim**, **evaluation**, **freshness** and **confidence**.

### 13.2 Capability Claim

A `CapabilityClaim` states that a learner demonstrates a skill or competency at a given level based on evidence.

Conceptually:

```text
Claim
 ├── subject
 ├── skill/competency
 ├── level/score
 ├── evidence references
 ├── evaluator/source
 ├── observed_at
 ├── confidence
 └── freshness
```

A claim should never exist as an untraceable manual number when the system presents it as authoritative.

### 13.3 Evidence Freshness

Evidence may become less representative over time, especially for rapidly changing technical capabilities.

The model should support:

- observed timestamp
- freshness policy reference
- current/stale evaluation

A global stale policy must not be assumed for every skill; freshness can be role/skill specific in later versions.

---

## 14. Readiness Domain

### 14.1 Role Readiness

`RoleReadiness` is the authoritative determination of a subject's readiness against a specific Role Blueprint Version.

The subject may be:

- a student
- a candidate
- a cohort
- potentially another supported capability unit

For an individual learner:

```text
Student
  + Role Blueprint Version
  + Evidence / Capability Claims
  + Eligibility
  + Readiness Policy
  = Role Readiness
```

### 14.2 Readiness State

Canonical state progression:

```text
NOT_ASSESSED
ASSESSED
GAP_IDENTIFIED
IN_TRAINING
PENDING_REASSESSMENT
PROVISIONALLY_READY
READY
```

A future `STALE` state may be added.

### 14.3 Readiness Result

A readiness result should preserve:

- role blueprint version
- subject
- evaluation timestamp
- policy/version used
- requirements evaluated
- satisfied requirements
- unmet requirements
- blocking requirements
- evidence references
- result state
- supporting metrics
- reason/explanation

### 14.4 Readiness Explanation

The explanation should be generated from authoritative facts and policy outputs.

For example:

```text
Ready
because all MUST skills meet target proficiency,
required practical evidence exists,
and eligibility conditions are satisfied.
```

or:

```text
Not ready
because REST API target proficiency is unmet
and the required practical evidence is missing.
```

AI may improve natural-language wording, but the underlying facts must come from deterministic domain results.

---

## 15. Placement Readiness Index (PRI)

Career360 may provide institutional benchmarking metrics such as PRI.

The source research defined:

```text
Technical = 40%
Aptitude   = 40%
Soft Skill = 20%
```

and a skill-gap percentage concept based on benchmark comparison.

These metrics are useful for college-level monitoring but are **not equivalent to Role Readiness**.

The domain must therefore keep:

```text
Institutional Benchmark / PRI
          ≠
Role-specific readiness
```

PRI can be aggregated across:

```text
Student → Batch → Department → College
```

Role readiness can be analyzed across:

```text
Role → College → Department → Batch → Student
```

---

## 16. Learning Domain

### 16.1 Learning Item

A `LearningItem` is reusable content such as:

- course
- module
- workshop
- certification path
- practical lab
- simulation
- project
- mentorship activity

### 16.2 Learning Path

A `LearningPath` groups learning items into a structured sequence.

Example:

```text
Graduate Backend Engineer Path
  ├── Java foundations
  ├── SQL
  ├── REST API development
  ├── Authentication
  ├── Testing
  ├── Backend project
  └── Reassessment
```

### 16.3 Enrollment

`LearningEnrollment` connects a learner to a learning item/path.

It should track:

- enrollment status
- start/completion timestamps
- progress
- payment state where applicable
- completion evidence

Completion is not equivalent to mastery.

---

## 17. Training Domain

Training is distinct from reusable learning.

### 17.1 Training Program

A `TrainingProgram` is an intervention designed around one or more capability goals.

It may target:

- role
- role blueprint version
- college cohort
- department
- student group
- company workforce group

It may contain:

- target skills
- competencies
- learning items
- practical activities
- trainers
- schedule
- attendance/progress
- assessments
- reassessment
- outcomes

### 17.2 Training Session

A `TrainingSession` represents a scheduled delivery event.

Possible fields:

- trainer
- time
- mode/location
- topic
- attendance
- materials

### 17.3 Trainer Assignment

A training program may allocate trainers based on:

- skill expertise
- competency alignment
- availability
- organizational scope

---

## 18. Opportunity Domain

### 18.1 Opportunity

An `Opportunity` represents a job, internship or supported placement opportunity.

Types initially include:

```text
JOB
INTERNSHIP
```

An opportunity belongs to an organization, usually a company, and references requirements through a Role Blueprint Version or equivalent structured requirement set.

### 18.2 Opportunity Lifecycle

A general lifecycle is:

```text
DRAFT
PUBLISHED
CLOSED
CANCELLED
```

More granular recruitment states may be added without changing the core role/readiness model.

### 18.3 Opportunity Requirements

The opportunity should not store a second uncontrolled copy of skills when a structured role blueprint applies.

Prefer:

```text
Opportunity
   ↓
Role Blueprint Version
   ↓
Requirements
```

Opportunity-specific constraints may be layered on top.

---

## 19. Matching Domain

### 19.1 Match

A `Match` represents the result of comparing a subject against an opportunity/role.

Inputs include:

- eligibility
- required skills
- target proficiency
- MUST requirements
- evidence availability
- evidence freshness/confidence
- role readiness

A match should be reproducible from the relevant versioned inputs and policies.

### 19.2 Match Classes

A useful conceptual classification is:

```text
READY
TRAINABLE
GAP_HEAVY
INELIGIBLE
```

Exact thresholds should live in policy/configuration, not be embedded in UI logic.

### 19.3 Semantic Matching

Semantic similarity can improve discovery/ranking, but a semantic score must not override deterministic disqualifiers without an explicit policy.

---

## 20. Application Domain

### 20.1 Application

An `Application` represents a student's/candidate's application to an opportunity.

Conceptual states:

```text
DRAFT
SUBMITTED
UNDER_REVIEW
SHORTLISTED
INTERVIEW
SELECTED
REJECTED
WITHDRAWN
```

Actual workflow can evolve, but historical application state changes must remain auditable.

### 20.2 Application Snapshot Principle

When an application is evaluated, critical values needed to explain the decision should not depend solely on mutable current profile state.

The domain should retain or be able to reconstruct:

- opportunity/role version
- submitted profile context
- relevant readiness result/version
- eligibility state
- submitted evidence references

---

## 21. Outcome Domain

Outcomes close the loop.

Examples:

- learning completion
- reassessment improvement
- training effectiveness
- internship completion
- placement/hiring
- employer evaluation

### 21.1 Outcome

An `Outcome` records what happened after an intervention or opportunity.

Examples:

```text
TRAINING_COMPLETED
SKILL_IMPROVED
ASSESSMENT_IMPROVED
INTERNSHIP_COMPLETED
HIRED
NOT_HIRED
EMPLOYER_SATISFACTION
```

### 21.2 Employer Feedback

Employer feedback may capture structured observations such as:

- skill strength
- skill gap
- workplace readiness
- communication
- practical capability
- ramp-up needs

This feedback can later contribute to training intelligence and demand signals, subject to product policy and privacy requirements.

---

## 22. Industry Intelligence Domain

Industry Intelligence is the demand-side learning layer.

### 22.1 Industry Signal

An `IndustrySignal` represents a normalized observation about market demand.

Possible source classes:

- company role definitions
- uploaded job descriptions
- employer feedback
- recruitment outcomes
- historical hiring data
- approved external sources

Each signal should retain provenance such as:

- source
- observed date
- context
- confidence
- normalization status

### 22.2 Demand Signal

Signals can aggregate into:

```text
Raw source
   ↓
Extraction
   ↓
Normalization
   ↓
Canonical skills
   ↓
Aggregation
   ↓
Demand signal
   ↓
Trend / intelligence
```

The intelligence layer should not directly mutate authoritative skill taxonomy or role readiness without validation and policy.

---

## 23. Reporting Domain

Reporting consumes authoritative domain data to create:

- student reports
- skill gap reports
- cohort readiness reports
- placement reports
- training effectiveness reports
- opportunity reports
- institution dashboards
- company capability views

Reports are projections/representations of source truth.

They must not become a second source of truth.

Heavy report generation may run asynchronously and store durable report metadata and output references.

---

## 24. Document Domain

Documents manage secure file metadata and object-storage references.

Examples:

- resume
- certificate
- project document
- assessment artifact
- placement document
- internship document
- training material
- employer feedback attachment

Conceptual model:

```text
Document
 ├── owner
 ├── organization scope
 ├── document type
 ├── storage object reference
 ├── content metadata
 ├── access policy
 └── lifecycle state
```

The file bytes live in object storage; ownership and authorization live in PostgreSQL/domain state.

---

## 25. Billing Domain

Billing is supporting infrastructure for paid learning/subscription capabilities.

It should model:

- plan
- subscription
- invoice/payment intent
- payment state
- entitlement

Billing events from external providers must be idempotent and auditable.

Billing should not leak provider-specific concepts into core career/readiness domain models.

---

## 26. Notification Domain

Notifications represent communications triggered by product events.

Examples:

- assessment assigned
- assessment due
- training started
- reassessment available
- opportunity published
- application status changed
- payment updated
- report ready

Notification delivery can be asynchronous.

A notification should reference the underlying business event rather than embed duplicated business truth.

---

## 27. Audit Domain

Audit records materially consequential actions.

Examples:

- role blueprint published
- readiness recalculated
- assessment reopened
- evidence approved/rejected
- training assignment changed
- opportunity published/closed
- application status changed
- access/permission changes
- sensitive document operations
- billing state changes

Audit records should capture who/what/when/context sufficiently for investigation and compliance requirements.

---

## 28. Aggregate Boundaries

The following are recommended aggregate roots for the initial modular monolith.

| Aggregate root | Main responsibility |
|---|---|
| Organization | Tenant identity and organization lifecycle |
| Membership | User ↔ organization access relationship |
| StudentProfile | Student-specific career context |
| Role | Stable role identity |
| RoleBlueprintVersion | Immutable/versioned role requirements |
| Skill | Canonical skill identity and lifecycle |
| Competency | Competency identity/composition |
| Assessment | Assessment definition/version lifecycle |
| AssessmentAttempt | A learner's assessment execution |
| Evidence | Capability proof record |
| RoleReadiness | Versioned readiness result/state |
| LearningItem | Reusable learning asset |
| LearningPath | Learning sequence |
| TrainingProgram | Intervention lifecycle |
| Opportunity | Job/internship opening lifecycle |
| Application | Candidate application lifecycle |
| MatchResult | Match computation/result snapshot where persisted |
| Outcome | Training/hiring/placement outcome |
| IndustrySignal | Demand evidence |
| Document | File metadata and lifecycle |
| Subscription | Billing entitlement lifecycle |
| AuditEntry | Immutable audit record |

An aggregate is not automatically a table and does not imply that every child record must use one database transaction.

Aggregate boundaries exist to define consistency ownership.

---

## 29. Key Relationships

### 29.1 Identity → Organization

```text
User 1 ─── N Membership N ─── 1 Organization
```

### 29.2 College structure

```text
College 1 ─── N Department
Department 1 ─── N Batch
Batch 1 ─── N StudentProfile
```

The exact organization/membership relation may coexist with these academic structures.

### 29.3 Student capability

```text
Student
   │
   ├── Assessment Attempts
   ├── Evidence
   ├── Learning Enrollments
   └── Role Readiness
```

### 29.4 Role structure

```text
Role 1 ─── N RoleBlueprintVersion
RoleBlueprintVersion 1 ─── N RoleRequirement
RoleRequirement N ─── 1 Skill/Competency
```

### 29.5 Evidence and readiness

```text
Evidence N ─── N Skill/Competency
RoleReadiness ─── uses ─── Evidence / Capability Claims
```

### 29.6 Opportunity/application

```text
Opportunity N ─── 1 Company
Opportunity N ─── 1 RoleBlueprintVersion
Application N ─── 1 Opportunity
Application N ─── 1 Student
```

---

## 30. Historical Versioning Model

Career360 must preserve historical meaning.

The following objects should be versioned or otherwise immutable when changes would alter interpretation:

```text
Role Blueprint
Assessment
Scoring / Evaluation Policy
Readiness Policy
Potentially Competency Composition
Potentially Skill Proficiency Scale
```

Example:

```text
Graduate Backend Engineer
        │
        ├── Blueprint v1
        │      ├── Java >= 3
        │      ├── SQL >= 2
        │      └── REST >= 3
        │
        └── Blueprint v2
               ├── Java >= 3
               ├── SQL >= 3
               ├── REST >= 3
               └── Practical API project required
```

A readiness decision recorded under v1 must remain understandable even after v2 is published.

---

## 31. State Transition Ownership

State changes belong to the domain that owns the lifecycle.

Examples:

| State | Owner |
|---|---|
| Assessment attempt | Assessments |
| Readiness state | Readiness |
| Learning enrollment | Learning |
| Training program | Training |
| Opportunity publication | Opportunities |
| Application status | Applications |
| Payment state | Billing |
| Document review state | Documents |

Other modules may request a transition, but they should not mutate the owning aggregate's state directly.

---

## 32. Cross-Domain Workflow: Role to Readiness

The main closed-loop workflow is:

```text
Company defines role
        ↓
Role Blueprint Version published
        ↓
College selects cohort / student target
        ↓
Assessment assigned
        ↓
Assessment attempt completed
        ↓
Skill observations recorded
        ↓
Evidence accumulated
        ↓
Readiness evaluated
        ↓
Gaps identified
        ↓
Training / learning assigned
        ↓
Practical evidence produced
        ↓
Reassessment
        ↓
Readiness recalculated
        ↓
Ready / trainable result
```

Each step owns its own state while preserving traceable references across domains.

---

## 33. Cross-Domain Workflow: Readiness to Hiring

```text
Role Blueprint
      ↓
Candidate capability + evidence
      ↓
Role readiness
      ↓
Opportunity published
      ↓
Eligibility filter
      ↓
Deterministic + semantic matching
      ↓
Candidate shortlist
      ↓
Application
      ↓
Interview / selection
      ↓
Hiring outcome
      ↓
Employer feedback
```

A match is not an application, and an application is not a hiring outcome.

These remain separate domain facts.

---

## 34. Cross-Domain Workflow: College Skill Development

The college-facing model is:

```text
College
  ↓
Batch / Department
  ↓
Role demand selection
  ↓
Assessment
  ↓
Skill gap aggregation
  ↓
Cohort capability matrix
  ↓
Top gaps
  ↓
Training program
  ↓
Learning / practical work
  ↓
Reassessment
  ↓
Updated readiness
  ↓
Placement support
```

The source research specifically defines a college skill-gap hierarchy:

```text
Student → Batch → Department → College
```

and supports reports, at-risk indicators, learning recommendations and placement-readiness analysis.

---

## 35. Bulk Import Domain Behavior

The college module supports bulk student imports.

Bulk import should be modeled as a workflow rather than a direct table write:

```text
Upload
  ↓
Validate schema
  ↓
Parse rows
  ↓
Normalize values
  ↓
Validate academic relationships
  ↓
Detect duplicates/conflicts
  ↓
Preview
  ↓
Commit transaction
  ↓
Audit result
```

Failures must identify row-level problems without partially committing invalid records.

---

## 36. Search and Discovery Model

Search is a projection across domain objects.

Candidate/searchable objects may include:

- roles
- skills
- competencies
- learning items
- training programs
- opportunities
- students/candidates according to authorization

Search must respect:

- tenant scope
- visibility rules
- lifecycle state
- authorization

Search indices or full-text/vector representations are derived data, not the transactional source of truth.

---

## 37. AI-Generated Domain Proposals

AI may propose structured domain content such as:

```text
JD → role requirements
JD → candidate skill terms
Skill alias → canonical skill
Gap → learning recommendation
Report data → narrative
```

The domain flow remains:

```text
Raw input
  ↓
AI proposal
  ↓
Schema validation
  ↓
Domain validation
  ↓
Business policy
  ↓
Authoritative domain state
```

An AI output is not itself a domain truth.

---

## 38. Domain Events

Domain/application events may be used to decouple asynchronous reactions.

Examples:

```text
RoleBlueprintPublished
AssessmentSubmitted
EvidenceApproved
ReadinessChanged
TrainingCompleted
ReassessmentCompleted
OpportunityPublished
ApplicationStatusChanged
HiringOutcomeRecorded
EmployerFeedbackSubmitted
```

Events should carry stable identifiers and enough metadata to process the reaction safely.

They should not become an ungoverned replacement for transactional state.

---

## 39. Derived Data

The following are examples of derived data:

- search index records
- dashboard aggregates
- readiness summaries cached for performance
- trend metrics
- report datasets
- semantic embeddings
- notification projections

Derived data can be rebuilt from authoritative source state where practical.

Where full rebuild is not practical, rebuildability and reconciliation procedures must be documented.

---

## 40. Data Ownership Matrix

| Data | Authoritative owner |
|---|---|
| User identity | Identity & Access |
| Membership/permissions | Identity & Access |
| Organization structure | Organizations |
| Student academic placement | Students / College context |
| Canonical skills | Skills |
| Competency composition | Competencies |
| Role identity | Roles |
| Role requirements | Role Blueprint |
| Assessment definitions | Assessments |
| Assessment results | Assessments |
| Capability evidence | Evidence |
| Readiness decision | Readiness |
| Learning catalog | Learning |
| Training intervention | Training |
| Job/internship opening | Opportunities |
| Match calculation | Matching |
| Application lifecycle | Applications |
| Hiring/training outcomes | Outcomes |
| Demand signals | Industry |
| File metadata | Documents |
| Subscription/payment state | Billing |
| Audit trail | Audit |

---

## 41. Domain Anti-Patterns

The implementation must avoid the following patterns.

### 41.1 Student table as capability store

Do not place authoritative skill scores, readiness percentages and certificates directly on `StudentProfile`.

### 41.2 Job description as opaque text only

A raw JD may be retained, but structured role requirements must be represented separately.

### 41.3 Certificate = skill mastery

Completion/certification is one evidence type, not universal proof of practical skill.

### 41.4 One global readiness score

A single universal score must not replace role-specific readiness.

### 41.5 Hidden AI decisions

AI must not make final readiness or eligibility decisions invisibly.

### 41.6 Shared mutable cross-domain tables

Avoid a giant generic table for skills, jobs, assessments, learning and readiness.

### 41.7 Copying requirement lists everywhere

Use references to structured role blueprint versions rather than duplicating mutable skill lists.

### 41.8 Report database becoming source of truth

Reports are projections of authoritative domain state.

---

## 42. Initial Persistence Strategy

The recommended initial physical model is a PostgreSQL schema with clear naming and ownership conventions.

The exact schema organization may use module-oriented naming such as:

```text
identity_*
org_*
skill_*
competency_*
role_*
assessment_*
evidence_*
readiness_*
learning_*
training_*
opportunity_*
matching_*
application_*
industry_*
outcome_*
document_*
billing_*
audit_*
```

The research for the Course Planner also used `course_planner_` prefixes; this can be preserved for that feature where it improves migration clarity, but new design should align to the broader Career360 domain ownership model.

---

## 43. Tenant Key Strategy

Where data is tenant scoped, the physical model should make scope explicit enough for safe query construction and authorization.

Typical records may contain:

- `organization_id`
- `college_id`
- `company_id`
- `department_id`
- `batch_id`
- subject/resource ownership identifiers

Not every table requires every key.

The rule is that access scope must be derivable and enforceable without trusting client-supplied relationships.

---

## 44. Deletion and History

Business data should default to lifecycle-aware deactivation/archival rather than destructive deletion where history matters.

Examples:

- skill deactivated rather than physically deleted
- role blueprint version retired rather than rewritten
- assessment version retired rather than overwritten
- student account deactivated rather than destroying historical placement records
- document access revoked while preserving audit metadata

Hard deletion may be used where legally or operationally required and where dependent historical semantics remain valid.

---

## 45. Domain Invariants Summary

The following invariants are mandatory:

1. Every authoritative capability claim is traceable to evidence.
2. Every role-readiness result references a specific role blueprint version.
3. Published historical role and assessment versions remain interpretable.
4. Canonical skills are not duplicated merely because source terminology differs.
5. Competencies represent broader capability groupings, not aliases for skills.
6. Completion is not automatically practical mastery.
7. MUST role requirements are blocking unless policy explicitly says otherwise.
8. Eligibility is evaluated server-side.
9. Matching is not application state.
10. Applications are not outcomes.
11. Reports are derived views, not source of truth.
12. Search indexes and embeddings are derived data.
13. AI output is a proposal until validated and accepted by deterministic domain logic.
14. Tenant scope is mandatory for tenant-owned resources.
15. Historical facts must not be rewritten simply because the current profile changed.

---

## 46. Domain Evolution Rules

The model is expected to evolve as Career360 moves from the P0 foundation to P1 and P2 capabilities.

### P0

Core entities required for closed-loop readiness:

```text
Identity
Organizations
College / Company
Student
Skills
Competencies
Roles / Role Blueprints
Assessments
Evidence
Readiness
Learning
Training
Opportunities
Matching
Applications
Outcomes
Reporting
Audit
Documents
```

### P1

Extend with:

```text
Industry Intelligence
JD ingestion
Advanced skill normalization
Advanced evidence
Employer evaluation
Training intelligence
Trainer allocation
Time-to-Ready analytics
```

### P2

Extend with:

```text
Faculty-industry programmes
FDP workflows
Research collaboration
Consulting
Mentorship marketplace
Cross-college benchmarking
Advanced workforce planning
Predictive analytics
Large learning marketplace
```

The P1/P2 expansion should add capabilities without weakening the P0 domain invariants.

---

## 47. Implementation Guidance

When implementing a new feature, identify:

```text
Who owns the business concept?
What aggregate owns the state?
What evidence supports the claim?
What version must be preserved?
Which organization/tenant scope applies?
What transaction boundary is required?
What event or async reaction is required?
Which data is authoritative vs derived?
```

A feature is not fully designed until these questions are answered.

---

## 48. Final Domain Statement

Career360 is not modeled as a collection of independent modules for users, courses and jobs.

Its domain is centered on a traceable chain:

```text
Role Requirement
      ↓
Skill / Competency
      ↓
Assessment
      ↓
Evidence
      ↓
Capability
      ↓
Gap
      ↓
Learning / Training
      ↓
Reassessment
      ↓
Role Readiness
      ↓
Opportunity / Matching
      ↓
Application
      ↓
Outcome
      ↓
Employer Feedback / Industry Intelligence
```

The domain model succeeds when every important capability claim can be connected to the role it matters for, the evidence supporting it, the intervention used to improve it, and the outcome produced by that improvement.
