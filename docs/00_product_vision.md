# Career360 — Product Vision

## 1. Document Purpose

This document defines the product vision, product identity, business problem, users, core value proposition, product principles, lifecycle, scope boundaries and success model for Career360.

It is the primary product-level reference for the Career360 project.

The implementation architecture, domain model, API contracts, security model, assessment engine, learning/training design, industry intelligence and active execution plan are defined in their respective documents under `docs/`.

---

## 2. Product Identity

**Product Name:** Career360

**Product Type:** Industry-Driven Career & Workforce Readiness Platform

**Primary Users:**

- Students
- Colleges
- Companies

**Core Product Capability:**

> Closed-Loop Role Readiness

Career360 connects industry requirements with measurable student and cohort capability, targeted development, evidence, readiness and real-world outcomes.

---

## 3. Product Vision

Career360 aims to provide a shared platform through which students, academic institutions and employers can work from the same understanding of roles, competencies, skills and evidence.

The platform translates industry requirements into structured role definitions, measures current capability, identifies gaps, connects those gaps to learning and training, verifies improvement through evidence and reassessment, and connects demonstrably ready talent to internships, jobs and workforce opportunities.

The product is designed around a continuous cycle rather than a one-time placement process.

```text
Industry Demand
      ↓
Role Blueprint
      ↓
Skills / Competencies
      ↓
Assessment
      ↓
Evidence
      ↓
Skill Gap
      ↓
Learning / Training
      ↓
Practical Evidence
      ↓
Reassessment
      ↓
Role Readiness
      ↓
Jobs / Internships / Hiring
      ↓
Outcome & Employer Feedback
      ↺
Industry / Training Intelligence
```

---

## 4. Product Mission

Career360 provides a common operational layer between education and industry by making role requirements, student capability, skill gaps, training interventions and readiness measurable and connected.

The platform must support three connected questions:

### Student

> What role am I targeting, what do I currently demonstrate, what am I missing, what should I do next, and can I prove that I am ready?

### College

> Which industry roles matter to our students, how ready are our cohorts, which skill gaps should we address, what training should we run, and did it improve readiness?

### Company

> What capability does this role require, which candidates are already ready, who is realistically trainable, what gaps remain, and did the resulting training or hiring produce the expected outcome?

---

## 5. Core Product Promise

# Don't just tell students what to learn. Prove when they're ready.

The product therefore focuses on measurable capability rather than recommendations alone.

A recommendation is not treated as proof of competence.

A certificate is not treated as automatic proof of practical capability.

A high aggregate score does not automatically imply readiness.

Readiness is based on structured requirements and traceable evidence.

---

## 6. Core Problem

The transition from academic education to industry employment involves multiple disconnected activities:

```text
Industry Requirements
        │
        ├── Job Roles
        ├── Skills
        └── Competencies

Academic Preparation
        │
        ├── Curriculum
        ├── Assessments
        └── Training

Student Capability
        │
        ├── Skills
        ├── Projects
        ├── Certifications
        └── Internships

Hiring
        │
        ├── Opportunities
        ├── Screening
        ├── Assessment
        └── Interviews
```

These activities are often represented in separate systems and are not continuously connected.

The resulting problems include:

- students may not know exactly which skills are required for a target role;
- students may know skills but lack verifiable evidence;
- colleges may not know which industry capability gaps are most important for a specific cohort;
- companies may receive candidates who appear qualified but still require substantial preparation;
- training may happen without an explicit baseline gap or measurable post-training outcome;
- placement outcomes and employer feedback may not feed back into future academic and training decisions.

Career360 addresses this fragmentation by creating a shared role, skill, evidence and readiness model.

---

## 7. Product Concept

Career360 is based on five connected concepts.

### 7.1 Role

A target job or work capability profile.

### 7.2 Skill

A specific capability such as Java, SQL, REST APIs or problem solving.

### 7.3 Competency

A broader capability composed of related skills.

### 7.4 Evidence

A demonstrated record supporting a capability claim.

### 7.5 Readiness

A role-specific determination of whether the demonstrated capability satisfies the required conditions.

These relationships create the foundation:

