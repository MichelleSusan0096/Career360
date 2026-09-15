# Career360 — Outcomes & Analytics

## 1. Purpose

This document defines the production specification for Career360 analytics and outcome tracking. Analytics must measure whether the platform is improving capability, readiness, participation, opportunity conversion, training effectiveness, placement outcomes, and employer outcomes.

The analytics layer is a reporting and decision-support capability over authoritative domain data. It must not silently redefine business truth, readiness, eligibility, assessment results, or hiring outcomes.

---

## 2. Core Principles

1. **Authoritative data first** — analytics consumes validated domain records rather than client-calculated metrics.
2. **Traceability** — every important metric must have a defined formula, source entities, scope, time window, and version where applicable.
3. **Tenant isolation** — college, company, institution, and other organizational analytics must respect tenant and membership boundaries.
4. **Historical integrity** — reports over past periods must remain interpretable after role, skill, benchmark, assessment, or business-rule changes.
5. **Role-aware analytics** — readiness and skill-gap reporting must preserve the role context in which those values were measured.
6. **No hidden ranking authority** — analytics may surface signals, but must not become an undocumented hiring or eligibility decision engine.
7. **Freshness is explicit** — dashboards must show whether a value is real-time, near-real-time, daily, or snapshot-based.
8. **Privacy by design** — aggregate views should be preferred where individual-level visibility is not required.
9. **Explainability** — users must be able to understand why a metric changed and what source data contributed to it.
10. **Operational usefulness** — every dashboard should support an identifiable decision or action.

---

## 3. Outcome Model

Career360 must distinguish between activity metrics and outcomes.

### 3.1 Activity

Examples include:

- assessments assigned;
- assessments submitted;
- courses enrolled;
- training sessions scheduled;
- training modules completed;
- applications submitted;
- interviews scheduled.

### 3.2 Capability Outcomes

Examples include:

- skill proficiency improvement;
- critical skill-gap reduction;
- practical evidence gained;
- reassessment improvement;
- role-readiness state progression;
- evidence freshness and coverage.

### 3.3 Opportunity Outcomes

Examples include:

- matched opportunities;
- applications progressing to interview;
- interview completion;
- offers;
- placements;
- internships;
- conversions from internship to employment where captured.

### 3.4 Employer Outcomes

Examples include:

- employer-selected candidate counts;
- training completion before hiring;
- employer feedback on capability;
- post-selection readiness validation;
- gap patterns observed after onboarding.

### 3.5 Institutional Outcomes

Examples include:

- cohort readiness distribution;
- department-level skill gaps;
- participation in industry learning;
- placement progression;
- role demand alignment;
- improvement after targeted interventions.

---

## 4. Metric Taxonomy

Every metric belongs to one of four classes:

| Class | Meaning | Example |
|---|---|---|
| Descriptive | What happened? | Assessment completion rate |
| Diagnostic | Why did it happen? | Top missing MUST skills |
| Outcome | What changed? | Critical-gap reduction |
| Decision support | What should be investigated or acted on? | Cohort needs backend training |

Career360 analytics must avoid presenting predictive or prescriptive outputs as authoritative unless separately approved as a product capability.

---

## 5. Canonical KPI Definitions

### 5.1 Assessment Completion Rate

`completed_assessments / assigned_assessments * 100`

The metric must define the population and time window used in the denominator.

### 5.2 Skill Gap Score

Where the applicable benchmark is defined:

`student_score / benchmark_score * 100`

The source research uses this metric for skill-gap reporting. Career360 must preserve the benchmark and role/context used to calculate it.

### 5.3 Placement Readiness Index (PRI)

Institutional reporting may retain the defined PRI model:

`PRI = technical * 40% + aptitude * 40% + soft_skills * 20%`

PRI is an institutional/reporting indicator. It is not the authoritative replacement for role-specific readiness.

### 5.4 Readiness Rate

`students_in_ready_state / eligible_assessed_students * 100`

The denominator must exclude populations explicitly marked as not assessed or not applicable according to the metric definition.

### 5.5 Critical Requirement Satisfaction

`critical_requirements_satisfied / critical_requirements_total * 100`

A MUST requirement that is defined as a readiness blocker must remain visible even when aggregate averages are high.

### 5.6 Training Completion Rate

`training_completions / training_assignments * 100`

Completion does not itself prove practical competence.

### 5.7 Gap Reduction

`baseline_gap - current_gap`

Where percentages are shown, the calculation must state whether the display is percentage-point change or relative percentage change.

### 5.8 Improvement Velocity

The source research identifies Improvement Velocity as a useful metric. The exact production formula must be defined centrally before implementation and versioned with the metric definition.

### 5.9 Opportunity Conversion

Examples:

`applications_to_interviews / submitted_applications * 100`

`offers / interviews_completed * 100`

`placements / submitted_applications * 100`

The funnel stage definitions must be fixed by the opportunities/application state model.

---

## 6. Readiness Analytics

