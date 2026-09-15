# Career360 — Security & Authorization

**Document:** `docs/07_security_authorization.md`  
**Status:** Product/Engineering Security Baseline  
**Applies to:** Authentication, authorization, tenant isolation, APIs, data access, documents, AI integrations, audit, sessions and operational security  
**Primary owner:** Engineering + Security  
**Related documents:** `docs/01_architecture_and_invariants.md`, `docs/02_domain_model.md`, `docs/06_data_contracts.md`

---

## 1. Purpose

Career360 is a multi-organization platform handling student profiles, assessments, capability evidence, institutional analytics, company requirements, opportunities, applications, documents and readiness decisions.

Security must therefore be treated as a product invariant rather than a feature added after functional development.

The security model must protect three things simultaneously:

```text
Identity
    ↓
Authorization
    ↓
Data isolation
    ↓
Decision integrity
```

A secure system must prevent both unauthorized access and unauthorized changes to authoritative capability/readiness information.

---

## 2. Security Objectives

Career360 security objectives are:

1. Only authenticated users can access protected resources.
2. Authentication does not imply authorization.
3. Every protected action is evaluated against organization, role and scope.
4. Tenant boundaries cannot be bypassed through request parameters or client manipulation.
5. Sensitive personal and security data is minimized and protected.
6. Authoritative assessment, evidence and readiness state cannot be casually altered.
7. Secrets never enter source control, browser bundles or ordinary logs.
8. AI providers receive only the minimum data required for the specific assistive task.
9. Security-sensitive events are auditable.
10. Failed authorization must not leak unnecessary resource existence or sensitive details.

---

## 3. Threat Model Scope

The baseline threat model includes:

```text
Unauthenticated internet user
Compromised user account
Malicious student/candidate
Malicious organization user
Cross-tenant access attempt
Privilege escalation attempt
Stolen browser/session token
Malicious uploaded file
Tampered webhook
AI prompt/data exfiltration risk
Database credential exposure
Abuse of public opportunity endpoints
```

The architecture should assume that the frontend can be manipulated and that all client-supplied authorization claims are untrusted.

---

## 4. Authentication vs Authorization

These are separate concerns.

### Authentication

Answers:

> Who is this user?

### Authorization

Answers:

> What may this authenticated user do with this resource in this context?

Spring Security is responsible for establishing the authenticated principal and enforcing the authorization framework.

Application/domain policies remain responsible for business-level authorization decisions.

---

## 5. Initial Authentication Architecture

The initial baseline is:

```text
React
  ↓
Spring Security
  ↓
JWT-based authentication
```

The architecture should keep authentication behind application abstractions so enterprise identity providers can be introduced later without rewriting domain logic.

Planned future options may include:

```text
Google OAuth2
Microsoft OAuth2 / OIDC
Keycloak
Enterprise IdP
TOTP MFA
```

These are integration choices, not domain concepts.

---

## 6. Credential Rules

Passwords, where password authentication is enabled, must never be stored in plaintext.

Use an industry-standard password hashing scheme provided through a maintained security library.

Never implement custom cryptography.

Authentication secrets must be supplied through environment/secret-management mechanisms.

The following must never be committed to the repository:

- JWT signing secrets,
- private keys,
- database passwords,
- object-storage credentials,
- AI provider keys,
- email provider credentials,
- OAuth client secrets.

---

## 7. Token Rules

JWTs, where used, should contain only the claims required for authentication and coarse authorization context.

Avoid putting mutable authorization facts such as detailed organization scope or resource permissions into long-lived tokens when those facts can change.

Critical authorization decisions should be based on current server-side membership and policy state.

Token expiry, refresh and revocation strategy must be explicit.

Do not treat the presence of a token as proof that a requested resource belongs to the user.

---

## 8. Session Security

The production browser strategy must protect tokens from unnecessary exposure.

The final mechanism may use secure cookies or another hardened token transport consistent with the chosen frontend/backend deployment model.

Required properties include:

```text
Secure transport
Short reasonable lifetime
Appropriate SameSite policy
CSRF protection where cookie-based authentication is used
Controlled refresh behavior
Logout / invalidation semantics
```

Do not store long-lived secrets in browser-readable persistent storage without a documented security justification.

