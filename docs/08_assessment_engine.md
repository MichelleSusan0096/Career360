# Career360 Assessment Engine

**Document:** `docs/08_assessment_engine.md`  
**Status:** Production specification  
**Audience:** Product, backend, frontend, data, QA, platform, and AI implementation teams  
**Depends on:** `00_product_vision.md`, `01_architecture_and_invariants.md`, `02_domain_model.md`, `03_skill_competency_model.md`, `04_role_blueprint.md`, `05_readiness_matching.md`, `06_data_contracts.md`, `07_security_authorization.md`

---

## 1. Purpose

The Assessment Engine is the authoritative subsystem used to measure demonstrated capability, produce structured evidence, identify skill gaps, and feed role-specific readiness calculations.

The engine must not behave like a generic examination module. Its primary purpose is to answer:

> **What capability has been demonstrated, against which requirement, with what evidence, at what confidence and freshness?**

An assessment may contribute to readiness, but an assessment score alone is not equivalent to practical competence. The system must preserve the distinction between:

- assessment performance;
- skill or competency measurement;
- practical evidence;
- certification/course completion;
- mentor/faculty/employer evaluation;
- role readiness.

The engine therefore operates as a controlled measurement pipeline:

```text
Assessment Definition
        ↓
Versioned Questions / Tasks
        ↓
Assignment
        ↓
Attempt
        ↓
Submission
        ↓
Scoring
        ↓
Skill / Competency Evidence
        ↓
Validation + Confidence/Freshness
        ↓
Gap Analysis
        ↓
Readiness Recalculation
```

The engine must remain deterministic and auditable for authoritative scoring paths. AI may assist with authoring, normalization, explanations, or rubric suggestions, but AI must not be the sole authority for final high-impact assessment outcomes.

---

## 2. Assessment Engine Responsibilities

The Assessment Engine owns the lifecycle and rules for:

1. assessment definition;
2. assessment versioning;
3. question and task banks;
4. skill/competency alignment;
5. assessment assignment;
6. attempt management;
7. response capture;
8. scoring and rubric evaluation;
9. partial credit where explicitly configured;
10. result publication;
11. evidence creation;
12. anti-tampering and integrity controls;
13. reassessment;
14. assessment analytics;
15. role-readiness contribution calculation;
16. review and appeal workflows where enabled;
17. audit history.

It does **not** own:

- canonical skill taxonomy governance;
- Role Blueprint authoring rules;
- course catalog ownership;
- employer hiring decisions;
- final candidate selection;
- organizational identity and tenant membership.

Those domains consume Assessment Engine outputs through explicit contracts.

---

## 3. Core Design Principle: Measurement Is Evidence

Every authoritative assessment result should be traceable through the following chain:

```text
Assessment Attempt
→ Response / Submission
→ Scoring Rule or Rubric
→ Measured Skill / Competency
→ Evidence Record
→ Readiness Contribution
```

A result without traceability is not production-grade.

The engine must never reduce an assessment to a single opaque number when the configured assessment is intended to measure multiple capabilities. Per-item and per-skill breakdowns must be retained where the assessment definition supports them.

Example:

```text
Assessment: Backend Engineering Fundamentals

Overall score: 76%

Skill measurements:
- HTTP fundamentals        → 88%
- REST API design          → 79%
- Authentication           → 61%
- Error handling           → 72%
- Automated testing        → 48%

Critical role requirements:
- Authentication           → MUST
- Automated testing        → MUST
```

A candidate with a 76% overall score can therefore still have a role-blocking gap.

---

## 4. Assessment Types

Career360 supports multiple assessment modes because different capabilities require different evidence.

### 4.1 Knowledge Assessment

Measures factual, conceptual, or procedural understanding.

Examples:

- multiple choice;
- multiple response;
- true/false;
- short answer;
- structured response.

Use cases:

- technical fundamentals;
- aptitude;
- domain knowledge;
- soft-skill knowledge checks.

Knowledge assessments are useful but should not automatically imply practical competence.

### 4.2 Technical Coding / Practical Assessment

Measures the ability to perform a concrete technical task.

Examples:

- coding exercise;
- API task;
- SQL task;
- debugging scenario;
- configuration or architecture task;
- data manipulation task.

