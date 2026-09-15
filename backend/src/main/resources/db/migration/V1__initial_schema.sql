-- Career360 V1 - Initial PostgreSQL Schema
-- Scope: P0 foundation for the production/pilot core loop.
-- PostgreSQL is the authoritative transactional system of record.
-- Flyway migration: V1

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TYPE organization_type AS ENUM ('PLATFORM','COLLEGE','COMPANY');
CREATE TYPE membership_status AS ENUM ('INVITED','ACTIVE','SUSPENDED','REVOKED');
CREATE TYPE user_status AS ENUM ('PENDING','ACTIVE','SUSPENDED','DEACTIVATED');
CREATE TYPE role_scope AS ENUM ('PLATFORM','ORGANIZATION','DEPARTMENT','BATCH','SELF','OPPORTUNITY');
CREATE TYPE requirement_priority AS ENUM ('MUST','SHOULD','COULD');
CREATE TYPE skill_type AS ENUM ('TECHNICAL','SOFT','DOMAIN','TOOL','LANGUAGE','OTHER');
CREATE TYPE proficiency_scale AS ENUM ('BEGINNER','FOUNDATIONAL','INTERMEDIATE','ADVANCED','EXPERT');
CREATE TYPE role_status AS ENUM ('DRAFT','PUBLISHED','ARCHIVED');
CREATE TYPE assessment_status AS ENUM ('DRAFT','PUBLISHED','ARCHIVED');
CREATE TYPE question_type AS ENUM ('SINGLE_CHOICE','MULTIPLE_CHOICE','SHORT_TEXT','LONG_TEXT','NUMERIC','CODE','PRACTICAL');
CREATE TYPE assignment_status AS ENUM ('ASSIGNED','IN_PROGRESS','SUBMITTED','EXPIRED','CANCELLED');
CREATE TYPE attempt_status AS ENUM ('IN_PROGRESS','SUBMITTED','EVALUATED','CANCELLED');
CREATE TYPE evidence_type AS ENUM ('ASSESSMENT','PROJECT','PRACTICAL','LAB','INTERNSHIP','CERTIFICATION','COURSE','MENTOR','FACULTY','EMPLOYER','INTERVIEW','OTHER');
CREATE TYPE verification_status AS ENUM ('UNVERIFIED','PENDING','VERIFIED','REJECTED');
CREATE TYPE readiness_state AS ENUM ('NOT_ASSESSED','ASSESSED','GAP_IDENTIFIED','IN_TRAINING','PENDING_REASSESSMENT','PROVISIONALLY_READY','READY','STALE');
CREATE TYPE learning_item_type AS ENUM ('COURSE','PROJECT','LAB','WORKSHOP','CERTIFICATION','SIMULATION','MENTOR_SESSION','OTHER');
CREATE TYPE learning_item_status AS ENUM ('DRAFT','PUBLISHED','ARCHIVED');
CREATE TYPE training_status AS ENUM ('DRAFT','PLANNED','ACTIVE','COMPLETED','CANCELLED');
CREATE TYPE progress_status AS ENUM ('NOT_STARTED','IN_PROGRESS','COMPLETED','FAILED','DROPPED');
CREATE TYPE opportunity_type AS ENUM ('JOB','INTERNSHIP','OTHER');
CREATE TYPE opportunity_status AS ENUM ('DRAFT','PUBLISHED','CLOSED','ARCHIVED');
CREATE TYPE application_status AS ENUM ('APPLIED','SCREENING','SHORTLISTED','INTERVIEW','SELECTED','REJECTED','WITHDRAWN','HIRED');
CREATE TYPE outcome_type AS ENUM ('HIRED','PLACED','INTERNSHIP_COMPLETED','TRAINING_COMPLETED','TRAINING_DROPPED','NOT_SELECTED','OTHER');
CREATE TYPE audit_action AS ENUM ('CREATE','UPDATE','DELETE','READ_SENSITIVE','LOGIN','LOGOUT','ACCESS_DENIED','STATE_TRANSITION','EXPORT');
CREATE TYPE document_status AS ENUM ('PENDING','AVAILABLE','DELETED','QUARANTINED');
CREATE TYPE job_status AS ENUM ('PENDING','RUNNING','SUCCEEDED','FAILED','CANCELLED');

CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = CURRENT_TIMESTAMP; RETURN NEW; END;
$$;

-- Identity and organizations
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(320) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    first_name VARCHAR(120) NOT NULL,
    last_name VARCHAR(120),
    phone VARCHAR(40),
    status user_status NOT NULL DEFAULT 'PENDING',
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(80) UNIQUE,
    organization_type organization_type NOT NULL,
    legal_name VARCHAR(255),
    website VARCHAR(500),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE system_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(80) NOT NULL UNIQUE,
    description TEXT,
    is_system_role BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    system_role_id UUID NOT NULL REFERENCES system_roles(id),
    status membership_status NOT NULL DEFAULT 'INVITED',
    scope_type role_scope NOT NULL DEFAULT 'ORGANIZATION',
    scope_id UUID,
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(80),
    head_user_id UUID REFERENCES users(id),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (organization_id, name),
    UNIQUE (organization_id, code)
);

CREATE TABLE batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    department_id UUID REFERENCES departments(id),
    name VARCHAR(255) NOT NULL,
    academic_year VARCHAR(40),
    start_date DATE,
    end_date DATE,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    department_id UUID REFERENCES departments(id),
    batch_id UUID REFERENCES batches(id),
    student_number VARCHAR(100),
    admission_year INTEGER,
    graduation_year INTEGER,
    profile_visibility BOOLEAN NOT NULL DEFAULT FALSE,
    profile_summary TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (organization_id, student_number)
);

CREATE TABLE colleges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL UNIQUE REFERENCES organizations(id),
    university_name VARCHAR(255),
    accreditation TEXT,
    location VARCHAR(255),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL UNIQUE REFERENCES organizations(id),
    industry VARCHAR(255),
    size_band VARCHAR(80),
    description TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Skills and competencies
CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    canonical_name VARCHAR(255) NOT NULL UNIQUE,
    skill_type skill_type NOT NULL DEFAULT 'TECHNICAL',
    description TEXT,
    parent_skill_id UUID REFERENCES skills(id),
    embedding vector(1536),
    search_text TSVECTOR,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE skill_aliases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    alias VARCHAR(255) NOT NULL,
    source VARCHAR(120),
    confidence NUMERIC(5,4),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (skill_id, alias)
);

CREATE TABLE competencies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE competency_skills (
    competency_id UUID NOT NULL REFERENCES competencies(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    weight NUMERIC(8,4) NOT NULL DEFAULT 1.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (competency_id, skill_id)
);

CREATE TABLE student_skill_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    skill_id UUID NOT NULL REFERENCES skills(id),
    proficiency_level proficiency_scale NOT NULL,
    proficiency_score NUMERIC(6,3),
    confidence_score NUMERIC(6,3),
    observed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ,
    source_type VARCHAR(80),
    source_id UUID,
    is_authoritative BOOLEAN NOT NULL DEFAULT FALSE,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX uq_student_skill_authoritative ON student_skill_profiles(student_id, skill_id) WHERE is_authoritative;

-- Roles / Role Blueprints
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    family VARCHAR(255),
    status role_status NOT NULL DEFAULT 'DRAFT',
    current_version INTEGER NOT NULL DEFAULT 1,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    status role_status NOT NULL DEFAULT 'DRAFT',
    summary TEXT,
    source_type VARCHAR(80),
    source_reference TEXT,
    published_at TIMESTAMPTZ,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (role_id, version_number)
);

CREATE TABLE role_requirements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_version_id UUID NOT NULL REFERENCES role_versions(id) ON DELETE CASCADE,
    skill_id UUID REFERENCES skills(id),
    competency_id UUID REFERENCES competencies(id),
    priority requirement_priority NOT NULL,
    minimum_proficiency proficiency_scale,
    target_score NUMERIC(6,3),
    weight NUMERIC(8,4) NOT NULL DEFAULT 1.0,
    requirement_text TEXT,
    rationale TEXT,
    eligibility_rule JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (skill_id IS NOT NULL OR competency_id IS NOT NULL)
);

