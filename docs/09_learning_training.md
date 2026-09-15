# Career360 Learning & Training Engine

**Document:** `docs/09_learning_training.md`  
**Status:** Production specification  
**Audience:** Product, backend, frontend, data, QA, learning, training, and platform teams  
**Depends on:** `00_product_vision.md`, `01_architecture_and_invariants.md`, `02_domain_model.md`, `03_skill_competency_model.md`, `04_role_blueprint.md`, `05_readiness_matching.md`, `06_data_contracts.md`, `07_security_authorization.md`, `08_assessment_engine.md`

---

## 1. Purpose

The Learning & Training Engine closes the gap between:

```text
REQUIRED CAPABILITY
        ↓
CURRENT CAPABILITY
        ↓
GAP
        ↓
WHAT SHOULD THE STUDENT DO NEXT?
        ↓
LEARNING / TRAINING
        ↓
PRACTICAL EVIDENCE
        ↓
REASSESSMENT
        ↓
READINESS
```

Career360 must not become a generic course marketplace whose success metric is only enrollment or completion.

Its learning system exists to answer:

> **What intervention should move this learner toward a specific role requirement, and how do we know the intervention worked?**

The Learning & Training Engine therefore treats courses as one learning primitive among several. It supports courses, learning paths, projects, labs, workshops, certifications, simulations, mentorship, and trainer-led programmes while keeping role requirements and skill gaps as the primary drivers.

---

## 2. Learning vs Training

The platform must distinguish **Learning Content** from **Training Programs**.

### Learning Content

A reusable learning asset or experience.

Examples:

- course;
- lesson;
- module;
- lab;
- project;
- workshop;
- simulation;
- certification preparation;
- mentoring session.

### Training Program

A structured intervention designed for a target role, cohort, organization, or capability gap.

A training program may compose multiple learning items plus:

- target role;
- target skills;
- target proficiency;
- cohort;
- trainers;
- schedule;
- eligibility;
- attendance;
- assessments;
- practical evidence;
- reassessment;
- outcome metrics.

This distinction is essential because a generic course and an employer-oriented training program have different business purposes.

---

## 3. Core Principle: Learning Must Be Gap-Driven

Learning recommendations should originate from capability gaps whenever possible.

Example:

```text
Target Role: Graduate Backend Engineer

MUST skills:
- HTTP
- REST API Design
- Authentication
- SQL
- Automated Testing

Student evidence:
- HTTP             → Level 3
- REST API Design  → Level 2
- Authentication   → Level 1
- SQL              → Level 3
- Testing          → Level 1

Priority gaps:
1. Authentication
2. Automated Testing
3. REST API Design

Recommended intervention:
- Backend Security Lab
- API Testing Project
- REST API Design Workshop
```

The engine should not recommend ten unrelated courses merely because they are popular.

---

## 4. Learning Object Model

A reusable learning item should have a stable identity and versioned content.

Conceptual model:

```text
LearningItem
  ├── identity
  ├── type
  ├── provider
  ├── title / description
  ├── duration
  ├── level
  ├── skills
  ├── competencies
  ├── prerequisites
  ├── outcomes
  ├── evidence requirements
  ├── delivery mode
  ├── cost
  ├── availability
  └── versions[]
```

Supported types may include:

- `COURSE`;
- `MODULE`;
- `LESSON`;
- `LAB`;
- `PROJECT`;
- `WORKSHOP`;
- `SIMULATION`;
- `MENTORING`;
- `CERTIFICATION_PREP`;
- `CERTIFICATION`.

A learning item may be internally hosted or externally linked.

---

## 5. Learning Provider Model

Providers may include:

- Career360-managed content;
- colleges;
- companies;
- industry experts;
- learning partners;
- certification providers;
- external education platforms.

A provider record should expose enough metadata to understand source, ownership, trust context, and integration method.

Provider integration must not force the platform to depend on one vendor's identity or API model.

---

## 6. Course Planner as a Career360 Feature

