# Career360 — Opportunities & Applications Specification

**Document:** `docs/11_opportunities_applications.md`  
**Status:** Product/Engineering Domain Specification  
**Applies to:** Jobs, internships, opportunity publishing, requirements, eligibility, matching, application lifecycle, application snapshots, interviews, outcomes and employer feedback  
**Primary owner:** Product + Domain Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`, `docs/04_role_blueprint.md`, `docs/05_readiness_matching.md`, `docs/06_data_contracts.md`, `docs/07_security_authorization.md`, `docs/10_industry_intelligence.md`

---

## 1. Purpose

Career360 must support a trustworthy path from role demand to real opportunities and measurable outcomes.

The opportunity/application domain connects:

```text
Role Blueprint
      ↓
Opportunity
      ↓
Eligibility + Requirements
      ↓
Candidate Capability
      ↓
Match
      ↓
Application
      ↓
Review / Interview
      ↓
Selection / Outcome
      ↓
Employer Feedback
```

The system must distinguish:

- a reusable role definition;
- a concrete job/internship opportunity;
- a candidate's readiness;
- a match result;
- an application decision;
- the final outcome.

These are related domain objects, not one combined "candidate score."

---

## 2. Product Principle

> **An opportunity is a concrete demand instance; an application is a historical decision record; a match is an explainable comparison, not an employment decision.**

Career360 should help answer:

### Student

- Is this opportunity relevant to my target role?
- Am I eligible?
- Which requirements do I satisfy?
- Which requirements are gaps?
- What evidence supports my profile?
- Should I apply?
- What happens after I apply?

### College

- Which opportunities fit our students?
- Which students are ready or trainable?
- Where are the cohort gaps?
- What placement pipeline exists?
- What were the outcomes?

### Company

- What capability does this opportunity require?
- Which candidates are eligible?
- Which candidates are ready?
- Which candidates are trainable?
- What happened after hiring?

---

## 3. Opportunity Types

P0 supports:

```text
JOB
INTERNSHIP
```

The model should allow future opportunity types without changing the core architecture.

Examples for later expansion:

```text
APPRENTICESHIP
LIVE_PROJECT
CHALLENGE
FELLOWSHIP
```

---

## 4. Opportunity Ownership

An opportunity normally belongs to a company organization.

The opportunity should record:

```text
organization_id
created_by
role_id
role_blueprint_version_id
status
title
description / source reference
location
work_mode
application_window
eligibility constraints
created_at
updated_at
published_at
closed_at
```

Company-private metadata must remain protected according to tenant and membership authorization.

---

## 5. Opportunity Lifecycle

The baseline lifecycle is:

```text
DRAFT
   ↓
PUBLISHED
   ↓
CLOSED
```

A cancellation path is supported:

```text
DRAFT / PUBLISHED
        ↓
CANCELLED
```

More granular recruitment states may be added without changing the underlying opportunity model.

Rules:

- only authorized users may publish;
- a published opportunity should have a valid requirement basis;
- closed opportunities accept no new applications unless an explicit reopening policy exists;
- cancellation must preserve historical applications and audit records.

---

## 6. Draft Requirements

Before publication, the opportunity must have a sufficiently defined requirement set.

Conceptually:

```text
Role
 ↓
Role Blueprint Version
 ↓
Opportunity Requirements
 ↓
Opportunity
```

The preferred design is to reference a versioned Role Blueprint rather than copying uncontrolled skill requirements into the opportunity.

Opportunity-specific constraints may be layered on top.

Examples:

- minimum graduation year;
- allowed departments;
- minimum assessment result where policy permits;
- location/work mode;
- application deadline;
- citizenship/work authorization where legally appropriate and product-supported.

---

## 7. Requirement Versioning

A published opportunity must remain explainable even if its associated role blueprint evolves.

Therefore:

```text
Opportunity
   ↓
Role Blueprint Version N
```

The opportunity should not silently switch to:

```text
Role Blueprint Version N+1
```

after publication.

Any material change should create a controlled revision or explicitly recorded opportunity requirement version.

---

## 8. Eligibility

Eligibility is deterministic wherever possible.

Potential inputs include:

- academic constraints;
- institution/department constraints;
- graduation window;
- required legal or organizational eligibility;
- opportunity-specific constraints;
- explicitly configured minimum conditions.

Eligibility should be evaluated before or alongside readiness/matching.

A strong skill profile must not override a hard eligibility blocker.

---

## 9. Readiness vs Eligibility

These concepts must remain separate.

```text
Eligibility:
"Can this candidate participate?"

