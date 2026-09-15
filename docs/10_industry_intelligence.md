# Career360 — Industry Intelligence Specification

**Document:** `docs/10_industry_intelligence.md`  
**Status:** Product/Engineering Domain Specification  
**Applies to:** Industry demand ingestion, job-description intelligence, role/skill normalization, demand signals, trend analysis, employer feedback and industry-to-academia planning  
**Primary owner:** Product + Domain Engineering  
**Related documents:** `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/03_skill_competency_model.md`, `docs/04_role_blueprint.md`, `docs/05_readiness_matching.md`, `docs/06_data_contracts.md`, `docs/07_security_authorization.md`

---

## 1. Purpose

Industry Intelligence is the demand-side learning layer of Career360.

Its responsibility is to convert heterogeneous industry observations into traceable, normalized and decision-useful signals that can inform:

- Role Blueprints
- canonical skills and competencies
- assessment planning
- learning/training priorities
- college cohort planning
- opportunity discovery
- employer feedback loops
- workforce-readiness reporting

Career360 must not treat a raw job description, AI extraction, search result or aggregate trend as authoritative domain truth by itself.

The core pipeline is:

```text
Raw Source
    ↓
Ingestion
    ↓
Extraction
    ↓
Normalization
    ↓
Canonical Skill Mapping
    ↓
Role Mapping
    ↓
Aggregation
    ↓
Demand Signal
    ↓
Trend / Intelligence View
    ↓
Human / Business Validation
    ↓
Product Decision
```

---

## 2. Product Principle

> **Industry intelligence must be traceable from a reported market signal back to its source, observation context, normalization decisions and confidence.**

Every material intelligence output should answer:

1. Where did the signal come from?
2. When was it observed?
3. What role, skill, competency or employer context does it represent?
4. How was the raw information normalized?
5. What confidence is attached to the interpretation?
6. What population or sample supports the aggregate?
7. How fresh is the signal?
8. Is the result authoritative, derived, or proposed?
9. What decision is the signal allowed to influence?

---

## 3. Intelligence Scope

Career360 may process the following source classes.

| Source | Example | Primary use |
|---|---|---|
| Employer role definition | Company-defined Graduate Backend Engineer | Authoritative role requirements |
| Job description | Uploaded or approved JD | Role/skill extraction |
| Recruitment outcomes | Selected/rejected/hired outcomes | Outcome intelligence |
| Employer feedback | Post-internship or post-hire evaluation | Capability/outcome signals |
| Historical platform signals | Aggregated Career360 usage | Product demand trends |
| Approved external industry data | Structured market source | Trend/context |
| Training outcomes | Assessment before/after training | Intervention intelligence |

External sources should be used only where they are lawfully and operationally available to the product.

---

## 4. Signal Provenance

An `IndustrySignal` must retain provenance metadata sufficient for reconstruction.

Minimum conceptual fields:

```text
signal_id
tenant_id / scope
source_type
source_reference
source_name
observed_at
ingested_at
context
role_reference
raw_payload_reference
normalized_payload_reference
confidence
status
created_by / system_actor
```

`source_reference` may point to an uploaded document, employer record, source identifier or internally generated observation.

The raw source and normalized interpretation must remain distinguishable.

---

## 5. Raw Source Model

Raw inputs are immutable or append-only from the intelligence domain's perspective.

A raw source may include:

- source text
- uploaded JD/document
- structured employer role input
- employer feedback form
- historical outcome record
- approved external dataset snapshot

Raw source records should preserve:

- acquisition time
- source identity
- content hash where applicable
- source version or document version where available
- tenant/organization context
- processing status

The system must not silently overwrite historical raw inputs when normalization rules change.

---

## 6. Job Description Intelligence

A JD may contain:

- role title
- summary
- responsibilities
- required skills
- preferred skills
- qualifications
- experience expectations
- behavioral competencies
- tools/technologies
- domain context
- location/work mode
- eligibility constraints
- evidence expectations

Career360 should transform this into a **Role Blueprint proposal**, not directly mutate an approved blueprint.

```text
JD
 ↓
AI / deterministic extraction
 ↓
Structured proposal
 ↓
Schema validation
 ↓
Canonical skill normalization
 ↓
Business validation
 ↓
Role Blueprint draft/revision
```

---

## 7. AI-Assisted Extraction

AI may assist with:

- role/title extraction
- responsibility extraction
- skill identification
- competency inference
- synonym detection
- initial MUST/SHOULD/COULD proposal
- ambiguity identification
- structured summary generation

AI output is **proposed intelligence** until it passes domain validation.

Required pattern:

```text
Raw Input
   ↓
AI Proposal
   ↓
Schema Validation
   ↓
Canonicalization
   ↓
Domain Validation
   ↓
Human / Policy Approval
   ↓
Authoritative Domain Record
```

The AI layer must never:

- silently create a canonical skill without governance;
- silently modify published role requirements;
- decide candidate eligibility;
- decide final hiring;
- assign authoritative proficiency from text alone;
- convert a semantic similarity score directly into readiness.

---

## 8. Skill Normalization Pipeline

Raw skill terms must be resolved against the canonical Skill Taxonomy.

Example:

```text
"Spring Boot"
"Spring framework"
"Spring Boot backend"

        ↓

Canonical Skill: Spring Boot
```

Normalization may involve:

1. lexical normalization;
2. alias lookup;
3. context analysis;
4. canonical skill match;
5. confidence assignment;
6. manual review where ambiguous.

The distinction between **canonicalization confidence** and **evidence confidence** must be preserved.

---

## 9. Ambiguity Handling

The system must not blindly merge terms that may represent different capabilities.

Examples of ambiguity:

```text
Java
JavaScript

SQL
MySQL

AWS
AWS Lambda

Python
Python for Data Science
```

The normalization layer should support:

```text
CANONICAL_MATCH
ALIAS_MATCH
CONTEXT_MATCH
AMBIGUOUS
UNRESOLVED
```

Ambiguous and unresolved terms must remain visible to reviewers rather than being silently discarded.

---

## 10. Role Mapping

Industry signals can be associated with:

- a known Role;
- an existing Role Blueprint Version;
- a proposed new Role;
- an occupation family;
- a role cluster.

Prefer structured role identity over free-text title matching.

For example:

```text
"Backend Engineer"
"Graduate Backend Engineer"
"Junior Java Developer"
```

may be related, but they must not automatically become one role definition.

Role mapping should retain the relationship and confidence rather than erase the source title.

---

## 11. Demand Signal

A `DemandSignal` is a derived representation of repeated or significant industry observations.

Possible dimensions:

- skill demand;
- competency demand;
- role demand;
- technology demand;
- qualification demand;
- evidence demand;
- training demand;
- employer outcome signal.

A signal should identify its aggregation window and population.

Example:

```text
Skill: REST API Development
Role family: Backend Engineering
Window: 2026-Q3
Observed opportunities: N
Distinct employers: M
Demand level: derived
Confidence: C
```

Exact thresholds are policy/configuration, not UI constants.

---

## 12. Aggregation Rules

Aggregation must preserve denominator and sampling context.

Avoid reporting:

> "Python is highly demanded."

Prefer a structured statement such as:

```text
Within the defined source population and observation window,
Python appeared in X of Y normalized role observations.
```

Where feasible, retain:

- source count;
- distinct employer count;
- opportunity count;
- normalized observation count;
- observation window;
- role family;
- geography/context;
- confidence.

Derived analytics must not imply broader market coverage than the underlying source population supports.

---

## 13. Trend Detection

Trend intelligence may compare demand signals across time windows.

Conceptually:

```text
Current window
       vs
Previous window
       vs
Historical baseline
```

Possible classifications:

```text
INCREASING
STABLE
DECREASING
EMERGING
INSUFFICIENT_DATA
```

Trend calculations should be deterministic and reproducible from stored signal snapshots.

A trend must not be described as meaningful when the underlying sample is too small or materially incomparable.

---

## 14. Industry Context Dimensions

Demand signals may be segmented by context such as:

- role family;
- employer;
- sector;
- geography;
- experience level;
- internship vs job;
- hiring cycle;
- college relationship;
- assessment outcome;
- training outcome.

These dimensions must be explicit in the model rather than encoded in free-form labels.

---

## 15. Employer Feedback Intelligence

Employer feedback is a high-value source because it closes the product loop.

Possible employer observations include:

- skill adequacy;
- practical capability;
- communication;
- role-specific proficiency;
- ramp-up difficulty;
- training relevance;
- missing competencies;
- internship performance;
- new capability requirements.

Employer feedback should be modeled as an observed signal, not automatically converted into a canonical skill requirement.

```text
Employer Feedback
      ↓
Observed Capability Signal
      ↓
Aggregation / Review
      ↓
Potential Role / Skill / Training Insight
```

---

## 16. Recruitment Outcome Intelligence

Recruitment outcomes can provide signals about:

- role readiness;
- assessment effectiveness;
- skill-gap relevance;
- training effectiveness;
- opportunity matching quality;
- hiring conversion.

These outcomes are outcome evidence, not direct proof that a particular skill caused a hiring decision.

Causal claims require stronger methodology than simple correlation.

---