The existing Course Planner research should be treated as a feature module inside Career360, not as a separate product identity.

The unified account model is:

```text
Career360 User
   ↓
Role / Membership
   ↓
Learning & Training capabilities
```

There must be no duplicate student accounts merely for course enrollment.

Course Planner capabilities may support:

- admin course management;
- student browsing;
- enrollment;
- payment status;
- progress tracking;
- tutor/trainer workflows;
- completion records;
- profile data linked to the primary Career360 user.

The production domain should use the broader Learning & Training model rather than creating an isolated second LMS identity system.

---

## 7. Learning Path

A `LearningPath` is an ordered or rule-based sequence of learning items designed to achieve a capability target.

Example:

```text
Learning Path: Backend Engineer Readiness

1. HTTP Fundamentals
2. REST API Design
3. Authentication Lab
4. SQL Practice
5. API Testing Project
6. Capstone Backend Project
7. Reassessment
```

A learning path may contain:

- required items;
- optional items;
- branching rules;
- prerequisites;
- completion conditions;
- target skills;
- target competency levels.

Learning paths can be role-specific, cohort-specific, or generic.

---

## 8. Training Program

A `TrainingProgram` is the operational unit for coordinated skill development.

Required conceptual fields include:

- program identity;
- organization;
- target role(s);
- target skills;
- target competencies;
- learner cohort;
- trainer(s);
- learning items;
- schedule;
- duration;
- enrollment rules;
- attendance policy;
- evaluation method;
- evidence requirements;
- reassessment plan;
- status.

Recommended lifecycle:

```text
DRAFT
  ↓
PLANNED
  ↓
OPEN
  ↓
IN_PROGRESS
  ↓
COMPLETION_PENDING
  ↓
COMPLETED
```

Cancellation and archival states may be added without destroying historical records.

---

## 9. Training Program Creation Flow

The preferred flow for institutional or industry-led training is:

```text
Select Role / Capability Target
        ↓
Identify Cohort
        ↓
Analyze Skill Gaps
        ↓
Prioritize Critical Gaps
        ↓
Select Learning Interventions
        ↓
Allocate Trainers
        ↓
Schedule Program
        ↓
Enroll / Assign Learners
        ↓
Track Progress
        ↓
Collect Practical Evidence
        ↓
Reassess
        ↓
Measure Improvement
        ↓
Update Readiness
```

This is the operational manifestation of Career360's closed-loop model.

---

## 10. Training Gap Selection

The engine should support multiple selection signals:

### Role Priority

MUST requirements receive higher priority than SHOULD or COULD requirements.

### Gap Magnitude

Larger distance from target proficiency can increase priority.

### Role Criticality

Blocker requirements may take precedence even when their numeric gap is modest.

### Evidence Confidence

A weak or stale measurement may require validation before assigning a heavy training intervention.

### Cohort Concentration

If many students share the same gap, a cohort program may be more efficient than individual learning.

### Time to Opportunity

A company or college may prioritize gaps that must be closed before an upcoming hiring cycle or internship.

---

## 11. Recommendation Model

Recommendations should connect explicitly to skills, competencies, and target outcomes.

Conceptually:

```text
Recommendation
  ├── learner
  ├── target role
  ├── target skill / competency
  ├── observed gap
  ├── recommended learning item(s)
  ├── expected duration
  ├── expected evidence
  ├── priority
  └── rationale
```

The recommendation engine should prefer explainability over opaque ranking.

Example explanation:

> REST API Design is below the role's required proficiency. This project-based lab is recommended because it directly practices endpoint design, validation, error handling, and automated API testing.

---

## 12. AI-Assisted Recommendations

AI may help propose learning interventions by reasoning over:

- target role;
- skill gaps;
- learner preferences;
- available catalog;
- time constraints;
- prerequisite relationships;
- historical completion/outcome signals.

The safe workflow is:

```text
Gap Data
   ↓
AI Proposal
   ↓
Structured Recommendation Schema
   ↓
Catalog / Eligibility Validation
   ↓
Business Rules
   ↓
Published Recommendation
```

AI must not silently invent unavailable courses, certifications, trainers, or outcomes.

Where the AI proposes external content, the system must mark the recommendation as externally sourced or requiring validation.

---

## 13. Learning Eligibility

Enrollment may depend on:

- required prerequisites;
- target learner status;
- cohort membership;
- organization scope;
- age/eligibility policy where relevant to the program;
- seat limits;
- schedule conflicts;
- payment status;
- employer sponsorship.

Eligibility rules must be enforced server-side.

---

## 14. Enrollment Lifecycle

Recommended state machine:

```text
RECOMMENDED
  ↓
ASSIGNED / ENROLLED
  ↓
STARTED
  ↓
IN_PROGRESS
  ↓
COMPLETION_PENDING
  ↓
COMPLETED
```

Alternative terminal states:

- `WITHDRAWN`;
- `EXPIRED`;
- `FAILED`;
- `CANCELLED`.

Enrollment history must be preserved for analytics and auditability.

---

## 15. Progress Tracking

Progress should support multiple dimensions where applicable.

### Content Progress

- lessons completed;
- modules completed;
- labs completed;
- project submitted.

### Time / Participation

- attended sessions;
- learning time;
- mentoring sessions.

### Assessment Progress

- pre-assessment;
- formative assessment;
- final assessment;
- reassessment.

### Evidence Progress

- practical artifact uploaded;
- project reviewed;
- trainer evaluation completed.

A single progress percentage may be useful for UI, but underlying completion rules must remain explicit.

---

## 16. Completion Rules

A learning item is complete only when its configured completion conditions are met.

Examples:

```text
Course:
- all required modules complete
- final assessment passed

Lab:
- task submitted
- automated checks passed

Workshop:
- attendance requirement met
- participation checkpoint completed

Project:
- artifact submitted
- rubric review completed
```

Completion must not be inferred merely from opening the content.

---

## 17. Certification Handling

Certifications are valuable evidence, but the platform must preserve the distinction between certification and demonstrated practical capability.

A certification record may include:

- provider;
- credential name;
- credential identifier;
- issue date;
- expiry date;
- verification status;
- credential URL where appropriate;
- claimed skills;
- verified skills.

A certification may contribute evidence confidence, but should not automatically satisfy a practical requirement unless the role or evidence policy explicitly permits it.

---

## 18. Practical Learning and Evidence

Career360's differentiator depends on practical evidence.

Learning items should therefore be able to declare expected evidence.

Examples:

```text
Learning Item: REST API Project

Expected evidence:
- API specification
- implementation artifact
- test results
- evaluator rubric
```

A project completion event may create an evidence candidate. It becomes authoritative only after the configured verification process succeeds.

---

## 19. Evidence Trust Levels

Learning-derived evidence may carry a source/trust context.

Example conceptual levels:

```text
SELF_REPORTED
PARTNER_REPORTED
SYSTEM_VERIFIED
TRAINER_VERIFIED
EMPLOYER_VERIFIED
```

The exact trust model may evolve, but the design must preserve provenance.

A learner claiming completion and a verified employer evaluation are not equivalent evidence.

---

## 20. Trainer and Tutor Model

Trainers/tutors may be:

- faculty;
- industry professionals;
- partner instructors;
- Career360 instructors;
- approved external tutors.

A trainer profile should be linked to the main Career360 identity while exposing training-specific attributes.

Potential attributes:

- expertise skills;
- competencies;
- certifications;
- experience;
- availability;
- programs handled;
- organization association.

Trainer assignment should be authorized and auditable.

---

## 21. Trainer Allocation

Trainer allocation should consider:

- target skill/competency match;
- program requirements;
- availability;
- schedule;
- organization scope;
- workload;
- specialization.

AI may rank possible trainers, but the final assignment must obey server-side authorization and availability rules.

Example:

