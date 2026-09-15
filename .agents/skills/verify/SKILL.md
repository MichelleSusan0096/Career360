---
name: verify
description: Execute deterministic validation for Career360 changes and report evidence.
---
# Career360 Verify Skill

## Purpose
Use after implementation changes and before milestone completion. Prove correctness rather than assume it.

## Fast verification
Run the smallest meaningful checks for the changed scope: formatting/lint, type checking, compile/build, targeted tests, integration tests, and migration validation when relevant.

## Full verification
Before milestone completion, run the backend and frontend builds, relevant automated tests, migration checks, security/authorization checks, OpenAPI/contract validation, and browser validation for critical workflows.

## Evidence
Record the command executed, scope, exit status, failures, assumptions, and whether verification is complete or partial. Never claim a check was run when it was not.

## Failure handling
Preserve the first meaningful failure, identify the affected layer, fix or escalate, and rerun the relevant verification. Do not weaken tests to obtain a pass.

## Rule
A green suite does not override product, domain, or security rules.
