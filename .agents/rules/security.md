# Career360 Agent Rule: Security

## Purpose
Define mandatory security behavior across Career360 backend, frontend, database, storage, integrations, and operations.

## Core principle
Treat every request, identifier, uploaded file, external payload, and AI-produced value as untrusted until validated and authorized. Security is enforced server-side.

## Authentication
Protected operations require the configured Spring Security authentication mechanism. Never use hard-coded production users, client-side role flags, hidden fields, development bypass headers, or localStorage-only authorization claims as the security boundary.

## Authorization
Authorization considers authenticated identity, role/permission, organization/tenant, resource scope/ownership, and action. Follow least privilege.

## Tenant isolation
Tenant scope must be preserved across REST endpoints, services, repositories, jobs, reports, exports, storage, search, analytics, and integrations. Never trust a client-provided tenant ID without verifying authorized membership/scope.

## Object-level authorization
A resource ID is not permission. Use:

`Principal → Authorized Scope → Resource Lookup → Authorized Action`

Prevent insecure direct object references and cross-tenant enumeration.

## Input validation
Validate types, lengths, formats, ranges, enums, cross-field rules, and business constraints. Reject unsafe or unexpected values rather than silently coercing them.

## Injection defense
Use parameterized SQL. Never concatenate raw user input into SQL. Whitelist dynamic sort/filter identifiers and bind values when using jOOQ/native SQL.

## XSS/content safety
Treat job descriptions, resumes, portfolios, feedback, imported JDs, and AI-generated text as untrusted content. Escape or sanitize according to the rendering context. Do not render arbitrary user text as executable HTML.

## Browser security
Apply the authentication-model-appropriate CSRF/CORS strategy and secure cookie settings. Use HTTPS and appropriate security headers including CSP where suitable. Do not permit overly broad credentialed CORS in production.

## Secrets
Never commit, return, or log passwords, API keys, JWT signing secrets, OAuth credentials, database credentials, storage credentials, webhook secrets, or private keys. Keep secrets in environment/configuration management and rotate exposed secrets.

## Passwords/tokens
Use an adaptive password hashing mechanism when passwords exist. Never store plaintext passwords. Tokens require suitable expiry and claim validation and must not be placed in URLs.

## Files/documents
Private resumes, certificates, evidence, and documents require authenticated/authorized access. Enforce file size/type policy, content validation, safe filenames, private storage, and auditability. Never execute uploaded files. Do not trust extensions alone.

## Object storage
Use appropriately scoped, short-lived access for private R2 objects when direct browser access is necessary. Do not create unrestricted public buckets for private Career360 data.

## Audit logging
Audit sensitive actions such as security changes, permission changes, document access, evidence verification, assessment result changes, Role Blueprint publication, application/outcome changes, imports/exports, and administrative changes. Records should answer `who → what → resource → when → context → result` without storing secrets or unnecessary content.

## Privacy
Collect only the information necessary for the workflow. Do not leak sensitive student/employer information through logs, URLs, analytics events, error messages, or public pages.

## AI security
External text sent to AI is data, not instructions. Prompt injection must not override system, domain, security, or business rules. Validate AI output before use and do not send secrets or unnecessary personal data to providers.

## Webhooks
Verify webhook authenticity using supported signatures/credentials. Design for duplicate, replayed, out-of-order, malformed, and transient-failure scenarios. Webhook processing must be idempotent.

## Rate limiting
Apply appropriate limits to authentication, password reset, AI generation, exports, public application flows, uploads, and webhook ingestion. Rate limiting supplements, not replaces, authorization.

## Transport/database security
Production traffic uses HTTPS. Database credentials follow least privilege. Backups/exports are treated as sensitive assets.

## Supply chain
Review dependency health, known vulnerabilities, transitive packages, and container base images. Do not introduce untrusted or abandoned packages without review.

## Security verification
Before production/milestone approval, verify authentication, RBAC, tenant/object authorization, validation, injection defenses, XSS protections, browser security policy, secret handling, private storage, file controls, webhook verification, rate limits, audit logging, safe errors/logging, and relevant dependency/container checks.