-- Assessments
CREATE TABLE assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status assessment_status NOT NULL DEFAULT 'DRAFT',
    current_version INTEGER NOT NULL DEFAULT 1,
    created_by UUID REFERENCES users(id),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assessment_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    status assessment_status NOT NULL DEFAULT 'DRAFT',
    instructions TEXT,
    duration_minutes INTEGER,
    max_score NUMERIC(10,3),
    published_at TIMESTAMPTZ,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assessment_id, version_number)
);

CREATE TABLE assessment_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_version_id UUID NOT NULL REFERENCES assessment_versions(id) ON DELETE CASCADE,
    question_order INTEGER NOT NULL,
    question_type question_type NOT NULL,
    prompt TEXT NOT NULL,
    points NUMERIC(8,3) NOT NULL DEFAULT 1.0,
    options JSONB,
    rubric JSONB,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assessment_version_id, question_order)
);

CREATE TABLE assessment_question_skills (
    question_id UUID NOT NULL REFERENCES assessment_questions(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id),
    weight NUMERIC(8,4) NOT NULL DEFAULT 1.0,
    PRIMARY KEY (question_id, skill_id)
);

CREATE TABLE assessment_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    assessment_version_id UUID NOT NULL REFERENCES assessment_versions(id),
    student_id UUID NOT NULL REFERENCES students(id),
    assigned_by UUID REFERENCES users(id),
    status assignment_status NOT NULL DEFAULT 'ASSIGNED',
    due_at TIMESTAMPTZ,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ
);

CREATE TABLE assessment_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id UUID NOT NULL REFERENCES assessment_assignments(id),
    student_id UUID NOT NULL REFERENCES students(id),
    assessment_version_id UUID NOT NULL REFERENCES assessment_versions(id),
    attempt_number INTEGER NOT NULL DEFAULT 1,
    status attempt_status NOT NULL DEFAULT 'IN_PROGRESS',
    started_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    evaluated_at TIMESTAMPTZ,
    total_score NUMERIC(10,3),
    max_score NUMERIC(10,3),
    percentage NUMERIC(6,3),
    evaluator_user_id UUID REFERENCES users(id),
    evaluation_metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, attempt_number)
);

CREATE TABLE assessment_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES assessment_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES assessment_questions(id),
    response_text TEXT,
    response_json JSONB,
    awarded_score NUMERIC(10,3),
    evaluator_feedback TEXT,
    evaluated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (attempt_id, question_id)
);

CREATE TABLE assessment_skill_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES assessment_attempts(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id),
    proficiency_level proficiency_scale,
    score NUMERIC(10,3),
    confidence_score NUMERIC(6,3),
    evidence_strength NUMERIC(6,3),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (attempt_id, skill_id)
);

-- Evidence
CREATE TABLE evidence_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    evidence_type evidence_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    source_name VARCHAR(255),
    source_reference TEXT,
    verification_status verification_status NOT NULL DEFAULT 'UNVERIFIED',
    verified_by UUID REFERENCES users(id),
    verified_at TIMESTAMPTZ,
    observed_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    confidence_score NUMERIC(6,3),
    provenance JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE evidence_skills (
    evidence_id UUID NOT NULL REFERENCES evidence_records(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id),
    proficiency_level proficiency_scale,
    score NUMERIC(10,3),
    weight NUMERIC(8,4) NOT NULL DEFAULT 1.0,
    PRIMARY KEY (evidence_id, skill_id)
);

CREATE TABLE skill_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    skill_id UUID NOT NULL REFERENCES skills(id),
    evidence_id UUID REFERENCES evidence_records(id),
    assessment_attempt_id UUID REFERENCES assessment_attempts(id),
    proficiency_level proficiency_scale NOT NULL,
    score NUMERIC(10,3),
    confidence_score NUMERIC(6,3),
    observed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ,
    observation_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Readiness and gaps