Readiness analytics must preserve the state progression:

`NOT_ASSESSED → ASSESSED → GAP_IDENTIFIED → IN_TRAINING → PENDING_REASSESSMENT → PROVISIONALLY_READY → READY`

A future `STALE` state may be supported where evidence freshness rules require it.

Dashboards should show:

- count and percentage by readiness state;
- role-level readiness;
- critical blocker counts;
- evidence coverage;
- practical evidence coverage;
- evidence freshness;
- reassessment movement;
- students or candidates whose readiness changed since the prior snapshot.

Readiness analytics must not derive an alternative readiness state from presentation-layer calculations.

---

## 7. Cohort and Institution Analytics

Career360 must support the hierarchy:

`Student → Batch → Department → College`

and the reverse analytical path from role demand into academic cohorts.

Institution dashboards should support:

- college-wide readiness overview;
- department comparison;
- batch comparison;
- skill-gap distribution;
- role-demand alignment;
- assessment participation;
- learning/training completion;
- readiness progression over time;
- placement and internship outcomes;
- at-risk indicators;
- intervention effectiveness.

### 7.1 Cohort Comparison Guardrails

Comparisons must disclose differences in:

- population size;
- assessment coverage;
- role mix;
- assessment version;
- benchmark version;
- reporting period.

Small populations should not be presented as statistically authoritative merely because a ranking can be computed.

---

## 8. Company Analytics

Company analytics must focus on role capability and recruitment outcomes.

Supported views include:

- role requirement distribution;
- critical MUST skill demand;
- candidate readiness distribution;
- trainable-candidate pool size;
- matched versus unmatched candidates;
- opportunity funnel;
- employer feedback;
- outcome by role, institution, cohort, and recruiting cycle where authorized.

Company analytics must not expose student data outside authorized recruiting scopes.

---

## 9. Industry Intelligence Analytics

Industry intelligence analytics should transform normalized market signals into interpretable trends.

Pipeline:

`Raw Source → Extraction → Normalization → Skill Mapping → Aggregation → Demand Signal → Trend/Intelligence`

Each signal should retain:

- source;
- source date;
- context;
- normalized skill or role;
- aggregation period;
- confidence;
- methodology/version.

Trend dashboards should make it clear whether a value represents:

- employer-provided demand;
- platform opportunity demand;
- historical internal demand;
- externally sourced market intelligence.

These sources must not be silently mixed.

---

## 10. Training Effectiveness

Training analytics must measure more than attendance.

A production training effectiveness view should connect:

`Assigned Gap → Training Intervention → Participation → Completion → Practical Evidence → Reassessment → Readiness Change`

Useful metrics include:

- assignment completion;
- practical artifact completion;
- pre/post proficiency change;
- critical-gap reduction;
- reassessment pass rate;
- readiness-state progression;
- time from intervention to reassessment;
- outcome conversion where sufficient sample size exists.

Course completion or certification should never be interpreted as automatic practical competence.

---

## 11. Placement and Internship Funnel

The canonical funnel is:

`Opportunity Published → Matched → Application → Screening → Interview → Offer → Accepted → Joined/Completed → Outcome`

Analytics must be based on authoritative state transitions and event timestamps.

Useful breakdowns include:

- source of application;
- role;
- institution;
- department;
- batch;
- readiness state at application;
- readiness state at interview;
- training participation before application;
- outcome reason where captured.

Sensitive individual-level data must be constrained by authorization.

---

## 12. Employer Feedback Loop

Employer feedback is a first-class outcome input.

Possible feedback dimensions include:

- role readiness validation;
- skill adequacy;
- practical capability;
- communication or behavioral capability where relevant;
- training effectiveness;
- skill gaps discovered after selection;
- recommendation for future training.

Feedback must preserve:

- evaluator identity or organization context as permitted;
- role;
- cohort or candidate scope;
- evaluation date;
- structured ratings;
- free-text comments where supported;
- version of the evaluation template.

Employer feedback must inform institutional learning loops without becoming an invisible change to the canonical skill taxonomy or readiness rules.

---

## 13. Snapshotting and Historical Reporting

Analytics may use periodic snapshots for stable longitudinal reporting.

Snapshots should preserve:

- tenant/organization;
- time period;
- role and role-blueprint version where relevant;
- skill and competency versions where relevant;
- benchmark version;
- population definition;
- metric definition version;
- calculated values;
- source freshness.

A later correction to domain data must have a defined reconciliation policy. Historical reports must not silently rewrite prior published reports unless the correction policy explicitly permits it.

---

## 14. Event and Data Flow

Authoritative domain transactions produce analytics-relevant events or records.

Example:

`Assessment Submitted → Assessment Result Stored → Evidence Created/Updated → Readiness Recalculated → Analytics Event → Aggregate/Snapshot Update`

Another example:

`Training Completed → Practical Evidence Requested → Evidence Evaluated → Reassessment Completed → Readiness Changed → Analytics Updated`