```text
Program: Backend Security Bootcamp

Required skills:
- Authentication
- JWT
- API Security

Trainer candidates:
A → strong match, available
B → moderate match, unavailable
C → strong match, overloaded

Recommended:
A
```

---

## 22. Cohort Training

The engine must support the institutional hierarchy:

```text
College
  ↓
Department
  ↓
Batch / Cohort
  ↓
Student
```

Training can be attached at any appropriate scope.

A department-wide program may contain multiple batches, while individual students may still receive additional targeted interventions.

---

## 23. Individual Learning Plans

Each student may have an individualized learning plan derived from role targets and evidence.

Conceptual structure:

```text
Student Learning Plan
  ├── target role(s)
  ├── current capability snapshot
  ├── prioritized gaps
  ├── learning recommendations
  ├── active enrollments
  ├── practical evidence
  ├── reassessment plan
  └── readiness progress
```

The plan should be recalculable when:

- target role changes;
- new evidence arrives;
- skills improve;
- learning items become unavailable;
- role blueprint changes materially.

Historical snapshots should remain accessible when needed for reporting.

---

## 24. Role-Specific Learning Roadmap

A learning roadmap should answer:

```text
Where am I?
→ Where am I trying to go?
→ What gaps block me?
→ What should I learn?
→ What evidence should I produce?
→ When should I reassess?
```

This roadmap should be role-aware rather than simply showing a list of trending courses.

---

## 25. Learning Recommendation Priority

A recommendation priority may be calculated from explicit signals such as:

```text
priority =
  role_requirement_priority
  + blocker_weight
  + gap_magnitude
  + cohort_demand
  + opportunity_urgency
  - prerequisite_penalty
```

The exact formula should remain configurable and documented. Avoid burying business logic inside frontend ranking code.

A recommendation must expose its reason in structured form.

---

## 26. Course / Learning Path Versioning

Learning content can change over time.

A learning item that materially changes completion criteria, content, or outcome mapping should receive a new version.

Historical enrollments should retain enough information to determine:

- which version was taken;
- what completion policy applied;
- what evidence was produced;
- what provider/version was involved.

The platform must avoid silently rewriting historical learner records when catalog content is updated.

---

## 27. External Learning Integrations

Future integrations may connect learning providers through standard adapters.

Typical capabilities include:

- catalog synchronization;
- learner enrollment;
- progress sync;
- completion webhook;
- credential verification.

The core domain model must remain provider-neutral.

Preferred abstraction:

```text
Career360 LearningItem
      ↕
Provider Adapter
      ↕
External Provider
```

A provider outage must not corrupt the Career360 learning record.

---

## 28. Completion Webhooks

External completion webhooks must be:

- authenticated;
- signature-verified where supported;
- idempotent;
- schema-validated;
- mapped to a known learner and learning item;
- auditable.

Repeated delivery must not create duplicate completion records.

The webhook should produce an event that can trigger:

```text
completion
   ↓
progress update
   ↓
credential/evidence update
   ↓
readiness recalculation candidate
```

---

## 29. Training Attendance

Trainer-led programs may require attendance tracking.

Attendance should be modeled separately from completion because:

```text
attended ≠ learned ≠ competent ≠ ready
```

Attendance can contribute to participation records but must not automatically create skill evidence unless the program's verification rules explicitly support that inference.

---

## 30. Learning Assessment Integration

Learning and Assessment are connected through explicit contracts.

Typical flow:

```text
Learning Module
      ↓
Formative Assessment
      ↓
Progress Decision
      ↓
Final Assessment
      ↓
Practical Evidence
      ↓
Reassessment
```

The Assessment Engine defined in `08_assessment_engine.md` remains the authority for assessment lifecycle and scoring.

The Learning Engine consumes those outcomes to determine progress or next steps.

---

## 31. Training-to-Reassessment Loop

Every serious training program aimed at role readiness should define an outcome verification plan.

Example:

```text
Before training:
Authentication → Level 1

Training:
- JWT workshop
- secure API lab
- backend security project

After training:
- practical evidence review
- reassessment

Result:
Authentication → Level 3
```

The platform should surface this improvement explicitly.

Training completion without outcome evidence is not enough to claim the training worked.

---

## 32. Learning Outcomes

Each learning item may declare outcomes such as:

- skill introduced;
- skill reinforced;
- target proficiency;
- competency contribution;
- expected artifact;
- assessment outcome.

Outcomes should be expressed using canonical skills/competencies wherever possible rather than only free text.

---

## 33. Training Effectiveness

Career360 should eventually measure:

### Participation

```text
enrolled
→ started
→ completed
```

### Capability Improvement

```text
post-training proficiency - pre-training proficiency
```

### Readiness Improvement

```text
before → GAP_IDENTIFIED

after  → PROVISIONALLY_READY / READY
```

### Opportunity Outcome

Where privacy and authorization permit:

```text
training
→ readiness
→ application
→ interview
→ hire / internship
```

This creates measurable evidence of learning impact rather than vanity metrics.

---

## 34. Training Feedback

Feedback may be collected from:

- learner;
- trainer;
- faculty;
- institution;
- employer.

Feedback fields should separate:

- experience satisfaction;
- content usefulness;
- trainer quality;
- practical usefulness;
- observed skill improvement;
- employer relevance.

A five-star rating is not a substitute for capability outcome measurement.

---

## 35. Employer-Driven Training

Companies should be able to express a requirement such as:

```text
Role: Graduate Backend Engineer

Current cohort state:
- 62% satisfy SQL benchmark
- 41% satisfy API testing benchmark
- 23% satisfy authentication benchmark

Program request:
Close the three gaps before hiring cycle.
```

Career360 can then support:

```text
Role Blueprint
→ cohort capability matrix
→ training program
→ trainer allocation
→ evidence
→ reassessment
→ ready pool
```

This is a core differentiator over a generic course marketplace.

---

## 36. Training Program Templates

Organizations should be able to save reusable training templates.

Example:

```text
Template: Backend Fresher Readiness

Modules:
- HTTP / REST
- SQL
- Authentication
- Testing
- Git / collaboration
- Capstone project

Reassessment:
- technical assessment
- practical project review
```

A template must remain versionable so historical programs remain interpretable.

---

## 37. Learning Partner Enrollment

Learning partners may offer courses or certifications that are linked to Career360 recommendations.

Partner enrollment should record:

- learner;
- partner;
- learning item;
- enrollment identifier;
- timestamps;
- price/cost information where relevant;
- sponsored/paid/free status;
- progress synchronization status.

A payment record does not equal an enrollment completion or skill outcome.

---

## 38. Payments and Subscription Boundaries

Where Career360 monetizes learning, billing must remain a distinct concern from learning completion.

Conceptual relation:

```text
Learning Enrollment
        ↕
Billing / Payment
```

States should distinguish:

- payment pending;
- paid;
- refunded;
- enrollment active;
- enrollment cancelled;
- learning completed.

Do not derive learning progress solely from payment state.

---

## 39. Notifications

Learning events may produce notifications such as:

- recommendation available;
- enrollment confirmed;
- session reminder;
- assignment due;
- assessment due;
- completion recorded;
- reassessment available;
- training program changed.

Notifications should be emitted through the platform's standard notification abstraction and should not embed business logic inside the notification provider.

---

## 40. Search and Discovery

Learning discovery should support structured filters such as:

- skill;
- competency;
- role;
- level;
- duration;
- delivery mode;
- provider;
- price;
- certification;
- language;
- availability.

Semantic search may complement structured filtering, but structured taxonomy and authorization remain authoritative.

PostgreSQL full-text search, `pg_trgm`, and vector similarity through `pgvector` may support discovery without requiring a dedicated search platform initially.

---

## 41. Learning Marketplace Boundaries

The initial product should not attempt to compete broadly with general-purpose learning marketplaces.