```text
Role
 ↓
Competency
 ↓
Skill
 ↓
Evidence
 ↓
Capability
 ↓
Readiness
```

---

## 8. Role Blueprint

The central industry-facing object in Career360 is the **Role Blueprint**.

A Role Blueprint transforms an ordinary role or job description into a structured capability model.

It may contain:

- role identity;
- responsibilities;
- required competencies;
- required skills;
- target proficiency;
- requirement priority;
- eligibility conditions;
- evidence requirements;
- practical evidence requirements;
- readiness conditions;
- related training interventions;
- version information.

### Requirement Priority

Role requirements use:

```text
MUST
SHOULD
COULD
WON'T
```

This classification is used to distinguish critical requirements from desirable capabilities.

An unsatisfied `MUST` requirement is a readiness blocker.

---

## 9. Skill and Competency Vision

Career360 uses a canonical Skill Taxonomy rather than relying on arbitrary skill strings.

A canonical skill has a stable identity and may have:

- aliases;
- category;
- parent skill;
- description;
- proficiency model;
- version.

Example:

```text
Programming
 ├── Java
 ├── Python
 └── JavaScript

Backend
 ├── REST APIs
 ├── Spring Boot
 └── Authentication

Database
 ├── SQL
 ├── PostgreSQL
 └── Redis
```

Competencies can aggregate multiple skills.

Example:

```text
Backend API Development
 ├── HTTP
 ├── REST
 ├── Authentication
 ├── Error Handling
 ├── API Design
 └── Testing
```

The same canonical skill can therefore be referenced by:

- role requirements;
- assessments;
- evidence;
- learning items;
- training programmes;
- readiness calculations;
- industry signals.

---

## 10. Evidence-First Product Model

Career360 treats evidence as a core product concept.

Possible evidence types include:

- assessments;
- practical labs;
- projects;
- simulations;
- certifications;
- course completion;
- internships;
- mentor evaluations;
- faculty evaluations;
- employer evaluations;
- interviews.

Evidence records preserve the relationship between:

```text
Student
 ↓
Skill
 ↓
Evidence Source
```

The system should be able to answer:

> Why does Career360 consider this student proficient in this skill?

The answer should be traceable to evidence.

---

## 11. Role-Specific Readiness

Career360 does not define employability using only one universal score.

Readiness is evaluated against a target role.

The conceptual readiness dimensions are:

```text
Skill Fit
+
Critical Requirement Satisfaction
+
Practical Evidence
+
Evidence Confidence
+
Evidence Freshness
+
Behavioural Requirements where applicable
```

### Readiness states

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

A high average performance score must not conceal a critical missing `MUST` requirement.

---

## 12. Placement Readiness Index

The institutional College research defines a Placement Readiness Index (PRI) as a weighted composite:

```text
Technical     40%
Aptitude      40%
Soft Skills   20%
```

Career360 retains this as an institutional/reporting concept where needed.

However, the core product readiness model remains role-specific and blocker-aware.

PRI is therefore not the sole authoritative definition of role readiness.

---

## 13. Learning and Training Vision

Learning in Career360 is not isolated from skill analysis.

The platform treats learning as a mechanism for closing measurable capability gaps.

Learning may include:

- courses;
- learning paths;
- projects;
- labs;
- workshops;
- certifications;
- simulations;
- mentor sessions;
- trainer-led programmes.

Each learning item can be associated with:

- skills;
- target roles;
- target proficiency;
- evidence produced;
- assessment or reassessment.

---

## 14. Training Programme Vision

A Training Programme is a structured intervention intended to move an individual or cohort toward a role target.

Example:

```text
Backend Engineer Readiness Programme

Week 1 → Java
Week 2 → SQL
Week 3 → Spring Boot
Week 4 → REST APIs
Week 5 → Testing
Week 6 → Capstone + Reassessment
```

The intended lifecycle is:

```text
Baseline
   ↓
Gap
   ↓
Training
   ↓
Evidence
   ↓
Reassessment
   ↓
Readiness Change
```

---

## 15. Student Product Experience

The Student experience is:

# Understand → Prepare → Prove → Apply

The intended journey is:

```text
Profile
  ↓
Career Goal
  ↓
Target Role
  ↓
Assessment
  ↓
Skill Profile
  ↓
Gap Analysis
  ↓
Learning Roadmap
  ↓
Course / Project / Training
  ↓
Evidence
  ↓
Reassessment
  ↓
Role Readiness
  ↓
Relevant Opportunities
  ↓
Application
```

The student should be able to understand:

- target role;
- current capability;
- strongest skills;
- weakest skills;
- critical blockers;
- recommended next actions;
- available evidence;
- readiness status;
- eligible opportunities.

---

## 16. College Product Experience

The College experience is:

# Observe → Diagnose → Intervene → Measure → Place

The intended journey is:

```text
College
  ↓
Departments
  ↓
Batches
  ↓
Students
  ↓
Industry Roles
  ↓
Assessment
  ↓
Skill Analytics
  ↓
Gap Prioritization
  ↓
Training Tracks
  ↓
Progress
  ↓
Reassessment
  ↓
Readiness
  ↓
Placement
  ↓
Outcome
```

The platform supports visibility at:

```text
Student
Batch
Department
College
```

and provides industry-role context around those levels.

---

## 17. Company Product Experience

The Company experience is:

# Define → Assess → Gap → Train → Verify → Hire

The intended journey is:

```text
Company
  ↓
Role
  ↓
Role Blueprint
  ↓
Assessment
  ↓
Capability Matrix
  ↓
Ready Candidates
+
Trainable Candidates
  ↓
Training Programme
  ↓
Reassessment
  ↓
Ready Pool
  ↓
Interview
  ↓
Hiring
  ↓
Employer Feedback
```

The company experience must distinguish candidates who are ready now from candidates who require further development.

---

## 18. Flagship Product Workflow

The primary end-to-end Career360 scenario is:

```text
Company
  ↓
Create Graduate Backend Engineer Role
  ↓
Role Blueprint
  ├── Java
  ├── SQL
  ├── REST APIs
  ├── Git
  └── Testing
  ↓
College selects CSE cohort
  ↓
Baseline Assessment
  ↓
Skill Profile / Capability Matrix
  ↓
Critical Skill Gaps
  ↓
Training Programme
  ↓
Learning + Practical Work
  ↓
Evidence
  ↓
Reassessment
  ↓
Updated Role Readiness
  ↓
Company Ready Pool
  ↓
Application / Interview
  ↓
Hiring Outcome
  ↓
Employer Feedback
```

This workflow is the primary product demonstration of the system.

---

## 19. Industry-to-Academia Feedback Loop

Career360 captures the reverse direction as well.

Example:

```text
Employer hires graduates
        ↓
Employer evaluates performance
        ↓
Skill gaps identified
        ↓
Outcome stored
        ↓
Industry intelligence updated
        ↓
College training priorities updated
        ↓
Future students trained differently
```

This creates:

# Industry → Academia → Student → Industry

as a continuous cycle.

---

## 20. Industry Intelligence

Career360 may use structured sources such as:

- employer role requirements;
- job descriptions;
- recruitment outcomes;
- employer feedback;
- historical platform signals;
- structured industry information.

Processing:

```text
Raw Source
    ↓
Extraction
    ↓
Skill Normalization
    ↓
Role Mapping
    ↓
Aggregation
    ↓
Demand Signal
    ↓
Trend / Intelligence
```

Industry signals should retain provenance such as:

- source;
- observation date;
- context;
- confidence.

AI may summarize structured industry information but does not replace source provenance.

---

## 21. AI Product Role

Generative AI operates as an intelligence layer.

Supported applications include:

### Role Intelligence

Convert a job description into a structured Role Blueprint proposal.

### Skill Normalization

Map different names for similar skills to canonical skill entities.

### Gap Explanation

Explain why a student is missing a particular role requirement.

### Training Planning

Propose learning or training sequences for identified gaps.

### Career Guidance

Explain possible career paths using structured profile and role information.

### Industry Intelligence

Summarize structured demand signals.

### Report Narratives

Generate human-readable explanations from structured report data.

### Semantic Similarity

Support similarity between:

- roles;
- skills;
- learning items;
- evidence;
- opportunities.

---

## 22. AI Product Boundaries

AI is not the authoritative source for:

- final hiring decisions;
- final eligibility decisions;
- final assessment scores;
- final skill proficiency;
- final readiness.

Authoritative decision flow:

```text
Structured Data
      ↓
Deterministic Domain Logic
      ↓
Authoritative Result
      ↓
AI Explanation / Assistance
```

AI output must be validated before entering authoritative product workflows.

---

## 23. Core Product Differentiation

The product is centered on the following connected capabilities:

### Role Blueprint

Transforms role requirements into structured, machine-readable capability requirements.

### Evidence-Backed Readiness

Makes capability claims traceable to assessments, projects, internships, certifications and evaluations.

### Gap-to-Training Loop

Connects measured gaps to learning and training interventions.

### Reassessment

Measures whether capability actually changed.

### Cohort-to-Role Planning

Allows institutions to understand how many students are ready or trainable for selected roles.

### Industry Feedback

Uses employer and placement outcomes to improve future training and intelligence.

These capabilities are intended to operate as one system rather than as separate products.

---

## 24. Product Scope

### P0 — Core Release

```text
Identity
Organizations
Memberships
RBAC
Tenant Isolation

Skills
Competencies
Role Blueprints

Assessments
Assessment Attempts
Scoring

Evidence
Skill Profiles

Gap Analysis
Role Readiness
Explainability

Learning
Training Programmes
Reassessment

Jobs
Internships
Matching
Applications

College Analytics
Company Readiness
Basic Reports
Audit
```

### P1 — Intelligence Expansion

```text
Industry Intelligence
JD Ingestion
Skill Normalization
Advanced Training Intelligence
Trainer Allocation
Expanded Evidence
Employer Evaluation
Employer Feedback
Outcome Analytics
Time-to-Ready
```

### P2 — Ecosystem Expansion

```text
Faculty-Industry Programmes
FDP
Research Collaboration
Consulting
Mentorship Marketplace
Advanced Workforce Planning
Cross-College Benchmarking
Predictive Analytics
Large Learning Marketplace
```

---

## 25. Product Boundaries

Career360 will not treat the following as the center of the product:

- generic job listings;
- generic course discovery;
- standalone assessments;
- resume creation;
- certification collection;
- generic AI chat;
- social networking;
- gamification.

These can be supporting capabilities.

The product identity remains centered on role readiness.

---

## 26. Product Data Principles

### Requirement Truth

What does the role require?

### Capability Truth

What can the student demonstrate?

### Outcome Truth

What happened after training, application or hiring?

The system connects the three:

```text
Requirement Truth
       ↓
Capability Truth
       ↓
Intervention
       ↓
Outcome Truth
       ↓
Improved Requirement / Training Intelligence
```

---

## 27. Product Success Model

Career360 success is measured through outcome-oriented metrics.

### Student Metrics

- Time-to-Ready
- Readiness Improvement
- Assessment Completion
- Training Completion

### College Metrics

- Role Readiness Rate
- Cohort Gap Closure Rate
- Placement Conversion
- Training Outcome

### Company Metrics

- Time-to-Qualified-Cohort
- Ready-to-Hire Conversion
- Candidate Readiness
- Training Outcome
- Post-Hire Alignment

### Platform Metrics

- Evidence Coverage
- Readiness accuracy against measured outcomes
- Application conversion
- Outcome feedback coverage

---

## 28. Product Governance

The following are controlled product concepts:

- Skill taxonomy;
- Role Blueprint structure;
- readiness policy;
- evidence definitions;
- requirement priorities;
- training mappings;
- opportunity eligibility.

Changes to these concepts must be versioned or documented where historical interpretation could be affected.

Historical readiness and assessment results must remain interpretable against the rules under which they were generated.

---

## 29. Product Architecture Direction

Career360 is implemented as one product with clearly separated business domains.

Core domains:

```text
Identity & Access
Organizations
Students
Colleges
Companies
Skills
Competencies
Roles
Assessments
Evidence
Readiness
Learning
Training
Opportunities
Matching
Applications
Industry
Outcomes
Reporting
Notifications
Documents
Billing
Audit
```

These domains are initially implemented within a modular monolith.

---

## 30. Product-Level Technology Baseline