## 17. College Planning Use Case

Industry intelligence should support the college workflow:

```text
Industry Demand
      ↓
Target Role Families
      ↓
Required Skills / Competencies
      ↓
Cohort Capability Snapshot
      ↓
Priority Gaps
      ↓
Training Plan
      ↓
Reassessment
      ↓
Updated Readiness
```

The college must be able to distinguish:

- market demand;
- employer-specific demand;
- current cohort gap;
- training priority;
- resulting improvement.

---

## 18. Training Intelligence

Industry demand may influence learning/training recommendations.

Examples:

```text
Growing role demand
      +
High cohort gap
      +
Available learning/training
      ↓
High-priority intervention candidate
```

Recommendations remain decision support unless explicitly approved as a training policy.

Career360 must not promise that completing a recommended course guarantees employment.

---

## 19. Opportunity Intelligence

Industry intelligence can improve opportunity discovery by connecting:

```text
Demand Signal
   ↓
Relevant Role
   ↓
Opportunity
   ↓
Requirement Set
   ↓
Candidate Match
```

However, opportunity-specific requirements remain authoritative for the actual application/matching decision.

A general market trend must not override a concrete employer's published requirement.

---

## 20. Source Confidence

Confidence must be attached to the **signal interpretation**, not presented as a universal truth score.

Possible conceptual levels:

```text
HIGH
MEDIUM
LOW
UNRESOLVED
```

Confidence can consider:

- source quality;
- source recency;
- normalization certainty;
- sample size;
- cross-source consistency;
- contextual completeness.

The exact calculation is policy-controlled.

---

## 21. Freshness

Industry demand is time-sensitive.

Derived records should include:

```text
observed_at
derived_at
source_window_start
source_window_end
freshness_state
```

Potential freshness states:

```text
FRESH
AGING
STALE
UNKNOWN
```

Freshness policies should vary by use case.

For example, current hiring demand may need a shorter validity window than historical curriculum planning.

---

## 22. Snapshotting and Reproducibility

Reports and dashboards must be reproducible from versioned signal data.

A derived report should identify:

- source population;
- observation window;
- taxonomy version;
- role mapping version;
- normalization policy/version;
- aggregation policy/version.

Changing the taxonomy must not silently alter previously published historical reports.

---

## 23. Governance

Industry intelligence requires governance over:

- source approval;
- data licensing and permitted use;
- taxonomy changes;
- normalization decisions;
- role mapping;
- aggregation policies;
- sensitive data handling;
- external data retention;
- reviewer responsibilities.

Published intelligence should be auditable.

---

## 24. Privacy and Data Minimization

Employer feedback, candidate outcomes and organizational information may be sensitive.

The intelligence layer should prefer aggregated signals over unnecessary individual-level exposure.

Examples:

```text
Preferred:
"72% of evaluated interns in cohort X demonstrated the target competency."

Avoid unless required:
"Student A failed competency X because of feedback Y."
```

Individual-level access must obey domain authorization and tenant boundaries.

---

## 25. Multi-Tenant Isolation

Industry intelligence must respect organization boundaries.

Rules:

- tenant-scoped data must not leak across organizations;
- company-private signals remain company-private unless explicitly authorized for aggregation;
- college-private cohort data remains protected;
- cross-tenant aggregate views require an explicit product policy;
- external aggregate intelligence must not reveal confidential source records.

---

## 26. Data Retention

Raw sources, normalized signals and published aggregates may have different retention policies.

The product should distinguish:

```text
Raw Source Retention
Normalized Signal Retention
Derived Aggregate Retention
Published Report Retention
```

Deletion or retention actions must not create unexplained historical gaps in auditable decision records.

---

## 27. Anti-Patterns

Career360 must avoid:

### 27.1 AI-generated market truth

AI summaries are not evidence of market demand.

### 27.2 Title-frequency-only analytics

Repeated job titles do not define capability requirements.

### 27.3 Skill-count without provenance

A skill count without source population or observation window is misleading.

### 27.4 Silent taxonomy mutation

Intelligence processing must not silently create or merge canonical skills.

### 27.5 Current-market overwrite

New observations must not overwrite historical observations.

### 27.6 Trend without denominator

A percentage without the population behind it is insufficient for decision-making.

### 27.7 Feedback as automatic policy

One employer's feedback must not automatically redefine platform-wide readiness rules.

---

## 28. Recommended Data Objects

Conceptual objects include:

```text
IndustrySource
IndustrySignal
NormalizedIndustryObservation
RoleDemandSignal
SkillDemandSignal
CompetencyDemandSignal
TrendSnapshot
EmployerFeedback
OutcomeSignal
IntelligenceDatasetSnapshot
```