The implementation may begin with controlled evaluation strategies and later integrate isolated execution services. The initial architecture must not require a separate execution microservice before the product needs one.

### 4.3 Scenario / Case Assessment

Measures applied reasoning against a realistic scenario.

Examples:

- business case;
- system design scenario;
- incident response reasoning;
- product decision scenario.

### 4.4 Soft-Skill / Behavioral Assessment

Measures configured behavioral competencies through structured questions and scoring rubrics.

Examples:

- communication;
- teamwork;
- leadership;
- adaptability.

These outputs must be treated with appropriate caution and should expose the assessment method and confidence rather than implying absolute personality truth.

### 4.5 Industry Benchmark Assessment

Measures capability against an industry or employer-defined benchmark.

The benchmark must be versioned and tied to a source, role, organization, or benchmark profile.

### 4.6 Practical Evidence Review

Some capabilities are best measured by evaluating a submitted artifact rather than answers.

Examples:

- project repository or project artifact;
- portfolio submission;
- presentation;
- API specification;
- design document;
- internship deliverable.

This can use rubric-based human review and may later include AI-assisted reviewer support.

---

## 5. Assessment Definition

An `Assessment` is a stable business identity. A published assessment is executed through an immutable `AssessmentVersion`.

Recommended conceptual model:

```text
Assessment
  ├── identity
  ├── owner
  ├── organization scope
  ├── assessment type
  ├── status
  └── versions[]

AssessmentVersion
  ├── version number
  ├── instructions
  ├── duration policy
  ├── attempt policy
  ├── question/task set
  ├── scoring model
  ├── skill mappings
  ├── benchmark mappings
  └── publication metadata
```

### 5.1 Assessment Lifecycle

```text
DRAFT
  ↓
REVIEW
  ↓
PUBLISHED
  ↓
ACTIVE
  ↓
RETIRED
```

A previously published version must remain reproducible for historical results.

Editing an active published version in place is prohibited when the change can alter scoring, questions, timing, mappings, or interpretation. Create a new version instead.

---

## 6. Question and Task Model

Each question or task should have a stable identity plus immutable versioned content.

Core conceptual fields:

- `questionId`;
- `questionVersionId`;
- `type`;
- `prompt`;
- `options` where applicable;
- `expectedAnswer` or scoring configuration;
- `rubric` where applicable;
- `difficulty`;
- `skills`;
- `competencies`;
- `weight`;
- `isRequired`;
- `timeEstimate`;
- `authoringMetadata`;
- `reviewStatus`.

Questions should be mapped to canonical skills and, when appropriate, competencies. Mapping must never rely only on free-text labels.

---

## 7. Skill and Competency Mapping

Assessment measurements must connect to the canonical capability model defined in `03_skill_competency_model.md`.

The engine should support:

```text
Question / Task
    ↓
Skill(s)
    ↓
Competency contribution
    ↓
Assessment capability vector
```

A question may map directly to a skill or contribute to a broader competency.

Example:

```text
Task: Implement JWT validation middleware

Direct skills:
- JWT
- HTTP authentication
- backend security

Competency contribution:
- Backend API Security
```

Mappings should contain optional weights and rationale where reviewability matters.

---

## 8. Proficiency Scales

Career360 should support configurable proficiency scales while preserving a canonical internal representation.

A recommended baseline is:

| Level | Meaning |
|---|---|
| 0 | Not demonstrated |
| 1 | Foundational awareness |
| 2 | Basic applied ability |
| 3 | Independent working ability |
| 4 | Strong working ability |
| 5 | Advanced / highly capable |

The exact scale may vary by assessment or role, but any configured scale must define:

- ordinal meaning;
- score-to-level mapping;
- evidence requirements;
- interpretation guidance;
- whether a level is sufficient for a requirement.

Percent scores must not be silently treated as proficiency levels without an explicit mapping policy.

---

## 9. Scoring Architecture

Scoring is divided into three stages:

### 9.1 Raw Scoring

Determine the direct outcome from responses or evaluator input.

Examples:

```text
correct answer = 1 point
partially correct = 0.5 point
incorrect = 0 point
```