CREATE TABLE role_readiness (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    role_version_id UUID NOT NULL REFERENCES role_versions(id),
    state readiness_state NOT NULL DEFAULT 'NOT_ASSESSED',
    readiness_score NUMERIC(6,3),
    critical_blocker_count INTEGER NOT NULL DEFAULT 0,
    satisfied_requirement_count INTEGER NOT NULL DEFAULT 0,
    total_requirement_count INTEGER NOT NULL DEFAULT 0,
    evidence_confidence NUMERIC(6,3),
    evaluated_at TIMESTAMPTZ,
    stale_at TIMESTAMPTZ,
    explanation TEXT,
    calculation_version VARCHAR(80),
    calculation_input JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, role_version_id)
);

CREATE TABLE skill_gaps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    role_version_id UUID NOT NULL REFERENCES role_versions(id),
    role_requirement_id UUID REFERENCES role_requirements(id),
    skill_id UUID REFERENCES skills(id),
    competency_id UUID REFERENCES competencies(id),
    current_level proficiency_scale,
    required_level proficiency_scale,
    current_score NUMERIC(10,3),
    required_score NUMERIC(10,3),
    priority requirement_priority NOT NULL,
    gap_score NUMERIC(10,3),
    status VARCHAR(40) NOT NULL DEFAULT 'OPEN',
    explanation TEXT,
    identified_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMPTZ,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Learning
CREATE TABLE learning_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    item_type learning_item_type NOT NULL,
    status learning_item_status NOT NULL DEFAULT 'DRAFT',
    provider_name VARCHAR(255),
    external_url VARCHAR(1000),
    duration_minutes INTEGER,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE learning_item_skills (
    learning_item_id UUID NOT NULL REFERENCES learning_items(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id),
    target_proficiency proficiency_scale,
    weight NUMERIC(8,4) NOT NULL DEFAULT 1.0,
    PRIMARY KEY (learning_item_id, skill_id)
);

CREATE TABLE learning_paths (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    target_role_version_id UUID REFERENCES role_versions(id),
    status learning_item_status NOT NULL DEFAULT 'DRAFT',
    created_by UUID REFERENCES users(id),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE learning_path_items (
    learning_path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
    learning_item_id UUID NOT NULL REFERENCES learning_items(id),
    sequence_number INTEGER NOT NULL,
    required BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (learning_path_id, learning_item_id),
    UNIQUE (learning_path_id, sequence_number)
);

CREATE TABLE student_learning_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    learning_item_id UUID NOT NULL REFERENCES learning_items(id),
    status progress_status NOT NULL DEFAULT 'NOT_STARTED',
    progress_percentage NUMERIC(6,3) NOT NULL DEFAULT 0,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    result_score NUMERIC(10,3),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (student_id, learning_item_id)
);

-- Training
CREATE TABLE training_programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    target_role_version_id UUID REFERENCES role_versions(id),
    status training_status NOT NULL DEFAULT 'DRAFT',
    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ,
    created_by UUID REFERENCES users(id),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE training_program_gaps (
    training_program_id UUID NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    skill_gap_id UUID NOT NULL REFERENCES skill_gaps(id),
    PRIMARY KEY (training_program_id, skill_gap_id)
);

CREATE TABLE training_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    training_program_id UUID NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    learning_item_id UUID REFERENCES learning_items(id),
    title VARCHAR(255) NOT NULL,
    sequence_number INTEGER NOT NULL,
    scheduled_start TIMESTAMPTZ,
    scheduled_end TIMESTAMPTZ,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (training_program_id, sequence_number)
);

CREATE TABLE training_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    training_program_id UUID NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id),
    status progress_status NOT NULL DEFAULT 'NOT_STARTED',
    progress_percentage NUMERIC(6,3) NOT NULL DEFAULT 0,
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (training_program_id, student_id)
);