---

## 9. Role Model

Career360 authorization combines:

```text
Identity
   +
Organization membership
   +
Role
   +
Resource scope
   +
Business state
```

Initial important roles include:

```text
SUPER_ADMIN
COLLEGE_ADMIN
HOD
FACULTY
PLACEMENT_OFFICER
COMPANY_ADMIN / COMPANY_RECRUITER
STUDENT
TUTOR / TRAINER where enabled by the learning/training domain
```

The exact final enum can evolve, but roles must remain coarse enough for maintainability and complemented by resource-level policies.

---

## 10. Organization Membership

Authorization must be membership-driven.

Conceptually:

```text
User
  ↓
Membership
  ↓
Organization
  ↓
Role + Scope
```

A request must not be authorized merely because the user possesses a role such as `COLLEGE_ADMIN`.

The server must establish that the user has that role for the relevant organization.

---

## 11. Tenant Isolation

Career360 is multi-tenant at the organization boundary.

Primary tenant rule:

> A user must never read or mutate another organization's protected data merely by changing an organization ID, resource ID or URL parameter.

Tenant context should be resolved from trusted authentication/membership context.

The client may indicate the selected organization context where product behavior requires it, but the backend must verify that the authenticated user belongs to that organization and is authorized within it.

---

## 12. Tenant Isolation Layers

Defense in depth should exist across:

```text
API authorization
      ↓
Application authorization
      ↓
Repository/query scoping
      ↓
Database constraints / RLS where selected
      ↓
Auditability
```

PostgreSQL Row Level Security may be used selectively for especially sensitive multi-tenant paths, but it must complement rather than replace Spring/application authorization.

---

## 13. Scope-Based Authorization

Career360 requires more than organization-wide roles.

Examples:

```text
HOD → own department
Faculty → assigned/own batch or permitted cohort
Placement Officer → placement-related college scope
Student → self
Company recruiter → own company and permitted requisitions
```

Scope must be evaluated on the server.

Never trust frontend filtering to enforce scope.

---

## 14. Authorization Decision Model

A protected action can be modeled as:

```text
ALLOW(action, actor, resource, organization, scope, state)
```

The result must account for:

- actor identity,
- active membership,
- assigned role,
- resource organization,
- hierarchical scope,
- business state,
- operation being attempted.

Example:

```text
Faculty + College A + Department C
    MAY
      read assigned student assessments
    MAY NOT
      read another college's student data
```

---

## 15. Role Matrix Baseline

| Role | Typical scope | Representative permissions |
|---|---|---|
| Super Admin | Platform | tenant/platform administration |
| College Admin | College | institution administration, reports, users |
| HOD | Department | department students, batches, assessments, reports |
| Faculty | Assigned scope | assessment/learning/cohort actions as permitted |
| Placement Officer | College placement scope | placement workflows, company/opportunity coordination |
| Company Admin | Company | company profile, roles, requisitions, team |
| Company Recruiter | Assigned company scope | role/opportunity and candidate workflow |
| Student | Self | own profile, assessments, evidence, learning, applications |
| Trainer/Tutor | Assigned training scope | assigned programs, sessions, learner progress |

The matrix is a baseline and must be refined when concrete use cases are implemented.

---

## 16. Object-Level Authorization

RBAC alone is insufficient.

A user can have permission to perform an action generally but still be forbidden for a specific object.

Examples:

```text
Faculty can view assessments
BUT
only assessments for permitted cohorts.
```

```text
Company recruiter can manage opportunities
BUT
only opportunities owned by their company.
```

```text
Student can update profile
BUT
cannot update authoritative assessment result or readiness state.
```

---

## 17. State-Aware Authorization

Authorization may depend on domain state.

Examples:

- Draft Role Blueprint may be editable by authorized company users.
- Published Role Blueprint may become immutable except through a new version workflow.
- Submitted assessment attempts may become read-only.
- Verified evidence should not be silently rewritten.
- Completed hiring outcomes should be protected from ordinary applicant mutation.

The backend must enforce these rules even when a user bypasses the UI.

---

## 18. Student Data Protection

Student data should follow data-minimization principles.

The platform should distinguish:

```text
Student-visible
College-visible
Company-visible
Staff-only
System-only
```

A student portfolio may be shareable while private contact or assessment details remain restricted.

Company matching should expose only the information necessary for the defined workflow and consent/policy model.

---

## 19. Assessment Integrity

Assessment results are authoritative capability evidence.

Controls should include:

- assignment ownership,
- attempt identity,
- submission finalization,
- server-side scoring where applicable,
- protection against client-side result tampering,
- audit history,
- controlled reopen/regrade paths.

The client must never be trusted to submit an arbitrary final score.

---

## 20. Evidence Integrity

Evidence should distinguish between:

```text
Submitted
Under Review
Verified
Rejected
Revoked / Superseded
```

Verification authority must be explicit.

An evidence record that contributes to authoritative readiness should not be silently deleted without preserving appropriate historical traceability.

---

## 21. Readiness Integrity

Readiness is a derived authoritative decision.

Therefore:

> No ordinary client should be able to directly set a candidate's readiness state.

The allowed pattern is:

```text
Evidence / Assessment / Training change
             ↓
      Readiness calculation
             ↓
      Policy evaluation
             ↓
     Readiness state/result
```

An administrator may have controlled override capabilities in exceptional workflows, but any override must be explicit, authorized, justified and audited.

---

## 22. Role Blueprint Integrity

Role Blueprints determine how readiness and matching are interpreted.

Published versions should be immutable or treated as immutable snapshots.

Changing a requirement materially should create a new version rather than mutate historical meaning.

Security and correctness therefore align:

```text
Published v1 → historical decisions use v1
New requirements → publish v2
```

---

## 23. API Security Rules

Every protected endpoint must define:

```text
Authentication required?
Organization scope?
Required permission?
Object-level policy?
State restrictions?
Input validation?
Audit requirement?
```

Never rely solely on URL obscurity, frontend route guards or hidden UI controls.

---

## 24. Mass Assignment Protection

Request DTOs must expose only fields the caller is allowed to modify.

Do not bind incoming JSON directly to persistence entities.

For example, a student profile update should not accept:

```text
role
organizationId
verifiedSkillScore
readinessState
accountStatus
```

unless those fields are explicitly part of a privileged operation with dedicated authorization.

---

## 25. Input Validation

All untrusted input must be validated.

Validation applies to:

- JSON payloads,
- query parameters,
- path identifiers,
- file metadata,
- uploaded document types,
- webhook payloads,
- imported CSV data,
- AI outputs before domain use.

Validation must cover format, size, length, range and business constraints as appropriate.

---

## 26. SQL and Persistence Security

The application must use parameterized queries and safe ORM/query abstractions.

Do not build SQL using string concatenation from user input.

jOOQ or Hibernate queries must still enforce tenant and scope predicates deliberately.

Database accounts should have only the privileges required by the application.

---

## 27. File Upload Security

Career360 stores resumes, certificates, portfolio artifacts and other documents.

File handling must include:

```text
Authenticated uploader
Authorization check
Allowed type policy
Size limit
Content-type validation
Safe object key generation
No executable serving path
Malware/security scanning where operationally available
Audit metadata
Short-lived access URL or server-mediated download
```

Never trust a filename or browser-provided MIME type as sufficient proof of file safety.

---

## 28. Object Storage Security

Cloudflare R2 is the initial object storage provider.

Application servers, not browsers, should control authorization for protected objects.

Bucket/container credentials must stay server-side.

Use least-privilege credentials scoped to required operations.

Public buckets should not be used for sensitive student or company documents.

---

## 29. AI Security and Privacy

AI is assistive infrastructure, not an authorization authority.

The system must decide what data may be sent to an AI provider before making the provider call.

The following principles apply:

```text
Minimize data
Remove unnecessary identifiers
Do not send secrets
Do not send authentication material
Do not expose unrestricted databases to the model
Treat model output as untrusted input
Validate structured output
Audit important AI-assisted actions
```

Student information should be minimized when the task can be completed using de-identified or reduced data.

---

## 30. AI Prompt-Injection Defense

External documents such as job descriptions, resumes and course material may contain adversarial text.

AI workflows must treat source documents as data, not as trusted instructions.