Analytics processing must be idempotent.

---

## 15. Analytical Storage Strategy

The initial product should remain PostgreSQL-first.

Preferred progression:

1. transactional PostgreSQL tables;
2. indexed analytical queries;
3. derived aggregate tables/materialized views where justified;
4. periodic snapshots for stable historical reporting;
5. dedicated analytical infrastructure only when measured scale requires it.

The initial system does not require a separate data warehouse, analytics database, or stream-processing platform merely for architectural appearance.

---

## 16. API Contract for Analytics

Analytics APIs must follow the platform's common API envelope and authorization rules.

Example resource style:

- `GET /api/v1/analytics/college/overview`
- `GET /api/v1/analytics/departments/{departmentId}`
- `GET /api/v1/analytics/roles/{roleId}/readiness`
- `GET /api/v1/analytics/training/effectiveness`
- `GET /api/v1/analytics/opportunities/funnel`
- `GET /api/v1/analytics/industry/skills`

Responses should include:

- metric values;
- reporting period;
- scope;
- freshness timestamp;
- metric definition/version where needed;
- comparison period where requested.

---

## 17. Dashboard UX Requirements

Every analytics screen must support the established four UI states:

`Idle → Loading → Error → Empty`

A successful loaded state is not implied by absence of an error.

Dashboards should provide:

- clear reporting period;
- filter state;
- scope context;
- last-updated time;
- visible definitions for non-obvious metrics;
- drill-down paths;
- export capability where authorized.

Charts must not be the only representation of an important value; accessible numeric summaries should accompany them.

---

## 18. Alerts and At-Risk Signals

Career360 may calculate operational indicators such as:

- students with repeated critical skill gaps;
- overdue assessments;
- training non-completion;
- readiness stagnation;
- opportunities with insufficient eligible candidates.

These are intervention signals, not autonomous adverse decisions.

Thresholds must be centrally defined and versioned rather than scattered across frontend code.

---

## 19. Exports and Reports

Authorized users may export reports to supported formats.

Exports must include:

- report title;
- reporting period;
- scope;
- generation timestamp;
- metric definitions or footnotes where needed;
- data freshness;
- applicable filters.

Export generation should be asynchronous when the query is large. Generated files require access controls, expiry/retention rules, and audit logging.

---

## 20. Privacy and Data Minimization

Analytics must use the least granular data necessary.

Examples:

- institution-wide planning should prefer aggregate data;
- individual candidate details should require a legitimate authorized workflow;
- sensitive personal information must not appear in aggregate exports unless required and authorized;
- externally shared reports should use anonymized or aggregated views where possible.

Analytics access is subject to the same authorization and tenant isolation invariants as operational data.

---

## 21. Auditability

The platform should record auditable events for material analytics actions such as:

- report generation;
- export generation;
- export download where required;
- dashboard configuration changes where persistent;
- metric-definition changes;
- threshold changes;
- publication of official reports.

Analytics must not mutate authoritative student, assessment, readiness, or opportunity data merely by being viewed.

---

## 22. AI and Analytics Boundary

AI may assist with:

- narrative summaries;
- natural-language explanations of trends;
- report drafting;
- anomaly investigation suggestions;
- semantic grouping of related industry signals.

AI must not silently alter canonical metric values or authoritative outcomes.

The safe pattern is:

`Authoritative Data → Deterministic Metrics → AI Narrative/Proposal → Validation → Display`

---

## 23. Verification Requirements

Tests must cover:

### Unit

- metric formulas;
- denominator definitions;
- date-window handling;
- trend calculations;
- snapshot transformations.

### Integration

- tenant scoping;
- authorization;
- source-data joins;
- event-to-aggregate updates;
- snapshot consistency;
- export generation.

### Browser/UI

- dashboard loading;
- error and empty states;
- filters;
- drill-downs;
- authorized versus unauthorized views;
- export flow.

### Regression

Metric definition changes must have explicit tests so that a business-rule change is not mistaken for an implementation defect.

---

## 24. Non-Goals

The initial analytics platform is not required to provide:

- a large enterprise data warehouse;
- arbitrary user-authored SQL;
- autonomous hiring recommendations;
- opaque predictive scoring used as a hiring decision;
- uncontrolled cross-tenant benchmarking;
- real-time streaming for every metric.

Such capabilities require explicit product, privacy, scale, and governance decisions.

---

## 25. Definition of Done

The outcomes and analytics capability is production-ready when:

1. every official KPI has a documented formula and source definition;
2. analytics respects organization and role authorization;
3. role-specific readiness is preserved in reporting;
4. historical reports remain interpretable through versioned dimensions and metric definitions;
5. large reports can run asynchronously without blocking core requests;
6. dashboards expose freshness and scope;
7. exports are secured and audited;
8. metric calculations are covered by automated tests;
9. AI-generated narratives cannot modify authoritative metrics;
10. every dashboard supports useful action or decision-making rather than vanity measurement.