CREATE TABLE training_trainers (
    training_program_id UUID NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    trainer_user_id UUID NOT NULL REFERENCES users(id),
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (training_program_id, trainer_user_id)
);

CREATE TABLE reassessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    training_program_id UUID REFERENCES training_programs(id),
    prior_readiness_id UUID REFERENCES role_readiness(id),
    assessment_assignment_id UUID REFERENCES assessment_assignments(id),
    status VARCHAR(40) NOT NULL DEFAULT 'PENDING',
    scheduled_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    result_summary TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Opportunities, matching and applications
CREATE TABLE opportunities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    company_id UUID REFERENCES companies(id),
    title VARCHAR(255) NOT NULL,
    opportunity_type opportunity_type NOT NULL,
    description TEXT,
    location VARCHAR(255),
    remote_allowed BOOLEAN NOT NULL DEFAULT FALSE,
    status opportunity_status NOT NULL DEFAULT 'DRAFT',
    role_version_id UUID REFERENCES role_versions(id),
    openings INTEGER,
    published_at TIMESTAMPTZ,
    closes_at TIMESTAMPTZ,
    created_by UUID REFERENCES users(id),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE opportunity_eligibility_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    opportunity_id UUID NOT NULL REFERENCES opportunities(id) ON DELETE CASCADE,
    rule JSONB NOT NULL,
    is_mandatory BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE matching_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    opportunity_id UUID NOT NULL REFERENCES opportunities(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id),
    readiness_id UUID REFERENCES role_readiness(id),
    eligibility_passed BOOLEAN NOT NULL DEFAULT FALSE,
    match_score NUMERIC(8,3),
    skills_score NUMERIC(8,3),
    evidence_score NUMERIC(8,3),
    readiness_score NUMERIC(8,3),
    explanation TEXT,
    calculation_version VARCHAR(80),
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    UNIQUE (opportunity_id, student_id)
);

CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    opportunity_id UUID NOT NULL REFERENCES opportunities(id),
    student_id UUID NOT NULL REFERENCES students(id),
    matching_result_id UUID REFERENCES matching_results(id),
    status application_status NOT NULL DEFAULT 'APPLIED',
    applied_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    withdrawn_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (opportunity_id, student_id)
);

CREATE TABLE application_stage_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    from_status application_status,
    to_status application_status NOT NULL,
    changed_by UUID REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Outcomes and employer feedback
CREATE TABLE outcomes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    student_id UUID NOT NULL REFERENCES students(id),
    opportunity_id UUID REFERENCES opportunities(id),
    application_id UUID REFERENCES applications(id),
    outcome_type outcome_type NOT NULL,
    outcome_date DATE NOT NULL,
    employer_name VARCHAR(255),
    role_title VARCHAR(255),
    package_amount NUMERIC(14,2),
    package_currency CHAR(3),
    notes TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employer_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id),
    company_id UUID REFERENCES companies(id),
    student_id UUID REFERENCES students(id),
    opportunity_id UUID REFERENCES opportunities(id),
    role_version_id UUID REFERENCES role_versions(id),
    reviewer_user_id UUID REFERENCES users(id),
    overall_score NUMERIC(6,3),
    feedback_text TEXT,
    skill_feedback JSONB NOT NULL DEFAULT '{}'::jsonb,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- Industry intelligence foundation
CREATE TABLE industry_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    source_type VARCHAR(80) NOT NULL,
    source_name VARCHAR(255),
    source_uri VARCHAR(1000),
    publisher VARCHAR(255),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE industry_signals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    source_id UUID REFERENCES industry_sources(id),
    role_id UUID REFERENCES roles(id),
    skill_id UUID REFERENCES skills(id),
    observation_date DATE NOT NULL,
    context JSONB NOT NULL DEFAULT '{}'::jsonb,
    demand_value NUMERIC(12,4),
    confidence_score NUMERIC(6,3),
    extracted_text TEXT,
    normalized_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Documents / reports / notifications / jobs / audit
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    uploaded_by UUID REFERENCES users(id),
    storage_provider VARCHAR(80) NOT NULL DEFAULT 'R2',
    storage_key TEXT NOT NULL,
    original_filename VARCHAR(500) NOT NULL,
    content_type VARCHAR(255),
    byte_size BIGINT,
    checksum_sha256 CHAR(64),
    status document_status NOT NULL DEFAULT 'PENDING',
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (storage_provider, storage_key)
);

