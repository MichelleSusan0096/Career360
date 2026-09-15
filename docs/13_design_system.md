# Career360 — Design System

## 1. Purpose

This document defines the product-wide design system for Career360 across student, college, company, faculty, placement, learning, training, assessment, readiness, opportunity, and analytics experiences.

The design system exists to provide a consistent, accessible, trustworthy, production-grade user experience while allowing different role-based workflows to share the same visual and interaction language.

---

## 2. Design Principles

### 2.1 Clarity over decoration

Career360 is a decision-support product. Screens must prioritize understanding what is required, what is true now, what is missing, and what action comes next.

### 2.2 Evidence before claims

When the UI communicates skill, readiness, certification, or outcome, it should make the evidence context visible or directly reachable.

### 2.3 Role-aware simplicity

Students, colleges, and companies should see the workflows relevant to their responsibilities. Shared components should remain consistent while information density changes by role.

### 2.4 Progressive disclosure

Show the most important information first. Deeper evidence, formulas, history, methodology, and secondary controls should be available through drill-downs rather than overwhelming the primary workflow.

### 2.5 Honest system state

The UI must distinguish idle, loading, success, empty, error, processing, restricted, and stale states where applicable.

### 2.6 Accessible by default

Keyboard navigation, readable contrast, focus visibility, semantic structure, meaningful labels, and non-color-only communication are required.

### 2.7 Consistency over local cleverness

Teams should compose existing design-system primitives before inventing one-off components or interaction patterns.

---

## 3. Product Visual Language

Career360 should feel:

- professional;
- modern;
- trustworthy;
- structured;
- evidence-driven;
- approachable for students;
- credible for institutions and employers.

The visual system should avoid unnecessary gamification, excessive gradients, ornamental dashboards, or visual patterns that imply certainty where the underlying evidence is uncertain.

---

## 4. Design Tokens

The implementation must centralize visual decisions as tokens rather than scattering raw values across components.

Token groups should include:

- color;
- typography;
- spacing;
- sizing;
- border radius;
- borders;
- shadows/elevation;
- focus treatment;
- motion;
- z-index/layering.

Tokens should be represented in a technology-neutral naming model and mapped into Tailwind/shadcn implementation primitives.

Example naming pattern:

- `--color-background`
- `--color-surface`
- `--color-text-primary`
- `--color-text-secondary`
- `--color-border`
- `--color-brand`
- `--color-success`
- `--color-warning`
- `--color-danger`
- `--color-info`
- `--space-1` through `--space-8`
- `--radius-sm`, `--radius-md`, `--radius-lg`
- `--shadow-sm`, `--shadow-md`, `--shadow-lg`

The exact visual values are an implementation decision and must remain centralized.

---

## 5. Color Semantics

Color must communicate semantic meaning consistently.

| Semantic | Typical use |
|---|---|
| Brand | Primary navigation, primary actions, identity |
| Success | Completed, ready, accepted, positive outcome |
| Warning | Needs attention, approaching threshold, provisional |
| Danger | Error, blocked, failed, destructive action |
| Info | Neutral guidance, explanations, informational status |
| Neutral | Supporting surfaces, secondary information |

Color must never be the sole carrier of meaning. Status must also have text, iconography, shape, or another accessible indicator.

The product should avoid implying that a user is personally "bad" because a skill gap exists. Language should describe capability state and actionable next steps.

---

## 6. Typography

The typography system must establish clear hierarchy for:

- page titles;
- section headings;
- card headings;
- body text;
- supporting text;
- labels;
- data values;
- captions;
- form helper text;
- validation messages.

Requirements:

- use a consistent type scale;
- maintain readable line height;
- avoid overly small body text;
- use weight changes before decorative effects;
- keep dense tables readable at normal zoom.

Numbers in analytics should use stable alignment and formatting so users can compare values quickly.

---

## 7. Spacing System

Use a small, consistent spacing scale.

The spacing scale should support:

- compact control groups;
- standard card padding;
- section separation;
- dashboard composition;
- mobile layouts;
- modal and drawer layouts.

Components must not introduce arbitrary spacing values unless there is a documented design reason.

---

## 8. Layout System

Career360 uses a responsive application shell with:

- global navigation/sidebar;
- top-level page context;
- optional breadcrumbs;
- content region;
- contextual actions;
- optional secondary panels.

### 8.1 Desktop

Desktop layouts may use multi-column arrangements for dashboards, tables, side panels, and detailed workflows.

### 8.2 Tablet

Secondary columns should collapse or transform into drawers/stacks while preserving task priority.

### 8.3 Mobile

Primary actions, core status, and essential information must remain accessible without horizontal scrolling wherever possible.

Tables may transform into stacked record views when a full table would become unusable.

---

## 9. Application Shell

The shared shell should include:

- product identity;
- role-aware navigation;
- current organization/context;
- user account controls;
- notifications;
- route context;
- responsive menu behavior.

Navigation must not become a dumping ground for every feature. Organize around user goals and role workflows.

---

## 10. Core Components

Career360 should maintain a reusable component library centered on:

- Button;
- Link;
- Icon Button;
- Input;
- Textarea;
- Select;
- Combobox;
- Checkbox;
- Radio Group;
- Switch;
- Date/Date Range controls;
- Form Field;
- Validation Message;
- Badge;
- Status Indicator;
- Tooltip;
- Alert;
- Card;
- Dialog;
- Drawer;
- Tabs;
- Accordion;
- Dropdown Menu;
- Popover;
- Breadcrumbs;
- Pagination;
- Table/Data Grid;
- Empty State;
- Skeleton;
- Spinner/Progress;
- Toast/Notification;
- File Upload;
- Metric Card;
- Chart Container;
- Timeline;
- Stepper;
- Progress Bar;
- Skill Chip;
- Evidence Card;
- Readiness Badge;
- Requirement Row;
- Opportunity Card;
- Training Card.

The implementation may use shadcn/ui primitives with Career360-specific compositions.

---

## 11. Buttons and Actions

Buttons must express clear intent.

Primary actions should be limited to the main task of a section or screen.

Destructive actions must require clear confirmation when irreversible or materially consequential.

Loading buttons must:

- prevent accidental duplicate submission where appropriate;
- preserve the action label or provide clear progress text;
- expose a disabled/busy state.

Actions should not disappear solely because the user lacks authorization. Where appropriate, the UI should explain restricted capability rather than create unexplained dead ends.

---

## 12. Forms

All forms must support:

- visible labels;
- helper text where needed;
- inline validation;
- server-side error handling;
- accessible focus movement;
- explicit required/optional indication;
- preservation of entered data after recoverable errors where safe.

Forms should group fields by user intent rather than database table structure.

### 12.1 Complex Configuration

Role Blueprint, assessments, training programs, and opportunities may use multi-step forms.

Each step should make clear:

- where the user is;
- what is complete;
- what remains;
- whether the data is saved;
- what validation blocks progression.

---

## 13. Tables and Data-Dense Interfaces

Tables are appropriate for administration, comparison, tracking, and operational workflows.

Requirements:

- clear column labels;
- stable numeric alignment;
- useful sorting and filtering;
- pagination or virtualization where needed;
- responsive behavior;
- row actions that remain discoverable;
- accessible headers and focus behavior.

Do not cram every field into the default table. Use detail views or expandable rows for secondary information.

---

## 14. Cards and Dashboards

A card must represent a coherent concept, not merely a visual container.

Metric cards should answer:

- what is being measured;
- current value;
- period or scope;
- comparison where useful;
- action or drill-down where relevant.

Dashboards should establish a clear hierarchy:

`Context → Key Outcome → Drivers/Gaps → Recommended Action → Detail`

Decorative charts without decision value should not be added.

---

## 15. Skill and Competency Components

Skills should be represented consistently across:

- profile pages;
- role blueprints;
- assessment results;
- skill-gap views;
- evidence;
- learning paths;
- matching;
- reports.

A skill display should make room for context such as:

- proficiency;
- target level;
- role requirement priority;
- evidence count;
- evidence freshness;
- source or confidence where relevant.

Competencies should be visually distinct from individual skills when the hierarchy matters.

---

## 16. Requirement and MoSCoW Presentation

Role requirements should clearly communicate:

- MUST;
- SHOULD;
- COULD;
- WON'T.

MUST requirements that block readiness should be visually prominent without using alarmist styling.

The UI must distinguish:

- requirement priority;
- current proficiency;
- evidence status;
- readiness impact.

These are related but not interchangeable concepts.

---

## 17. Evidence Presentation

Evidence is central to Career360's trust model.

Evidence cards should communicate:

- evidence type;
- related skill/competency;
- source;
- achieved date;
- validity/freshness where relevant;
- verification status;
- practical versus non-practical nature where relevant.

Users should be able to understand why a piece of evidence contributes to a capability claim.

A certificate should not visually imply practical competence unless the domain rules explicitly establish such a relationship.

---

## 18. Readiness States

Readiness should use a consistent visual language for:

- Not Assessed;
- Assessed;
- Gap Identified;
- In Training;
- Pending Reassessment;
- Provisionally Ready;
- Ready;
- Stale where supported.

The state label must be textual. Color and iconography are supporting cues.

A readiness display should make blockers visible and provide a path to supporting evidence or gap details.

---

## 19. Assessment Experience

Assessment screens should prioritize concentration and clarity.

Requirements include:

- clear progress;
- current question and context;
- keyboard-friendly controls;
- save/progress behavior where supported;
- explicit submission action;
- confirmation before final irreversible submission;
- clear error handling.

Results views should separate:

- overall score;
- per-skill performance;
- benchmark/target comparison;
- evidence generated;
- next recommended action.

---

## 20. Learning and Training Experience

Learning interfaces should distinguish between:

- course;
- learning path;
- project;
- lab;
- workshop;
- certification;
- mentorship;
- training program.

Training programs should make the role or cohort context explicit and connect modules to the intended skill gaps.

Progress displays should show meaningful progress rather than purely visual completion percentages.

---

## 21. Opportunities and Applications

Opportunity cards should surface:

- title;
- organization;
- opportunity type;
- role/skill alignment;
- key eligibility requirements;
- application deadline;
- current application status.

Matching information should be framed as guidance supported by evidence. Do not claim guaranteed selection.

Application timelines should use a consistent state language and make the next action obvious.

---

## 22. Analytics Visualization

Supported visualization patterns include:

- line charts for trends;
- bar charts for category comparison;
- radar charts where multidimensional skill profiles are genuinely useful;
- heatmaps for cohort/skill distributions;
- scatter plots for relationship exploration;
- funnels for opportunity progression;
- progress bars for completion or threshold tracking.

Every chart requires:

- title;
- unit or metric definition where non-obvious;
- accessible legend or labels;
- empty state;
- loading state;
- error state;
- text alternative or accessible data representation where necessary.

Avoid visualizations that imply statistical precision not supported by the underlying data.

---

## 23. Status, Feedback, and Notifications

Feedback must be timely and proportional.

Use:

- inline validation for field-specific problems;
- alerts for important page-level information;
- toasts for transient confirmations;
- banners for broader operational conditions;
- notifications for events that require later attention.

Errors should explain:

1. what happened;
2. what the user can do next;
3. whether the system preserved the entered work.

Do not expose raw stack traces, database messages, or internal identifiers.

---

## 24. Empty States

Every data-driven screen must define an intentional empty state.

An empty state should explain:

- why there is no data;
- whether this is expected;
- what action can create or reveal data;
- relevant next steps.

Examples:

- no assessments assigned;
- no evidence yet;
- no matching opportunities;
- no training assigned;
- no analytics for the selected period.

Empty must not look like a broken loading state.

---

## 25. Loading and Skeleton States

Use skeletons when the layout is known and a content load is expected to complete quickly.

Use explicit progress indicators for longer operations such as:

- report generation;
- large imports;
- assessment submission processing;
- asynchronous evidence evaluation;
- export creation.

Loading states must not create large layout shifts.

---

## 26. Error and Recovery UX

Errors fall into distinct categories:

- validation error;
- authorization error;
- not found;
- conflict/state error;
- transient server error;
- external dependency failure;
- asynchronous job failure.

The UI should provide the most appropriate recovery path for each category.

Repeated retries should be prevented when they could duplicate a mutation.

---

## 27. Responsive and Accessible Interaction

The product should support:

- keyboard-only navigation;
- visible focus states;
- logical tab order;
- screen-reader labels for controls;
- accessible dialogs and menus;
- sufficient touch target sizes;
- zoom without loss of essential functionality;
- reduced-motion preferences.