Readiness:
"Does the candidate demonstrate the capability
required for this role?"
```

A candidate may be:

```text
ELIGIBLE + NOT_READY
ELIGIBLE + TRAINABLE
ELIGIBLE + READY
INELIGIBLE + READY_SKILLWISE
```

The final classification must remain explainable.

---

## 10. Candidate Matching

Matching compares:

```text
Candidate Capability Profile
           +
Opportunity Requirement Set
           ↓
         Match
```

Inputs should include:

- eligibility;
- canonical skills;
- competencies;
- target proficiency;
- MUST/SHOULD/COULD priority;
- evidence;
- evidence confidence;
- evidence freshness;
- practical evidence;
- role readiness.

Semantic similarity can improve retrieval/ranking but must not bypass deterministic blockers.

---

## 11. Match Classes

The conceptual match classes are:

```text
READY
TRAINABLE
GAP_HEAVY
INELIGIBLE
```

Exact thresholds belong to configurable domain policy.

A match result should contain enough information to explain the classification.

Conceptual structure:

```text
Match
├── eligibility
├── readiness state
├── requirement coverage
├── MUST blockers
├── SHOULD gaps
├── evidence coverage
├── evidence confidence
├── freshness
├── semantic similarity (optional)
└── explanation
```

---

## 12. Deterministic vs Semantic Matching

Career360 should use a hybrid approach.

### Deterministic layer

Handles:

- hard eligibility;
- MUST requirement blockers;
- proficiency thresholds;
- evidence requirements;
- freshness rules;
- readiness conditions.

### Semantic layer

May help with:

- similar role discovery;
- related skill terms;
- opportunity discovery;
- candidate/opportunity ranking;
- ambiguous text interpretation.

A semantic score must not silently override a deterministic disqualifier.

---

## 13. Matching Explainability

Every match shown to a user should answer:

```text
Why was this opportunity matched?
Why is the candidate ready?
What is missing?
What evidence supports the result?
What requirement blocks readiness?
```

Example explanation structure:

```text
MATCH: TRAINABLE

Satisfied:
- REST API Development
- Java
- Unit Testing

Gap:
- Practical Spring Boot evidence

MUST blocker:
- No verified practical evidence for the required backend project

Recommended action:
- Complete assigned backend practical project and reassessment
```

The explanation must be generated from structured result data.

AI may improve language quality, but authoritative match facts must come from the structured domain result.

---

## 14. Candidate Discovery

Companies may receive candidate pools based on:

- eligibility;
- target role;
- readiness;
- matching;
- college partnership;
- explicit application status.

Candidate discovery must obey authorization.

A company must not be able to query or infer unrelated private student information.

---

## 15. Student Opportunity Discovery

Students should be able to discover:

- opportunities aligned with their target roles;
- opportunities they are eligible for;
- opportunities where they are ready;
- opportunities where they are trainable;
- opportunities with meaningful skill gaps.

The UI should clearly distinguish:

```text
GOOD MATCH
READY
TRAINABLE
GAP HEAVY
INELIGIBLE
```

The product should avoid presenting every opportunity as equally suitable.

---

## 16. Application Lifecycle

The baseline lifecycle is:

```text
DRAFT
   ↓
SUBMITTED
   ↓
UNDER_REVIEW
   ↓
SHORTLISTED
   ↓
INTERVIEW
   ↓