CREATE TABLE evidence_documents (
    evidence_id UUID NOT NULL REFERENCES evidence_records(id) ON DELETE CASCADE,
    document_id UUID NOT NULL REFERENCES documents(id),
    PRIMARY KEY (evidence_id, document_id)
);

CREATE TABLE report_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    requested_by UUID REFERENCES users(id),
    report_type VARCHAR(120) NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'PENDING',
    parameters JSONB NOT NULL DEFAULT '{}'::jsonb,
    result_document_id UUID REFERENCES documents(id),
    requested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    user_id UUID NOT NULL REFERENCES users(id),
    notification_type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    read_at TIMESTAMPTZ,
    action_url VARCHAR(1000),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    job_type VARCHAR(120) NOT NULL,
    status job_status NOT NULL DEFAULT 'PENDING',
    priority INTEGER NOT NULL DEFAULT 100,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    attempt_count INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 5,
    available_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    locked_at TIMESTAMPTZ,
    locked_by VARCHAR(255),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    last_error TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES organizations(id),
    actor_user_id UUID REFERENCES users(id),
    action audit_action NOT NULL,
    resource_type VARCHAR(120) NOT NULL,
    resource_id UUID,
    ip_address INET,
    user_agent TEXT,
    request_id VARCHAR(120),
    changes JSONB,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX ix_memberships_user_org ON memberships(user_id, organization_id, status);
CREATE INDEX ix_students_org_batch ON students(organization_id, batch_id);
CREATE INDEX ix_skills_name_trgm ON skills USING gin (canonical_name gin_trgm_ops);
CREATE INDEX ix_skills_search_text ON skills USING gin (search_text);
CREATE INDEX ix_skill_aliases_alias_trgm ON skill_aliases USING gin (alias gin_trgm_ops);
CREATE INDEX ix_roles_org_status ON roles(organization_id, status);
CREATE INDEX ix_roles_title_trgm ON roles USING gin (title gin_trgm_ops);
CREATE INDEX ix_role_requirements_version_priority ON role_requirements(role_version_id, priority);
CREATE INDEX ix_assessment_assignments_student ON assessment_assignments(student_id, status);
CREATE INDEX ix_assessment_attempts_student ON assessment_attempts(student_id, submitted_at DESC);
CREATE INDEX ix_evidence_student ON evidence_records(student_id, created_at DESC);
CREATE INDEX ix_skill_observations_student_skill ON skill_observations(student_id, skill_id, observed_at DESC);
CREATE INDEX ix_skill_gaps_student_role ON skill_gaps(student_id, role_version_id, status);
CREATE INDEX ix_role_readiness_student ON role_readiness(student_id, updated_at DESC);
CREATE INDEX ix_learning_items_title_trgm ON learning_items USING gin (title gin_trgm_ops);
CREATE INDEX ix_training_programs_org_status ON training_programs(organization_id, status);
CREATE INDEX ix_opportunities_status_close ON opportunities(status, closes_at);
CREATE INDEX ix_opportunities_title_trgm ON opportunities USING gin (title gin_trgm_ops);
CREATE INDEX ix_matching_opportunity_score ON matching_results(opportunity_id, match_score DESC);
CREATE INDEX ix_applications_student ON applications(student_id, status, updated_at DESC);
CREATE INDEX ix_applications_opportunity ON applications(opportunity_id, status);
CREATE INDEX ix_industry_signals_skill_date ON industry_signals(skill_id, observation_date DESC);
CREATE INDEX ix_industry_signals_role_date ON industry_signals(role_id, observation_date DESC);
CREATE INDEX ix_notifications_user_unread ON notifications(user_id, read_at, created_at DESC);
CREATE INDEX ix_jobs_claim ON jobs(status, priority, available_at);
CREATE INDEX ix_audit_org_created ON audit_records(organization_id, created_at DESC);
CREATE INDEX ix_audit_resource ON audit_records(resource_type, resource_id, created_at DESC);