Conceptual boundary:

```text
Source document
   ↓
Extraction / sanitization
   ↓
Explicit system task
   ↓
Structured output schema
   ↓
Validation
   ↓
Human/domain review where required
```

No document content may override application authorization or system instructions.

---

## 31. Webhook Security

External callbacks such as learning completion or payment events must be authenticated and validated.

Controls may include:

- signed requests,
- shared-secret verification,
- timestamp/replay checks,
- source verification where available,
- idempotency keys,
- schema validation,
- audit logging.

Never trust an incoming webhook merely because its URL is difficult to guess.

---

## 32. Rate Limiting and Abuse Controls

Public and sensitive endpoints should have appropriate rate limits.

Higher-risk examples:

```text
Login
OTP/MFA endpoints
Password reset
Assessment submission
File upload
AI generation/extraction
Public opportunity search
Application submission
Webhook endpoints
```

Limits must be practical and observable rather than arbitrary.

---

## 33. Logging Rules

Logs must support incident investigation without becoming a source of data leakage.

Never log:

- passwords,
- access tokens,
- refresh tokens,
- MFA secrets,
- database credentials,
- object-storage credentials,
- AI API keys,
- full sensitive document contents.

Security logs should capture useful identifiers and outcomes without unnecessary personal data.

---

## 34. Audit Trail

The audit subsystem should capture security-sensitive and business-authoritative actions such as:

```text
Login success/failure where appropriate
MFA changes
Membership changes
Role/permission changes
User deactivation
Role Blueprint publication
Assessment finalization/regrade
Evidence verification
Readiness override
Opportunity publication
Application state changes
Employer feedback submission
Administrative exports
```

Audit records should include actor, organization, action, resource, timestamp and request/correlation context where appropriate.

---

## 35. Administrative Privilege Controls

High-privilege operations should require stronger safeguards.

Examples:

- changing roles/permissions,
- disabling users,
- cross-tenant platform administration,
- readiness override,
- bulk data export,
- security configuration changes.

Where appropriate, require recent authentication, MFA or elevated confirmation.

A broad `SUPER_ADMIN` role should not become the default mechanism for normal operational tasks.

---

## 36. Data Export Security

Exports can bypass normal UI-level fragmentation and therefore require explicit authorization.

Export endpoints must define:

```text
Who may export?
Which records?
Which fields?
Which time range?
How is the export generated?
Where is the file stored?
How long is it available?
Who accessed it?
```

Sensitive exports should not be indefinitely retained.

---

## 37. Deactivation and Soft Deletion

User and organization lifecycle operations should distinguish:

```text
ACTIVE
SUSPENDED
DEACTIVATED
ARCHIVED
```

Soft deletion is preferred where historical relationships are required.

Deactivation should revoke appropriate access without destroying the historical evidence needed for audits and outcomes.

---

## 38. Security of Background Jobs

Workers run with explicit service credentials and should not inherit unrestricted administrative privileges.

Each job should enforce the same tenant and data-scope rules as its synchronous counterpart.

A background worker must not bypass authorization simply because it is executing server-side.

Job payloads should reference identifiers rather than duplicate unnecessary personal information.

---

## 39. Database Security Baseline

The production database must have:

- TLS-protected connections,
- strong credentials,
- least-privilege application user,
- restricted network access,
- backups appropriate to the environment,
- monitoring,
- schema migration control,
- audit support for sensitive administrative operations.

The development environment must use separate credentials from production.

---

## 40. Secret Management

Configuration is divided into:

```text
Safe configuration
  public runtime flags, non-sensitive defaults

Secrets
  passwords, tokens, private keys, provider credentials
```

Secrets must be injected through environment/secret-management facilities.

Never commit `.env` files containing real credentials.

The `.gitignore` / `.antigravityignore` policy must prevent accidental inclusion of secret files where possible.

---

## 41. Environment Separation

At minimum:

```text
local/development
staging/test
production
```

Each environment must use separate credentials and data stores.

Production student data must never be copied into development casually.

When test data is needed, use synthetic or appropriately sanitized data.

---

## 42. Dependency Security

Third-party libraries must be maintained and inventoried.

Security updates should be evaluated through dependency tooling and regular maintenance.