SELECTED
```

Alternative terminal paths:

```text
REJECTED
WITHDRAWN
```

An implementation may add operational states such as:

```text
WAITLISTED
OFFERED
OFFER_ACCEPTED
OFFER_DECLINED
```

without changing the core application model.

---

## 17. Application Rules

### Draft

The candidate may prepare but has not formally applied.

### Submitted

The application is formally recorded.

### Under Review

The company or authorized reviewing organization is evaluating it.

### Shortlisted

The candidate passed the organization's configured screening stage.

### Interview

The candidate entered an interview stage.

### Selected

The organization selected the candidate for the opportunity.

### Rejected

The process ended without selection.

### Withdrawn

The candidate withdrew the application.

State transitions must be validated and audited.

---

## 18. Application Snapshot Principle

An application must remain understandable even when the candidate profile later changes.

At submission or evaluation, the system should retain or be able to reconstruct:

```text
opportunity version
role blueprint version
eligibility result
relevant readiness result/version
submitted profile context
submitted evidence references
application state
```

A mutable live student profile must not be the only historical basis for explaining an old application decision.

---

## 19. Resume and Document Handling

Candidate documents may include:

- resume;
- portfolio;
- certification documents;
- project evidence;
- supporting documents.

Documents are handled through the Document domain and object storage rules.

The application should store references and metadata rather than embedding large files directly in relational records.

Document access must obey:

```text
Tenant authorization
+
Application/opportunity context
+
Document-specific permission
```

---

## 20. Application Evidence

The application may expose relevant evidence such as:

- verified skill evidence;
- projects;
- assessments;
- certifications;
- internships;
- practical labs;
- mentor/faculty/employer evaluations.

Evidence visibility should be configurable and privacy-aware.

A candidate's entire evidence history must not automatically become visible to every employer.

---

## 21. Interview Support

The domain may support structured interview stages.

Possible objects:

```text
Interview
InterviewRound
InterviewEvaluation
InterviewFeedback
```

Interview evaluation should remain separate from automated readiness.

An interviewer may record:

- technical assessment;
- behavioral observations;
- role-specific evaluation;
- recommendation;
- final comments.

Where the product later offers AI assistance, AI should summarize or structure interviewer-provided information rather than become the sole authority for selection.

---

## 22. Employer Decision

Final hiring decisions belong to the authorized employer workflow.

Career360 may provide:

- candidate matching;
- evidence summaries;
- readiness;
- structured assessment results;
- interview workflow;
- decision tracking.

Career360 must not represent its own readiness score as a guaranteed hiring result.

---

## 23. Application Auditability

Material events must be auditable.

Examples:

```text
APPLICATION_CREATED
APPLICATION_SUBMITTED
APPLICATION_REVIEWED
APPLICATION_SHORTLISTED
INTERVIEW_SCHEDULED
INTERVIEW_EVALUATED
APPLICATION_SELECTED
APPLICATION_REJECTED
APPLICATION_WITHDRAWN
OPPORTUNITY_PUBLISHED
OPPORTUNITY_CLOSED
```

Audit records should include actor, timestamp, organization scope and relevant object identifiers.

---

## 24. Duplicate Application Policy

The system should enforce a defined uniqueness policy.

A common baseline is:

```text
One active application per student + opportunity
```

Reapplication behavior after rejection or withdrawal must be explicitly configured rather than accidentally enabled.

Concurrent submissions must be protected by transactional/database constraints.

---

## 25. Withdrawal

Students may withdraw only when policy permits.

Withdrawal must:

- transition the application through an allowed state;
- preserve historical state changes;
- prevent unauthorized reopening;
- remain visible to the student;
- be represented consistently in company and college views according to policy.

---

## 26. Opportunity Closure

Closing an opportunity should:

- prevent new submissions;
- preserve existing applications;
- preserve historical requirements/version;
- preserve match/readiness snapshots where needed;
- trigger appropriate notifications;
- remain auditable.

Closed opportunities must remain queryable for authorized reporting and historical analysis.

---

## 27. College Placement Workflow

The college workflow is:

```text
Company Opportunity
       ↓
Eligibility / Requirement Mapping
       ↓
College Cohort Filtering
       ↓
Student Matching
       ↓
READY / TRAINABLE / GAP-HEAVY
       ↓
Student Notification / Guidance
       ↓
Application
       ↓
Selection / Rejection
       ↓
Placement Outcome
```

The college should be able to see aggregate pipeline health without exposing unnecessary private company or student details.

---

## 28. Company Workflow

Company workflow:

```text
Create Role
   ↓
Role Blueprint
   ↓
Create Opportunity
   ↓
Publish
   ↓
Discover / Receive Candidates
   ↓
Review Evidence + Readiness
   ↓
Shortlist
   ↓
Interview
   ↓
Select
   ↓
Hiring Outcome
   ↓
Employer Feedback
```

This closes the loop to Industry Intelligence and Training.

---

## 29. Student Workflow

Student workflow:

```text
Target Role
   ↓
Opportunity Discovery
   ↓
Eligibility
   ↓
Readiness / Match
   ↓
Review Gaps
   ↓
Application
   ↓
Interview
   ↓