The differentiating layer is:

```text
role target
→ gap
→ learning intervention
→ evidence
→ reassessment
→ readiness
```

The marketplace/catalog exists to support this loop.

Popularity, ratings, and catalog size may influence discovery but should not replace role-fit and gap-fit signals.

---

## 42. AI Learning Assistant Boundaries

Potential AI capabilities include:

- explain a skill gap;
- suggest a learning plan;
- personalize sequencing;
- explain why a course was recommended;
- summarize course material supplied through permitted sources;
- answer learning questions;
- draft practice exercises;
- suggest projects aligned to missing skills.

The assistant must not:

- falsely claim a learner completed content;
- fabricate course availability;
- fabricate trainer credentials;
- award authoritative proficiency without evidence;
- override eligibility or authorization rules;
- make final hiring decisions.

---

## 43. Role Blueprint Integration

Role Blueprints are the primary target definition for role-driven learning.

Learning recommendations should consume:

- role skills;
- target proficiency;
- MUST / SHOULD / COULD priority;
- competency requirements;
- evidence requirements;
- practical evidence requirements;
- readiness conditions.

Example:

```text
Role requirement:
Authentication → MUST → Level 3 → practical evidence required

Learning response:
1. Secure API Authentication Lab
2. JWT Implementation Project
3. Practical Review
4. Reassessment
```

This connection must be explicit in both data and UI.

---

## 44. Readiness Integration

Training affects readiness indirectly through new evidence.

Correct flow:

```text
TRAINING COMPLETION
       ↓
NEW EVIDENCE / ASSESSMENT
       ↓
EVIDENCE VALIDATION
       ↓
READINESS ENGINE
       ↓
UPDATED STATUS
```

Incorrect flow:

```text
COURSE COMPLETED
       ↓
READY = TRUE
```

The second flow is prohibited because it confuses participation with competence.

---

## 45. Organization and College Reporting

Institutions should be able to see:

- top cohort gaps;
- training programs created;
- enrollment/completion;
- capability improvement;
- reassessment improvement;
- readiness movement;
- program impact by department;
- training demand by role.

Industry users may see permitted results such as:

- readiness of selected cohorts;
- training progress for sponsored programs;
- capability changes after training;
- employer feedback outcomes.

Student views should emphasize personal actionability rather than exposing unnecessary peer data.

---

## 46. Training Analytics

Useful metrics include:

### Learning Completion Rate

```text
completed enrollments / active enrollments × 100
```

### Training Completion Rate

```text
completed participants / enrolled participants × 100
```

### Skill Improvement

Measured from dated evidence before and after intervention.

### Readiness Conversion

```text
participants moved from GAP_IDENTIFIED / IN_TRAINING
→ PROVISIONALLY_READY / READY
```

### Training Impact

A configured measure combining participation, capability improvement, and outcome movement.

The product must document metric definitions centrally rather than calculating them inconsistently across dashboards.

---

## 47. Data Integrity Rules

The Learning & Training Engine must enforce:

### 47.1 Historical Versioning

Past enrollments retain their learning item version or reconstructable content context.

### 47.2 Completion Integrity

Completion cannot be client-forged.

### 47.3 Evidence Provenance

Learning-derived evidence references the exact learning activity and verification event that created it.

### 47.4 Training Scope

Program membership, trainer access, and learner records obey tenant and organizational scope.

### 47.5 No Implicit Competence

Learning completion must not automatically satisfy practical capability requirements.

### 47.6 Idempotent Sync

External progress/completion synchronization must be safe for duplicate webhook/event delivery.

### 47.7 Transactional Enrollment

Enrollment plus any linked allocation, seat reservation, or payment state change must be handled consistently according to the domain transaction boundary.

---

## 48. API Boundary

Representative REST boundaries:

```text
POST   /api/v1/learning-items
GET    /api/v1/learning-items
GET    /api/v1/learning-items/{learningItemId}
POST   /api/v1/learning-paths
GET    /api/v1/learning-paths/{pathId}
POST   /api/v1/enrollments
GET    /api/v1/enrollments/{enrollmentId}
PATCH  /api/v1/enrollments/{enrollmentId}/progress
POST   /api/v1/enrollments/{enrollmentId}/complete
POST   /api/v1/training-programs
GET    /api/v1/training-programs/{programId}
POST   /api/v1/training-programs/{programId}/participants
POST   /api/v1/training-programs/{programId}/trainers
POST   /api/v1/training-programs/{programId}/reassessment
POST   /api/v1/provider-webhooks/{provider}/completion
```

Exact route naming may evolve; all APIs must follow the common envelope, validation, authorization, idempotency, and error rules in `06_data_contracts.md` and `07_security_authorization.md`.

---

## 49. Frontend Experience Requirements

Learning views must implement the common state model:

```text
IDLE
LOADING
ERROR
EMPTY
```

Additional domain states may include:

```text
RECOMMENDED
ENROLLED
IN_PROGRESS
COMPLETION_PENDING
COMPLETED
LOCKED
EXPIRED
```

Student experience should make the relationship visible:

```text
Target Role
   ↓
Your Gap
   ↓
Recommended Learning
   ↓
Evidence to Produce
   ↓
Reassessment
```

This is preferable to presenting an unrelated catalog-first interface.

---

## 50. Trainer Experience Requirements

Trainer dashboards should support:

- assigned programs;
- upcoming sessions;
- learner roster;
- attendance;
- assignments;
- feedback;
- practical evidence review;
- reassessment scheduling;
- completion status.

Trainer actions must be scoped to programs and learners the trainer is authorized to access.

---

## 51. Student Experience Requirements

A student should be able to see:

- target role;
- readiness status;
- top gaps;
- recommended next actions;
- active learning;
- progress;
- evidence collected;
- reassessment readiness;
- updated capability after training.

The design should avoid overwhelming learners with every possible course. Prioritized next actions are more important than catalog breadth.

---

## 52. College Experience Requirements

College users should be able to:

- view role demand;
- inspect cohort capability gaps;
- create training programs;
- select learning interventions;
- assign faculty/trainers;
- track completion;
- compare pre/post training capability;
- trigger reassessment;
- monitor readiness movement.

The college view should support the hierarchy:

```text
College → Department → Batch → Student
```

---

## 53. Company Experience Requirements

Companies may use the learning/training engine to:

- request capability development;
- sponsor training;
- define role-aligned programs;
- nominate cohorts;
- provide trainers or mentors;
- monitor approved program outcomes;
- review readiness changes;
- provide employer feedback.

Company access must be limited to the students/cohorts/programs within the relevant authorization scope.

---

## 54. Background Jobs

Asynchronous work may include:

- catalog synchronization;
- completion synchronization;
- recommendation generation;
- progress aggregation;
- reminder notifications;
- training report generation;
- readiness recalculation triggers;
- partner credential verification.

The initial architecture may use the PostgreSQL-backed job queue and Spring workers. A separate broker should be introduced only when justified by measurable load or delivery requirements.

---

## 55. Caching and Search

Initial caching may use Caffeine for high-read local application data such as:

- catalog metadata;
- frequently used taxonomy lookups;
- static program metadata.

Cache entries must not become the source of truth.

PostgreSQL remains authoritative for transactional learning state.

---

## 56. Payments Integration Boundary

Learning payments should integrate through an adapter boundary.

```text
Career360 Billing Domain
        ↓
Payment Adapter
        ↓
Provider
```

The Learning Engine consumes a validated payment/enrollment status. It should not embed gateway-specific business logic throughout course services.

---

## 57. Testing Strategy

### Unit Tests

- enrollment lifecycle;
- completion rules;
- recommendation priority;
- prerequisite validation;
- progress calculations;
- trainer matching constraints.

### Integration Tests

- course creation;
- learning-path creation;
- enrollment;
- progress update;
- completion;
- training participant assignment;
- evidence creation;
- authorization.