Production dependencies must be justified by actual product/infrastructure needs.

Unnecessary security-sensitive dependencies should not be introduced merely for feature appearance.

---

## 43. Transport Security

All production user traffic must use HTTPS.

Internal service connections containing sensitive information must also use encrypted transport where applicable.

TLS certificate management must be delegated to maintained infrastructure rather than custom application code.

---

## 44. Browser Security Baseline

The frontend should apply appropriate browser security controls, including:

```text
Content Security Policy where practical
Secure cookie attributes when cookies are used
XSS-safe rendering
No secrets in client bundles
Controlled external resource origins
Safe file/download handling
```

Do not render arbitrary AI/model or uploaded HTML directly into the application.

---

## 45. Authorization Test Matrix

Every protected module should have tests for:

```text
Unauthenticated → denied
Authenticated wrong organization → denied
Authenticated right organization wrong role → denied
Authenticated right role wrong object scope → denied
Authenticated authorized → allowed
State-prohibited action → denied
Deactivated user → denied
Expired/invalid credential → denied
```

Negative authorization tests are as important as happy-path tests.

---

## 46. Security-Critical Domain Tests

Automated tests must cover at least:

- cross-tenant access prevention,
- student self-only mutations,
- staff scope boundaries,
- company recruiter organization boundaries,
- published Role Blueprint immutability/versioning,
- assessment result integrity,
- evidence verification transitions,
- readiness override permissions,
- export authorization,
- webhook authentication/idempotency.

---

## 47. Security and AI Decision Boundary

AI may assist with:

- JD extraction,
- skill normalization suggestions,
- gap explanations,
- training proposals,
- narrative reports,
- semantic similarity.

AI must not be the sole authority for:

- final hiring decisions,
- eligibility enforcement,
- assessment scoring where deterministic scoring is possible,
- canonical skill creation without validation,
- final role readiness.

Security and decision integrity require the same architecture:

```text
AI proposal
    ↓
Schema validation
    ↓
Domain validation
    ↓
Deterministic rules
    ↓
Authoritative state
```

---

## 48. Privacy-by-Design Rules

The platform should collect and retain only information required for a defined product purpose.

Every new sensitive field should answer:

```text
Why is this needed?
Who can read it?
Who can modify it?
How long should it exist?
Is it included in exports?
Is it sent to external providers?
Can the product work without it?
```

These questions should be documented before introducing new sensitive data.

---

## 49. Security Incident Readiness

Production operations should define procedures for:

```text
Credential compromise
Suspicious login activity
Cross-tenant access report
Data leakage
Malicious file detection
Provider compromise
Database exposure
AI provider incident
```

Operational runbooks belong in the appropriate deployment/security documentation rather than being embedded in application code.

---

## 50. Security Architecture Summary

The intended model is:

```text
                    ┌──────────────────────┐
                    │        User          │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Authentication       │
                    │ Spring Security      │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Identity + Membership│
                    │ Role + Organization  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Object / Scope Auth  │
                    │ State-aware Policy   │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴───────────┐
                    ▼                      ▼
          ┌──────────────────┐   ┌──────────────────┐
          │ Domain Operation │   │ Audit / Security │
          └────────┬─────────┘   └──────────────────┘
                   │
                   ▼
          ┌──────────────────┐
          │ PostgreSQL / R2  │
          │ Scoped + Secure  │
          └──────────────────┘
```

---

## 51. Security Checklist for New Features

Before a feature is accepted, verify:

- Authentication requirement is defined.
- Actor roles are defined.
- Organization scope is defined.
- Object-level authorization is defined.
- State restrictions are enforced server-side.
- Request DTOs prevent mass assignment.
- Sensitive fields are minimized.
- File access is authorized.
- Audit requirements are defined.
- Secrets are externalized.
- Logs do not leak sensitive data.
- AI/provider data sharing is justified.
- Negative authorization tests exist.
- Cross-tenant access has been tested.

---

## 52. Final Security Rule

> **Security in Career360 means preserving identity, tenant isolation, authorization boundaries and decision integrity at every layer. The frontend may guide a user, but only the backend and domain rules can authorize an action or establish authoritative career-readiness state.**