Outcome
```

A student should be able to see actionable gaps before submitting an application where the product policy allows it.

---

## 30. Notifications

Relevant events may trigger notifications:

- opportunity published;
- closing soon;
- application submitted;
- application state changed;
- interview scheduled;
- selection;
- rejection;
- required action;
- document issue.

Notifications should be asynchronous where appropriate.

Delivery failures must not corrupt the underlying application transaction.

---

## 31. Privacy

The opportunity/application system must protect candidate privacy.

Defaults should favor minimum necessary disclosure.

Examples:

- company sees application-relevant evidence, not unrelated private profile data;
- college sees placement-relevant aggregate data and authorized student records;
- students see their own application details;
- employer feedback has controlled visibility.

Sensitive attributes must not be exposed through matching explanations unless expressly required and authorized.

---

## 32. Authorization

Authorization is based on:

```text
Actor identity
+
Organization membership
+
Role
+
Object ownership
+
Relationship to opportunity/application
+
Allowed action
```

Examples:

```text
Student:
  create/view/withdraw own application

Company reviewer:
  view applications to owned opportunity
  advance authorized application states

College placement officer:
  view authorized student placement pipeline

Admin:
  manage platform policy within granted scope
```

All object-level decisions must be enforced server-side.

---

## 33. Transactional Invariants

Important operations should be atomic.

### Submit application

```text
Validate opportunity
+
Validate eligibility
+
Check duplicate constraint
+
Create application
+
Create audit event
+
Queue notification
```

The application and its authoritative state transition must commit atomically.

### Publish opportunity

```text
Validate role/requirement version
+
Validate publishable fields
+
Change status
+
Create audit event
```

Notification dispatch may be queued after the transaction.

---

## 34. Idempotency and Concurrency

Submission and state-transition endpoints must tolerate retries.

Examples:

```text
same idempotency key
→ same application result

concurrent submit
→ one valid application

concurrent status transition
→ one valid next state
```

Database constraints and transactional logic are required; client-side checks are insufficient.

---

## 35. Application Matching Recalculation

A match can become stale when:

- role requirements change through a new version;
- candidate evidence changes;
- readiness changes;
- evidence becomes stale;
- eligibility changes.

The system should therefore store match timestamps and relevant version references.

Possible match states:

```text
CURRENT
STALE
SUPERSEDED
```

A stale match must not silently be presented as current.

---

## 36. Outcome Model

Application outcomes may include:

```text
SELECTED
REJECTED
WITHDRAWN
NO_RESPONSE
OFFER_ACCEPTED
OFFER_DECLINED
HIRED
```

Internship outcomes may additionally include:

```text
INTERNSHIP_COMPLETED
INTERNSHIP_EXTENDED
PRE_PLACEMENT_OFFER
```

Exact outcome taxonomy should remain configurable.

---

## 37. Employer Feedback Loop

After an opportunity outcome, Career360 may collect structured employer feedback.

Possible questions:

- Was the candidate technically prepared?
- Which skills were strong?
- Which competencies were weak?
- Was practical capability sufficient?
- How much ramp-up was required?
- Did training prepare the candidate adequately?
- What capabilities should future candidates develop?

The feedback flows into:

```text
Employer Feedback
      ↓
Outcome Signal
      ↓
Industry Intelligence
      ↓
Role / Training Insight
```

Feedback must not silently rewrite role requirements or canonical skills.

---

## 38. Placement Analytics

Useful analytics include:

### Student

- applications;
- interviews;
- selections;
- role alignment;
- application outcomes.

### College

- applications by cohort;
- shortlist rate;
- interview rate;
- placement rate;
- role readiness before application;
- trainable-to-ready conversion;
- training-to-placement outcomes.

### Company

- applicant volume;
- ready/trainable distribution;
- assessment outcomes;
- interview funnel;
- hiring outcomes;
- employer feedback.

Analytics are projections of source domain truth.

---

## 39. Reporting and Historical Truth

Reports must identify the relevant:

```text
Opportunity version
Role Blueprint version
Application state
Readiness result version
Outcome definition
Reporting window
```

Historical placement reports must not change merely because a candidate's current profile changed.

---

## 40. Search

Opportunity search may support:

- title;
- role;
- skills;
- competencies;
- location;
- work mode;
- internship/job type;
- eligibility;
- deadline;
- industry;
- company.

Search may use PostgreSQL full-text search, `pg_trgm` and semantic/vector similarity.

Search ranking must not bypass authorization.

---

## 41. Semantic Opportunity Discovery

Semantic retrieval can help connect:

```text
Student target:
"Backend engineering"