### 9.2 Normalization

Normalize the result to the assessment's configured scale.

For example:

```text
normalizedScore = earnedPoints / availablePoints × 100
```

### 9.3 Capability Mapping

Translate item-level outcomes into skill or competency measurements using the configured mapping and weights.

This stage must be deterministic for authoritative assessments.

---

## 10. Rubric-Based Scoring

For open-ended or practical submissions, the assessment may use a rubric.

A rubric should define:

- criterion;
- performance level;
- observable indicators;
- score range;
- weight;
- evidence requirement;
- reviewer guidance.

Example:

```text
Criterion: API Error Handling

0 – Missing or unsafe handling
1 – Basic handling of common errors
2 – Consistent client-safe error responses
3 – Consistent, tested, production-oriented handling
```

A reviewer may provide a score and structured comments. AI assistance may suggest a rubric-based assessment, but the final authoritative score requires an allowed human or deterministic scoring path.

---

## 11. Attempt Lifecycle

Recommended state machine:

```text
ASSIGNED
  ↓
STARTED
  ↓
IN_PROGRESS
  ↓
SUBMITTED
  ↓
SCORING
  ↓
SCORED
  ↓
PUBLISHED
```

Alternative terminal states may include:

- `ABANDONED`;
- `EXPIRED`;
- `INVALIDATED`;
- `WITHDRAWN`.

Invalidated attempts must retain an audit trail explaining the reason and actor.

---

## 12. Assignment Rules

An assessment assignment is distinct from the assessment itself.

The assignment links:

- assessment version;
- participant;
- organization context;
- role context where applicable;
- due date;
- attempt policy;
- access policy;
- invitation metadata;
- status.

Assignments may target:

- an individual student;
- a batch;
- department cohort;
- college cohort;
- selected candidates;
- role-specific candidate pools.

Bulk assignment must be transactional. Partial assignments must not leave the system in an ambiguous state.

---

## 13. Attempt Policies

The version configuration may specify:

- maximum attempts;
- time limit;
- start window;
- submission grace period;
- whether unanswered items are allowed;
- whether backtracking is allowed;
- whether a later attempt supersedes the earlier one;
- whether best score or latest valid score applies;
- reassessment cooldown.

The policy used for an attempt must be snapshotted or reconstructable from the immutable assessment version.

---

## 14. Response Capture

Response capture must be resilient to refreshes and temporary connectivity interruptions where the product experience requires it.

For long-running assessments, the frontend may save drafts or checkpoints, but the authoritative server-side state remains the source of truth.

Each response should be associated with:

- attempt;
- question version;
- response payload;
- submission sequence;
- timestamps;
- optional client metadata needed for integrity diagnostics.

The engine must distinguish:

```text
DRAFT RESPONSE
from
FINAL SUBMISSION
```

A final submission must be immutable except through an explicit administrative correction workflow.

---

## 15. Integrity and Anti-Tampering Controls

The system must prevent ordinary client manipulation from changing authoritative outcomes.

Required rules include:

- scoring must execute server-side;
- correct answers must never be exposed to the browser before allowed reveal time;
- assessment version IDs and mapping IDs must be validated server-side;
- submitted scores must never be trusted from the client;
- authorization must be checked for every attempt access and submission;
- immutable published assessment versions must be preserved;
- administrative overrides require explicit authorization and audit events.

Browser-visible timers are user-interface aids, not authoritative timing controls. Server-side timestamps determine validity.

---

## 16. Evidence Creation

A successful assessment may produce one or more evidence records.

Conceptually:

```text
AssessmentAttempt
    ↓
AssessmentResult
    ↓
SkillMeasurement / CompetencyMeasurement
    ↓
Evidence
```

Evidence should capture:

- source type = assessment;
- source reference;
- measured skill/competency;
- measured level/score;
- evidence date;
- evidence confidence;
- freshness metadata;
- organization context;
- role context where applicable;
- assessor/reviewer where applicable.

The evidence record must remain linked to its source attempt and version.

---

## 17. Assessment-to-Readiness Contribution

Assessment evidence can contribute to readiness only through the readiness rules defined in `05_readiness_matching.md`.

The flow is:

```text
Assessment Result
      ↓
Skill / Competency Evidence
      ↓
Evidence Validation
      ↓
Role Requirement Comparison
      ↓
Readiness Contribution
```

The engine itself should not permanently store a generic statement such as `candidate_is_ready = true` unless the readiness module owns that calculation.

This separation prevents stale readiness values from surviving changes to role requirements or evidence validity.

---

## 18. Reassessment

Reassessment is a first-class lifecycle rather than an overwrite operation.

A reassessment should create a new attempt and new evidence while retaining prior history.

Example:

```text
Attempt #1
Authentication → 58%
Status → GAP_IDENTIFIED

Training completed

Attempt #2
Authentication → 82%
Status → improved evidence
```

The historical first result must remain available for improvement analysis.

Readiness recalculation should consider the configured evidence selection policy rather than blindly averaging all historical attempts.

---

## 19. Evidence Freshness

Assessment evidence may become stale.

A freshness policy may depend on:

- capability type;
- role criticality;
- assessment date;
- employer policy;
- industry change rate;
- explicit expiry period.

Example:

```text
recent practical evidence + recent assessment
→ high confidence

old knowledge-only assessment
→ lower freshness
```

The system should not delete stale evidence merely because it is no longer preferred. It should preserve history and mark applicability/freshness accordingly.

---

## 20. Assessment Benchmarking

Assessment results may be compared against:

- role benchmark;
- industry benchmark;
- college benchmark;
- batch benchmark;
- department benchmark;
- historical student performance.

Benchmark definitions must include the source and version.

Example:

```text
Role requirement:
REST API Design ≥ Level 3

Student evidence:
Level 2

Gap:
1 level below target
```

Benchmarking should not expose peer comparison in a way that creates misleading certainty. Percentiles and ranks must clearly state their cohort and date.

---

## 21. Question Authoring and Review

Question authoring should use a controlled workflow:

```text
DRAFT
  ↓
AI / Author Assistance (optional)
  ↓
SCHEMA VALIDATION
  ↓
DOMAIN REVIEW
  ↓
PILOT / QA
  ↓
APPROVED
  ↓
PUBLISHED IN VERSION
```

AI-generated questions must be treated as proposals. Human/domain review is required before production publication when the question materially affects candidate evaluation.

Question quality checks should include:

- unambiguous wording;
- correct answer validation;
- skill mapping correctness;
- difficulty appropriateness;
- duplicate detection;
- accessibility;
- bias review where relevant;
- scoring reproducibility.

---

## 22. AI-Assisted Assessment Capabilities

Allowed AI assistance includes:

- generating draft questions from a role blueprint;
- proposing skill mappings;
- creating rubric drafts;
- generating assessment explanations;
- suggesting follow-up questions;
- summarizing results;
- identifying inconsistent question wording;
- detecting likely duplicate content.

Authoritative decisions must remain controlled by deterministic rules or authorized human review.

The safe pattern is:

```text
Input
 ↓
AI proposal
 ↓
Structured schema
 ↓
Validation
 ↓
Domain review / deterministic rules
 ↓
Authoritative result
```

The engine must persist enough metadata to distinguish AI-assisted content from human-authored or system-generated content.

---

## 23. Assessment Analytics

The engine should expose analytics at several levels.

### Student Level

- completion;
- score;
- skill breakdown;
- proficiency levels;
- improvement across attempts;
- identified gaps;
- evidence freshness.

### Cohort Level

- completion rate;
- average and distribution by skill;
- critical skill gaps;
- readiness contribution;
- at-risk population;
- improvement velocity.

### College Level

- department comparison;
- role readiness distribution;
- top capability gaps;
- training impact;
- reassessment improvement.

### Industry / Role Level

- candidate capability distribution;
- benchmark satisfaction;
- trainable-vs-ready pools;
- assessment-to-hiring outcomes where permitted.

Analytics must respect tenant and authorization boundaries.

---

## 24. Institutional Metrics

The Assessment Engine can provide data used by institutional metrics such as:

### Completion Rate

```text
completed assignments / assigned assignments × 100
```

### Skill Gap Score

Where a benchmark score is explicitly defined:

```text
student score / benchmark × 100
```