-- Full-text search maintenance
CREATE OR REPLACE FUNCTION update_skill_search_text() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.search_text := to_tsvector('simple', COALESCE(NEW.canonical_name,'') || ' ' || COALESCE(NEW.description,''));
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_skills_search_text
BEFORE INSERT OR UPDATE OF canonical_name, description ON skills
FOR EACH ROW EXECUTE FUNCTION update_skill_search_text();

-- updated_at triggers
CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_organizations_updated_at BEFORE UPDATE ON organizations FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_memberships_updated_at BEFORE UPDATE ON memberships FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_departments_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_batches_updated_at BEFORE UPDATE ON batches FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_students_updated_at BEFORE UPDATE ON students FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_colleges_updated_at BEFORE UPDATE ON colleges FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_skills_updated_at BEFORE UPDATE ON skills FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_competencies_updated_at BEFORE UPDATE ON competencies FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_student_skill_profiles_updated_at BEFORE UPDATE ON student_skill_profiles FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_roles_updated_at BEFORE UPDATE ON roles FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_assessments_updated_at BEFORE UPDATE ON assessments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_evidence_records_updated_at BEFORE UPDATE ON evidence_records FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_role_readiness_updated_at BEFORE UPDATE ON role_readiness FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_learning_items_updated_at BEFORE UPDATE ON learning_items FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_learning_paths_updated_at BEFORE UPDATE ON learning_paths FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_student_learning_progress_updated_at BEFORE UPDATE ON student_learning_progress FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_training_programs_updated_at BEFORE UPDATE ON training_programs FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_training_enrollments_updated_at BEFORE UPDATE ON training_enrollments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_reassessments_updated_at BEFORE UPDATE ON reassessments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_opportunities_updated_at BEFORE UPDATE ON opportunities FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_applications_updated_at BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_documents_updated_at BEFORE UPDATE ON documents FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_jobs_updated_at BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Seed the fixed RBAC roles used by the initial authorization model
INSERT INTO system_roles (name, description) VALUES
('SUPER_ADMIN','Platform administration across all organizations'),
('COLLEGE_ADMIN','College-wide administration'),
('HOD','Department-level administration and analytics'),
('FACULTY','Assigned student, assessment and intervention access'),
('PLACEMENT_OFFICER','College placement and opportunity workflows'),
('STUDENT','Own profile, evidence, readiness and applications'),
('COMPANY_ADMIN','Company administration and role/program management'),
('RECRUITER','Authorized opportunity candidate and hiring workflows'),
('TRAINER','Assigned training program access'),
('EMPLOYER_REVIEWER','Authorized employer feedback access')
ON CONFLICT (name) DO NOTHING;

COMMENT ON TABLE organizations IS 'Tenant boundary for Career360.';
COMMENT ON TABLE role_versions IS 'Versioned role-blueprint snapshots preserving historical interpretability.';
COMMENT ON TABLE role_requirements IS 'Structured MUST/SHOULD/COULD role capability requirements.';
COMMENT ON TABLE evidence_records IS 'Evidence-backed capability claims with provenance and verification state.';
COMMENT ON TABLE role_readiness IS 'Authoritative role-specific readiness result derived from deterministic domain rules.';
COMMENT ON TABLE matching_results IS 'Derived explainable candidate-to-opportunity fit result; not application state.';
COMMENT ON TABLE outcomes IS 'Placement/training outcomes closing the Career360 feedback loop.';
COMMENT ON TABLE audit_records IS 'Security and business audit trail.';

-- Career360 database invariants
-- MUST requirements remain blockers unless domain policy explicitly overrides them.
-- AI-generated proposals must be validated before entering authoritative tables.
-- Historical facts must not be silently rewritten when current profiles change.