Complex charts, drag-and-drop workflows, or icon-only controls require accessible alternatives.

---

## 28. Content and UX Writing

Career360 product language should be:

- direct;
- respectful;
- action-oriented;
- evidence-based;
- understandable to students and non-technical institutional users.

Prefer:

> "2 critical skills still need evidence"

over vague:

> "Your profile is weak"

Prefer:

> "You are provisionally ready for this role; practical evidence is still required for API testing"

over:

> "Almost ready"

Do not make unsupported promises such as guaranteed placement or automatic job selection.

---

## 29. Confirmation and Destructive Actions

Confirmation dialogs should be reserved for actions with meaningful consequences, such as:

- deleting/deactivating records;
- final assessment submission;
- publishing a role or assessment;
- closing an application process;
- changing important role requirements.

The dialog should state the actual consequence and the action required.

---

## 30. File Upload UX

File uploads must communicate:

- supported file types;
- size limits;
- upload progress;
- validation failures;
- processing state;
- verification status where applicable.

For secure documents, the UI must not expose storage implementation details or signed object URLs unnecessarily.

---

## 31. Navigation and Information Architecture

Navigation should follow user tasks rather than internal service/module names.

Example high-level student navigation:

`Dashboard · Career Map · Assessments · Skills & Evidence · Learning · Opportunities · Applications · Portfolio`

Example college navigation:

`Dashboard · Students · Departments · Assessments · Skill Gaps · Learning/Training · Placements · Reports`

Example company navigation:

`Dashboard · Roles · Talent Pool · Training · Opportunities · Applications · Outcomes`

The final navigation may evolve with validated product usage, but the principle remains task-oriented navigation.

---

## 32. Theming and Dark Mode

The implementation should use token-based theming so light/dark themes can be supported without rewriting component logic.

Any theme must preserve:

- semantic contrast;
- focus visibility;
- status differentiation;
- chart readability;
- form validation clarity.

Theme-specific hard-coded colors inside individual components are discouraged.

---

## 33. Component Ownership and Reuse

Reusable components should live in a shared design-system/component area rather than being copied between feature modules.

Feature-specific compositions may wrap shared primitives when they encode meaningful domain behavior.

Examples:

- `ReadinessBadge` is reusable because readiness semantics are domain-wide.
- `GraduateBackendEngineerReadinessPanel` is feature-specific and should not become a generic component without demonstrated reuse.

---

## 34. Frontend Architecture Alignment

The design system is implemented within the chosen frontend stack:

- React;
- TypeScript;
- Vite;
- Tailwind CSS;
- shadcn/ui;
- TanStack Query for server state.

Design-system components must remain independent from backend implementation details. Domain data should enter components through typed view models or API contracts.

---

## 35. Verification Requirements

### Unit/Component Tests

Verify:

- visual states with deterministic props;
- validation behavior;
- keyboard interactions;
- disabled/loading behavior;
- accessibility attributes.

### Integration Tests

Verify:

- form submission;
- server validation display;
- authorization-driven states;
- loading/error/empty transitions.

### Browser Tests

Playwright should cover critical user journeys such as:

- student assessment completion;
- student readiness review;
- college cohort dashboard;
- company role creation;
- opportunity application;
- training enrollment/completion.

### Visual Regression

Use visual regression selectively for high-value shared components and critical page layouts. Do not make pixel-level snapshots the only acceptance mechanism.

---

## 36. Design-System Definition of Done

A design-system component is production-ready when:

1. its visual tokens are centralized;
2. its states are documented;
3. keyboard and accessibility behavior are defined;
4. loading/error/disabled/empty behavior is considered where relevant;
5. it has typed props and avoids unsafe escape hatches;
6. it is tested at the component level;
7. it works in supported responsive layouts;
8. it does not leak backend implementation details;
9. it reuses existing primitives rather than duplicating equivalent behavior;
10. it has a clear reason for existing as a shared component.

---

## 37. Non-Goals

The design system is not intended to:

- prescribe one visual layout for every feature;
- prevent legitimate feature-specific composition;
- maximize component count;
- replace product UX research;
- use animation or decoration as a substitute for clarity.

The goal is a consistent foundation that makes Career360 easier to understand, use, test, and evolve.