This metric must be interpreted carefully. A value above 100% may mean the student exceeded the benchmark; it must not be silently capped unless a product-specific visualization policy requires it.

### Improvement Velocity

A configurable measure of capability improvement across two or more dated evidence points.

The exact formula should be documented at implementation time rather than hidden inside dashboard code.

---

## 25. Academic and Industry Assessment Ownership

Assessments may be authored and owned by different actors:

| Owner | Typical purpose |
|---|---|
| College | cohort assessment |
| Department | domain-specific assessment |
| Faculty | teaching or formative assessment |
| Industry | role benchmark / recruitment assessment |
| Career360 system | standardized capability assessment |
| Learning/training provider | course-linked assessment |

Ownership affects authorization, visibility, editability, and evidence trust context.

---

## 26. Assessment Result Publication

A result becomes authoritative only after the scoring pipeline completes successfully.

Recommended states:

```text
PENDING
SCORING
READY_FOR_REVIEW
PUBLISHED
WITHHELD
INVALIDATED
```

Publication may be automatic for deterministic objective assessments. Human-reviewed assessments may require explicit release.

A published result must include a clear timestamp and assessment version.

---

## 27. Appeals and Administrative Corrections

Where required, a user or administrator may challenge an assessment result.

An appeal must not mutate the historical raw response.

Instead:

```text
Original result
   ↓
Appeal case
   ↓
Review
   ↓
Decision
   ↓
Correction / confirmation
```

Any correction must be auditable, including:

- actor;
- reason;
- previous value;
- new value;
- timestamp;
- supporting evidence.

---

## 28. Transactional Invariants

The Assessment Engine must enforce the following invariants.

### 28.1 Published Version Immutability

A published assessment version cannot be mutated in a way that changes historical interpretation.

### 28.2 Attempt Ownership

An attempt belongs to exactly one participant and one assessment version.

### 28.3 Submission Integrity

A final submission cannot be scored against a different assessment version.

### 28.4 Evidence Traceability

Every assessment-derived evidence item must reference a valid assessment result.

### 28.5 Tenant Isolation

An attempt, result, assignment, or reviewer action may only be accessed within the allowed tenant and object scope.

### 28.6 Idempotent Publication

Result publication must be safe against duplicate event delivery or retry.

### 28.7 No Client-Authoritative Scoring

The browser cannot set or override an authoritative score.

---

## 29. API Boundary

Representative REST boundaries:

```text
POST   /api/v1/assessments
GET    /api/v1/assessments/{assessmentId}
POST   /api/v1/assessments/{assessmentId}/versions
POST   /api/v1/assessment-assignments
GET    /api/v1/assessment-assignments/{assignmentId}
POST   /api/v1/attempts
GET    /api/v1/attempts/{attemptId}
PATCH  /api/v1/attempts/{attemptId}/responses
POST   /api/v1/attempts/{attemptId}/submit
GET    /api/v1/attempts/{attemptId}/result
POST   /api/v1/assessment-results/{resultId}/publish
POST   /api/v1/reassessments
```

Exact paths may evolve, but API contracts must follow the shared rules in `06_data_contracts.md`.

---

## 30. Frontend Experience Requirements

Assessment UIs must implement the shared four-state model:

```text
IDLE
LOADING
ERROR
EMPTY
```

For active attempts, additionally represent:

```text
READY_TO_START
IN_PROGRESS
SUBMITTING
SUBMITTED
RESULT_PENDING
RESULT_AVAILABLE
```

The UI should clearly distinguish:

- saved state;
- unsaved draft state;
- submission state;
- final result state.

Users must not receive false confirmation that an attempt is submitted merely because a button was clicked.

---

## 31. Accessibility and Usability

Assessment flows must support:

- keyboard navigation;
- semantic form controls;
- readable focus states;
- accessible error messages;
- sufficient response time communication;
- non-color-only status indicators;
- responsive layouts;
- recoverable navigation.

Assessment interfaces should minimize accidental submission and make irreversible actions explicit.

---

## 32. Background Jobs

Potential asynchronous workloads include:

- batch assignment creation;
- bulk scoring;
- report aggregation;
- result publication notifications;
- evidence generation;
- analytics aggregation.

