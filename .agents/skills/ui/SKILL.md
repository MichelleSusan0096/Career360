---
name: ui
description: Build, review, and verify Career360 React interfaces using the design system and real workflows.
---
# Career360 UI Skill

## Purpose
Use for React/TypeScript pages, components, forms, dashboards, accessibility, responsiveness, API integration, and browser validation.

## Source of truth
Follow `docs/00_product_vision.md`, `docs/01_architecture_and_invariants.md`, `docs/05_readiness_matching.md`, `docs/11_opportunities_applications.md`, `docs/12_outcomes_analytics.md`, `docs/13_design_system.md`, and `.agents/rules/ui-craft.md`.

## Stack
Use React, TypeScript, Vite, Tailwind CSS, shadcn/ui, and TanStack Query.

## Components
Prefer reusable primitives, feature-level components, explicit typed props, and composition. Avoid giant components and duplicate interaction patterns.

## Server state
Use TanStack Query for API-backed state. Handle fetching, refetching, stale state, mutation pending, and mutation failures without duplicating authoritative server state unnecessarily.

## UI states
Data-driven screens must support Idle, Loading, Error, Empty, and Success/populated states.

## Readiness and matching
Make the basis of readiness understandable: target role, readiness state, critical requirements, blockers, evidence, freshness/confidence, and next action. Distinguish semantic similarity, eligibility, requirement satisfaction, and readiness.

## Forms and feedback
Validate clearly, preserve recoverable input, prevent duplicate mutations with pending/disabled states, and provide clear feedback for save, submit, publish, upload, enroll, apply, approve, reject, assign, and schedule.

## Accessibility
Use semantic HTML, keyboard navigation, visible focus, labels, accessible errors, logical headings, and non-color-only status indicators.

## Responsive behavior
Support expected laptop, tablet, and mobile widths without simply shrinking typography.

## API integration
Use real backend contracts. Do not leave fake data or client-only business rules in production paths.

## Analytics
Charts must represent real domain values with clear labels, context, units, useful empty states, and accessible summaries. Never invent KPIs.

## Browser verification
Use Playwright or approved browser tooling for critical flows, including authentication, navigation, important forms, readiness, and opportunity/application journeys as implemented.