### Frontend

- React 19.x
- Vite 8.x
- TypeScript
- Tailwind CSS 4.x
- shadcn/ui
- TanStack Query

### Core Backend

- Java 25 LTS
- Spring Boot 4.1.x
- Spring Security
- Spring Modulith
- Hibernate ORM 7
- jOOQ
- Flyway
- REST
- OpenAPI

### Data

- PostgreSQL 18.x
- Aiven PostgreSQL Free for the initial managed environment
- pgvector
- pg_trgm
- PostgreSQL full-text search

### Initial Asynchronous Processing

- PostgreSQL-backed job queue
- Spring workers

### Initial Cache

- Caffeine

### Object Storage

- Cloudflare R2

### AI

- Gemini API
- FastAPI/Python as a separate AI/data runtime when workload complexity requires it

### Hosting

- Cloudflare Pages for the frontend
- Google Cloud Run for the Spring Boot backend

### Testing

- JUnit
- Testcontainers
- Vitest
- React Testing Library
- Playwright

### Observability

- OpenTelemetry
- Cloud logging/metrics initially

### Packaging

- Docker

### Infrastructure as Code

- Terraform/OpenTofu-compatible approach

---

## 31. Cost-Conscious Product Architecture

The initial platform is designed to operate using free or low-cost infrastructure where practical.

Initial infrastructure:

```text
Cloudflare Pages
       ↓
Google Cloud Run
       ↓
Aiven PostgreSQL
       +
Cloudflare R2
       +
Gemini API
```

The core application remains independent of vendor-specific backend services.

Infrastructure can later be expanded without changing the fundamental domain model.

---

## 32. Product Portability

The architecture preserves clear boundaries between the product and infrastructure providers.

The following provider interfaces may exist:

```text
AIProvider
StoragePort
EmailPort
QueuePort
IdentityProvider
CachePort
```

The product domain must remain independent of the specific provider implementation.

This allows infrastructure to evolve while the core Career360 business model remains stable.

---

## 33. Production Principles

Career360 is governed by the following product-level principles:

1. **Evidence before claims.**
2. **Role-specific readiness before generic scoring.**
3. **Critical requirements must remain visible.**
4. **Training must connect to identified gaps.**
5. **Reassessment must measure improvement.**
6. **AI assists but does not independently decide authoritative business outcomes.**
7. **Industry feedback must be capable of influencing future intelligence.**
8. **Student, College and Company experiences share the same underlying capability model.**
9. **Historical decisions remain explainable.**
10. **Core business logic remains portable across infrastructure providers.**

---

## 34. Product Operating Model

Career360 operates as three connected workspaces over one shared intelligence platform:

```text
                         CAREER360
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
          ▼                  ▼                  ▼
       STUDENT            COLLEGE            COMPANY
          │                  │                  │
          └──────────────────┼──────────────────┘
                             ▼
                     SHARED INTELLIGENCE
                             │
        ┌────────────────────┼────────────────────┐
        ▼                    ▼                    ▼
   ROLE BLUEPRINT        SKILL MODEL         EVIDENCE MODEL
        │                    │                    │
        └────────────────────┼────────────────────┘
                             ▼
                       READINESS ENGINE
                             │
                  ┌──────────┴──────────┐
                  ▼                     ▼
             LEARNING               MATCHING
                  │                     │
                  └──────────┬──────────┘
                             ▼
                           OUTCOME
```

---

## 35. Final Product Definition

Career360 is an industry-driven career and workforce-readiness platform that connects Students, Colleges and Companies through a shared framework of Roles, Competencies, Skills and Evidence.

A company or institution can define what a role requires. Career360 represents that requirement as a Role Blueprint. Students or cohorts can then be assessed against the requirement, generating measurable skill observations and evidence. The platform identifies gaps, connects them to learning or training interventions, captures practical evidence, performs reassessment and calculates explainable role readiness. Ready candidates can participate in jobs and internship opportunities, while training and hiring outcomes provide feedback for future role, skill and training intelligence.

The product is therefore defined by the complete lifecycle:

# Requirement → Skill → Evidence → Gap → Training → Reassessment → Readiness → Opportunity → Outcome