Initial implementation may use the PostgreSQL-backed job queue defined in the architecture baseline. A separate queue broker should only be introduced when measurable scale or workload isolation requires it.

Jobs must be idempotent and observable.

---

## 33. Reporting Requirements

Assessment data should support reports such as:

1. student assessment report;
2. skill gap report;
3. cohort capability report;
4. department benchmark report;
5. placement readiness support report;
6. assessment completion report;
7. reassessment improvement report.

Exports must preserve the reporting date and relevant assessment/benchmark versions.

---

## 34. Testing Strategy

Minimum automated test layers:

### Unit Tests

- scoring formulas;
- mapping logic;
- attempt state transitions;
- benchmark calculations;
- validation rules.

### Integration Tests

- assessment creation;
- version publication;
- assignment transactions;
- submission and scoring;
- evidence creation;
- authorization.

### Contract Tests

- assessment APIs;
- result payloads;
- error envelopes;
- event payloads.

### End-to-End Tests

At minimum:

```text
Create assessment
→ publish version
→ assign to student
→ start attempt
→ answer
→ submit
→ score
→ publish result
→ verify skill evidence
→ verify readiness update
```

Practical assessments must include failure-path testing for invalid submission, timeout, duplicate submit, and authorization errors.

---

## 35. Observability

Important telemetry includes:

- assessment creation rate;
- assignment failures;
- attempt start rate;
- submission failure rate;
- scoring duration;
- result publication latency;
- invalidated attempts;
- evidence creation failures;
- reassessment completion;
- assessment-to-readiness update latency.

Logs must avoid sensitive response payloads unless explicitly required and safely redacted.

---

## 36. Non-Goals

The Assessment Engine is not initially responsible for:

- acting as a general-purpose LMS;
- replacing proctoring vendors;
- making automated hiring decisions;
- inferring psychological diagnoses;
- claiming competence from course attendance alone;
- maintaining the canonical labor-market ontology;
- becoming a standalone assessment SaaS independent of Career360.

Future integrations may extend capability without violating these boundaries.

---

## 37. Acceptance Criteria

The implementation is acceptable when the following are true:

- published assessment versions are immutable and reproducible;
- assignments and attempts have explicit lifecycle states;
- authoritative scores are calculated server-side;
- results can be traced to assessment version and responses;
- multi-skill assessments produce per-skill measurements where configured;
- assessment-derived evidence is linked to the result that generated it;
- reassessment preserves historical evidence;
- role readiness consumes evidence through the readiness module rather than being duplicated here;
- authorization and tenant checks cover all assessment objects;
- duplicate submission/publication is safely handled;
- APIs conform to shared data contracts;
- automated tests cover core scoring and lifecycle invariants;
- frontend validation covers complete, empty, loading, and failure states;
- AI-generated assessment content is treated as a proposal until validated and approved.

---

## 38. Implementation Priority

### P0

- assessment definition and versioning;
- objective question types;
- skill mapping;
- assignment;
- attempt lifecycle;
- scoring;
- result publication;
- evidence creation;
- reassessment;
- role-readiness integration;
- auditability;
- core analytics.

### P1

- practical/coding assessments;
- rubric review;
- stronger integrity controls;
- advanced benchmark analytics;
- cohort diagnostics;
- AI-assisted authoring and explanation;
- appeal workflow.

### P2

- advanced simulation environments;
- external proctoring integrations;
- adaptive assessment;
- psychometric research features;
- sophisticated assessment calibration pipelines.

---

## 39. Final Assessment Engine Definition

Career360's Assessment Engine is a **versioned, auditable capability-measurement system** that converts structured assessment activity into trusted evidence about skills and competencies.

Its purpose is not merely to produce marks. Its purpose is to make capability measurable, traceable, comparable to a target role, and usable for the next step in the closed loop:

```text
ROLE REQUIREMENT
      ↓
ASSESS
      ↓
MEASURE SKILLS / COMPETENCIES
      ↓
CREATE EVIDENCE
      ↓
IDENTIFY GAPS
      ↓
TRAIN
      ↓
REASSESS
      ↓
UPDATE READINESS
```

That closed loop is the reason the Assessment Engine exists within Career360.