Opportunity:
"Graduate Java API Developer"
```

The system may recognize related role concepts, but final requirement evaluation must use the structured Role Blueprint and Opportunity Requirements.

Semantic relevance is not proof of readiness.

---

## 42. API Surface

Conceptual endpoints:

```text
/api/v1/opportunities
/api/v1/opportunities/{id}
/api/v1/opportunities/{id}/publish
/api/v1/opportunities/{id}/close
/api/v1/opportunities/{id}/matches
/api/v1/opportunities/{id}/applications

/api/v1/applications
/api/v1/applications/{id}
/api/v1/applications/{id}/submit
/api/v1/applications/{id}/withdraw
/api/v1/applications/{id}/state
/api/v1/applications/{id}/interviews
/api/v1/applications/{id}/outcome
```

Exact request/response schemas are governed by `docs/06_data_contracts.md`.

---

## 43. UI State Requirements

Opportunity and application screens must support the standard four states:

```text
IDLE
LOADING
ERROR
EMPTY
```

Examples:

- no opportunities found;
- application list empty;
- match computation pending;
- application retrieval failed.

The UI must not show fake data to cover a missing backend state.

---

## 44. Documents and Resume Submissions

Document processing may be asynchronous.

Flow:

```text
Upload
  ↓
Object Storage
  ↓
Metadata Record
  ↓
Security Validation
  ↓
Optional Processing
  ↓
Available to Authorized Workflow
```

The application transaction must not assume that document parsing or virus scanning is instantaneous.

---

## 45. Notifications and Event Flow

Useful domain events include:

```text
OpportunityPublished
OpportunityClosed
ApplicationSubmitted
ApplicationStateChanged
InterviewScheduled
ApplicationSelected
ApplicationRejected
ApplicationWithdrawn
OutcomeRecorded
EmployerFeedbackSubmitted
```

Events should contain stable identifiers and version information without embedding unbounded payloads.

---

## 46. Production Anti-Patterns

Career360 must avoid:

### 46.1 Job portal only

The opportunity module must remain connected to role requirements, readiness and outcomes.

### 46.2 Opaque ranking

Users must be able to understand why a candidate/opportunity was matched.

### 46.3 Live-profile-only history

Historical applications require reconstructable snapshot context.

### 46.4 Readiness = hiring

Readiness supports recruitment; it does not guarantee selection.

### 46.5 AI-only screening

AI cannot become the sole authority for final hiring decisions.

### 46.6 Duplicated requirement truth

Opportunity requirements should reference versioned structured role requirements where possible.

### 46.7 Client-only authorization

All access decisions must be enforced by Spring Boot on the server.

---

## 47. P0 / P1 / P2 Scope

### P0

- jobs;
- internships;
- company opportunity creation;
- Role Blueprint linkage;
- eligibility;
- readiness-aware matching;
- student applications;
- company review;
- application state machine;
- basic interview support;
- outcomes;
- audit;
- notifications;
- placement analytics.

### P1

- advanced matching;
- richer interview workflows;
- employer feedback analytics;
- trainable candidate workflows;
- improved opportunity intelligence;
- candidate pool recommendations;
- stronger employer-college workflows.

### P2

- expanded opportunity types;
- advanced workforce planning;
- sophisticated ranking;
- broader ecosystem integrations;
- advanced outcome prediction.

---

## 48. Definition of Done

The opportunity/application domain is production-ready when:

- every published opportunity has a valid versioned requirement basis;
- eligibility is deterministic and auditable;
- matching separates hard blockers from semantic ranking;
- application transitions are validated;
- duplicate submission is prevented transactionally;
- historical application context is reconstructable;
- object-level authorization is enforced;
- document access is protected;
- notifications cannot corrupt domain transactions;
- outcomes feed the industry feedback loop;
- analytics do not become a second source of truth;
- tests cover state transitions, concurrency, permissions, versioning and historical reproducibility;
- browser validation covers the primary student, college and company workflows.

---

## 49. Final Principle

> **Career360 should turn structured role demand into a trustworthy opportunity workflow where candidates are matched by evidence-backed capability, applications remain historically explainable, employers retain decision authority, and outcomes improve the next cycle of role definition and training.**