### Contract Tests

- provider webhooks;
- learning APIs;
- completion events;
- recommendation payloads.

### End-to-End Test

A minimum golden flow:

```text
Role selected
→ gaps identified
→ learning recommended
→ student enrolled
→ progress tracked
→ project submitted
→ evidence verified
→ reassessment completed
→ readiness updated
```

The golden flow must validate both successful and failure paths.

---

## 58. Observability

Important signals include:

- recommendation generation latency;
- catalog synchronization status;
- enrollment success/failure;
- progress sync delay;
- completion webhook failures;
- training completion rate;
- trainer assignment failures;
- reassessment conversion;
- readiness update latency after learning outcomes.

Logs and telemetry must not expose unnecessary learner-sensitive information.

---

## 59. Privacy and Data Boundaries

Learning data can reveal educational progress and should be treated as protected personal information within the application's security model.

The system must distinguish:

- learner-private data;
- college-authorized data;
- trainer-authorized data;
- company-authorized sponsored-program data;
- aggregate analytics.

Cross-organization visibility must never be granted merely because a learning item is public.

---

## 60. Non-Goals

The initial Learning & Training Engine is not intended to:

- replace large general-purpose LMS products;
- act as a full content authoring studio for every media type;
- guarantee employment from course completion;
- automatically certify real-world competence without evidence;
- operate as a standalone learning marketplace divorced from role readiness;
- introduce a separate microservice architecture solely for catalog scale.

---

## 61. Acceptance Criteria

The implementation is acceptable when:

- learning items and versions are explicitly modeled;
- courses are part of Career360 rather than a duplicate platform identity;
- learning recommendations can reference target roles and skill gaps;
- training programs can target roles, skills, competencies, and cohorts;
- learners can enroll and track progress;
- completion criteria are explicit and server-validated;
- certifications are represented as evidence with provenance;
- practical learning can produce evidence candidates;
- training completion does not directly mark a learner as role-ready;
- reassessment is integrated with the Assessment Engine;
- readiness updates occur through the readiness engine;
- provider integrations are adapter-based and idempotent;
- trainer assignment is authorized and auditable;
- institutional and company scopes are respected;
- dashboards expose pre/post outcome movement rather than only completion counts;
- AI recommendations are validated and cannot fabricate inventory or authoritative outcomes;
- automated tests cover the critical learning-to-readiness lifecycle.

---

## 62. Implementation Priority

### P0

- learning item catalog;
- learning paths;
- enrollment;
- progress;
- completion;
- skill/competency tagging;
- recommendations from identified gaps;
- student learning roadmap;
- training program basics;
- trainer assignment basics;
- practical evidence linkage;
- assessment/reassessment integration;
- core analytics.

### P1

- partner integrations;
- certification verification;
- advanced trainer allocation;
- employer-sponsored training;
- advanced recommendation ranking;
- pre/post impact analytics;
- richer mentor workflows;
- payment/subscription integration.

### P2

- large-scale learning marketplace capabilities;
- adaptive learning;
- advanced simulation infrastructure;
- sophisticated personalized sequencing;
- cross-organization marketplace economics;
- advanced workforce-learning optimization.

---

## 63. Final Learning & Training Definition

Career360's Learning & Training Engine is a **role-aware, evidence-oriented capability development system**.

It turns a diagnosed gap into a structured intervention, then verifies whether the intervention actually improved capability.

The canonical loop is:

```text
ROLE BLUEPRINT
      ↓
CAPABILITY GAP
      ↓
LEARNING / TRAINING PLAN
      ↓
ENROLL / ASSIGN
      ↓
LEARN / PRACTICE
      ↓
PRACTICAL EVIDENCE
      ↓
REASSESS
      ↓
READINESS
      ↓
OPPORTUNITY / OUTCOME
      ↓
FEEDBACK
      ↺
```

The product should optimize for **measurable readiness movement**, not course volume.