Exact persistence design remains subject to implementation constraints and aggregate boundaries.

---

## 29. API Responsibilities

The industry intelligence module should expose operations conceptually grouped as:

```text
/source
/signal
/normalization
/role-mapping
/demand
/trends
/employer-feedback
/insights
```

API contracts must follow `docs/06_data_contracts.md`.

Long-running ingestion and aggregation should use the platform's PostgreSQL-backed job queue initially.

---

## 30. Asynchronous Processing

Suitable async jobs include:

- document extraction;
- JD parsing;
- bulk normalization;
- signal aggregation;
- trend calculation;
- large report generation;
- external source refresh.

Each job should have:

```text
job_id
type
status
attempt_count
created_at
started_at
completed_at
error_reference
idempotency_key
```

Failures must be observable and retryable where safe.

---

## 31. Search and Retrieval

PostgreSQL full-text search, `pg_trgm` and vector similarity may support:

- similar roles;
- similar skill phrases;
- source discovery;
- role clustering;
- evidence/learning similarity.

Search relevance is a discovery mechanism, not an authorization mechanism and not a readiness decision.

---

## 32. AI Governance for Intelligence

AI-generated intelligence should carry metadata such as:

```text
model/provider
prompt or template version
generated_at
proposal status
confidence
input reference
review status
```

AI outputs must be distinguishable from human-approved domain records.

Provider-specific SDKs must remain behind an application abstraction so that Gemini or another provider can later be changed without rewriting the domain.

---

## 33. Reporting Rules

Industry reports may include:

- top demanded skills by role family;
- emerging skills;
- role demand trends;
- employer requirement comparisons;
- cohort-to-market gap analysis;
- training demand;
- employer feedback summaries;
- hiring outcome trends.

Reports must clearly distinguish:

```text
OBSERVED
DERIVED
PREDICTED / PROPOSED
```

A predicted or proposed insight must never be visually represented as an observed fact.

---

## 34. Quality Checks

Before a signal is published:

```text
Source Valid?
      ↓
Schema Valid?
      ↓
Normalization Valid?
      ↓
Role Mapping Valid?
      ↓
Context Present?
      ↓
Confidence Acceptable?
      ↓
Aggregation Reproducible?
      ↓
Publish
```

Failed records should be quarantined or returned for review rather than silently included.

---

## 35. Product Outputs

The intelligence layer should produce actionable outputs rather than a generic analytics page.

Examples:

```text
Company:
"These skills are rising in our target graduate roles."

College:
"These three capabilities are most demanded across the roles
we are preparing this cohort for."

Student:
"Your target role requires these capabilities; current market
signals make these two gaps especially important."

Training:
"These interventions address the largest high-priority cohort gaps."

Leadership:
"Training investment improved readiness for the targeted role family."
```

All such statements must be traceable to structured data.

---

## 36. Relationship to Core Domain Truth

Industry Intelligence may propose changes to:

- Role Blueprints;
- skills;
- competencies;
- training priorities.

It does not directly own those concepts.

Ownership remains:

```text
Skill Taxonomy     → Skill Domain
Role Blueprint     → Role Domain
Readiness          → Readiness Domain
Learning / Training→ Learning / Training Domain
Opportunity        → Opportunity Domain
Outcome            → Outcome Domain
```

Industry Intelligence is therefore a consumer, synthesizer and signal producer across domains, not a replacement for them.

---

## 37. P0 / P1 Scope

### P0

- company-defined role requirements;
- JD ingestion at a basic level;
- structured signal provenance;
- skill normalization;
- role mapping;
- basic demand aggregation;
- employer feedback capture;
- basic industry dashboards.

### P1

- richer external/structured source ingestion;
- trend detection;
- advanced normalization;
- training-demand intelligence;
- employer outcome intelligence;
- cross-role comparisons;
- stronger review workflows.

### P2

- advanced workforce planning;
- broad cross-institution benchmarking;
- sophisticated predictive analytics;
- expanded external market intelligence.

---

## 38. Definition of Done

Industry Intelligence is production-ready when:

- every published signal has provenance;
- raw and normalized representations are distinguishable;
- taxonomy versioning is preserved;
- aggregation is reproducible;
- AI proposals are validated and reviewable;
- tenant authorization is enforced;
- stale data is detectable;
- async processing is observable;
- dashboards distinguish observed vs derived vs proposed;
- tests cover normalization, aggregation, permissions and historical reproducibility.

---

## 39. Final Principle

> **Career360 should convert changing industry demand into structured, evidence-aware intelligence that improves role definition, training decisions and readiness outcomes without pretending that noisy market data is perfect truth.**
