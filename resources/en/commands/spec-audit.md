---
description: SPEC Review - Verify SPEC completeness and code consistency
argument-hint: [review scope(all/REQ-XXX)]
---

# SPEC Review Command

## Core Functionality

**Comprehensively review SPEC completeness and code implementation consistency**

- Verify all requirements have clear acceptance criteria
- Check code implementation consistency with SPEC
- Generate completeness report

---

## Execution Flow

### Phase 0: Automatic Scanning

```bash
echo "=== SPEC Review Started ==="

# 1. Check SPEC/ directory
if [ ! -d "SPEC" ]; then
    echo "❌ SPEC/ directory does not exist"
    echo "Please run /spec-init first to initialize SPEC"
    exit 1
fi

# 2. Count SPEC files
req_count=$(grep -c "REQ-" SPEC/01-REQUIREMENTS.md 2>/dev/null || echo 0)
arch_count=$(grep -c "ARCH-" SPEC/02-ARCHITECTURE.md 2>/dev/null || echo 0)
data_count=$(grep -c "DATA-" SPEC/03-DATA-STRUCTURE.md 2>/dev/null || echo 0)
api_count=$(grep -c "API-" SPEC/04-API-DESIGN.md 2>/dev/null || echo 0)

echo "Detected:"
echo "- Requirements (REQ-XXX): $req_count"
echo "- Architecture (ARCH-XXX): $arch_count"
echo "- Data (DATA-XXX): $data_count"
echo "- Interfaces (API-XXX): $api_count"
```

---

### Phase 1: Format Validation

```bash
# Run format validation
spec validate SPEC/ 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️ SPEC Format Validation Failed"
    echo "Please fix format issues first"
    exit 1
fi

echo "✅ SPEC Format Validation Passed"
```

**Check Items:**

| Check Item | Verification Content | Failure Handling |
|-----------|----------------------|------------------|
| File Completeness | 6 core files exist | Prompt for missing files |
| VERSION Format | v{major}.{minor}.{patch} | Prompt for format error |
| ID Format | REQ-XXX/ARCH-XXX/DATA-XXX/API-XXX | Prompt for ID format error |
| Document Structure | Title hierarchy, list format correct | Prompt for structure issues |

---

### Phase 2: Requirement Completeness Review

**Check each REQ-XXX individually:**

#### 2.1 Acceptance Criteria Check

```markdown
**Review Item: Each requirement has clear acceptance criteria**

Traverse all REQ-XXX in 01-REQUIREMENTS.md:

**REQ-XXX - [Requirement Name]**
- ✅ Has acceptance criteria
- ❌ Missing acceptance criteria → [Prompt to supplement]

**Example of missing acceptance criteria:**
❌ "User login" (no acceptance criteria)
✅ "User login"
   - Acceptance Criteria:
     - Support email and phone login
     - Lock account after 3 password failures
     - Return JWT Token on successful login
```

#### 2.2 Priority Check

```markdown
**Review Item: Each requirement has clear priority**

**REQ-XXX - [Requirement Name]**
- ✅ Has priority marker (P0/P1/P2)
- ❌ Missing priority → [Prompt to supplement]

**Priority Definition:**
- P0: Core functionality, must implement
- P1: Important functionality, should implement
- P2: Minor functionality, can be postponed
```

#### 2.3 Traceability Check

```markdown
**Review Item: Each requirement can be traced to code**

Check method:
1. Search for corresponding implementation in codebase
2. Check Git commit history for references

**REQ-XXX - [Requirement Name]**
- ✅ Code implemented (src/xxx/yyy.ts:123)
- ⚠️ Code partially implemented (missing ZZZ feature)
- ❌ Code not implemented → [Prompt if implementation needed]
```

---

### Phase 3: Architecture Consistency Review

**Check consistency between ARCH-XXX and actual code architecture:**

#### 3.1 Module Implementation Check

```markdown
**Review Item: Are architecture modules implemented**

**ARCH-XXX - [Module Name]**
- ✅ Code directory exists (src/modules/xxx/)
- ✅ Module interface complete (index.ts exports all APIs)
- ❌ Module not found → [Prompt if creation needed]
```

#### 3.2 Technology Stack Consistency

```markdown
**Review Item: Does actual technology stack match SPEC**

**SPEC Definition:**
- Backend Framework: NestJS
- Database: PostgreSQL
- ORM: Prisma

**Actual Check:**
- ✅ package.json contains @nestjs/core
- ✅ package.json contains @prisma/client
- ❌ PostgreSQL-related configuration not found → [Prompt to fix]
```

#### 3.3 Dependency Relationship Verification

```markdown
**Review Item: Are inter-module dependencies consistent with SPEC**

**ARCH-001** - User Module
- SPEC dependency: Authentication module
- Actual code check:
  - ✅ import { auth } from '../auth'
  - ❌ Dependency not found → [Prompt to fix]
```

---

### Phase 4: Data Model Review

**Check consistency between DATA-XXX and database schema:**

#### 4.1 Table Structure Check

```markdown
**Review Item: Are database tables consistent with SPEC**

**DATA-USER-001** - users table
- SPEC Definition: fields id, email, password_hash, created_at
- Actual check:
  - Prisma schema: ✅ Contains all fields
  - Database table: ⚠️ Missing index idx_email
  - Suggestion: Run migration to add index
```

#### 4.2 Relationship Completeness

```markdown
**Review Item: Are foreign key relationships correctly established**

**DATA-ORDER-001** - orders table
- SPEC Definition: Associated with users (user_id)
- Actual check:
  - ✅ Foreign key constraint exists
  - ✅ Cascade delete configuration correct
```

#### 4.3 Index Verification

```markdown
**Review Item: Required query indexes exist**

**DATA-PRODUCT-001** - products table
- SPEC Definition: Indexes idx_category, idx_price
- Actual check:
  - ✅ idx_category exists
  - ❌ idx_price missing → [Performance risk, prompt to add]
```

---

### Phase 5: CLAUDE.md Compliance Review

**Check if CLAUDE.md content follows "SPEC pointer" positioning:**

#### 5.1 Content Nature Check

```markdown
**Principle: CLAUDE.md = SPEC pointer, not design document**

**✅ Allowed Content:**
- SPEC location instructions (./SPEC/ or ../SPEC/)
- Project-specific constraints and development process references
- Role分工 description (brief)
- References to processes and standards (point to authoritative documents)

**❌ Forbidden Content (must be in SPEC):**
- Functional requirement definitions
- Module list and responsibility tables
- Technology stack detailed descriptions
- Data model definitions (table structures, field lists)
- API interface definitions (endpoints, request/response formats)
- ID format definitions (REQ-XXX, ARCH-XXX, etc.)
- Architecture principles and design pattern descriptions
- Detailed workflow steps
```

#### 5.2 Violation Content Detection

```markdown
**Detection Method:**
1. Search for requirement definition keywords ("需求", "功能", "REQ-")
2. Search for architecture design content (module lists, technology stack tables)
3. Search for data model definitions (table structures, field lists)
4. Search for API definitions (endpoints, interface formats)

**CLAUDE.md - Compliance Check:**
- ✅ Contains only SPEC location instructions
- ✅ Contains only specific constraint descriptions
- ⚠️ Contains process descriptions (should reference rather than define)
- ❌ Contains requirement definitions → [Suggest moving to SPEC/01-REQUIREMENTS.md]
- ❌ Contains module list table → [Suggest moving to SPEC/02-ARCHITECTURE.md]
- ❌ Contains data model table → [Suggest moving to SPEC/03-DATA-STRUCTURE.md]
- ❌ Contains API endpoint list → [Suggest moving to SPEC/04-API-DESIGN.md]
```

#### 5.3 Correct Examples

```markdown
**✅ Correct CLAUDE.md (Business Project):**
```markdown
## SPEC Location
- ./SPEC/

## Product-level SPEC Location (if applicable)
- ../SPEC/
```

**✅ Correct CLAUDE.md (Framework Project, e.g., cc-spec-lite):**
```markdown
## SPEC Location
- ./SPEC/

## Framework Positioning
This is a SPEC-driven development framework, defining development processes and standards.

For detailed specifications, see:
- skills/ directory: Skill definitions
- commands/ directory: Custom commands
- roles/ directory: Role specifications

User projects should use simplified CLAUDE.md (SPEC location only).
```

**❌ Incorrect CLAUDE.md Example:**
```markdown
## Functional Requirements
- REQ-AUTH-001: User login
- REQ-AUTH-002: User registration

## Module List
| Module | Responsibility |
|-------|---------------|
| auth  | Authentication |
| user  | User Management |

## Data Model
- users table: id, email, password
```

**Suggestion: Move the above content to corresponding SPEC files**
```

---

### Phase 6: API Consistency Review

**Check consistency between API-XXX and actual route definitions:**

#### 6.1 Interface Implementation Check

```markdown
**Review Item: Are API interfaces implemented**

**API-USER-001** - POST /api/users/register
- SPEC Definition: Create user
- Actual check:
  - ✅ Route registered (src/routes/users.ts:15)
  - ✅ Request parameters match SPEC
  - ❌ Response format mismatch → SPEC requires code/message, actual returns status
```

#### 6.2 Error Code Coverage

```markdown
**Review Item: Are defined error codes all implemented**

**API-ORDER-001** - GET /api/orders/:id
- SPEC Definition error codes:
  - 404: Order not found
  - 403: No permission to access
- Actual check:
  - ✅ 404 implemented
  - ❌ 403 not implemented → [Prompt to supplement]
```

#### 6.3 Authentication Authorization Check

```markdown
**Review Item: Are authenticated interfaces all protected**

**API-PAYMENT-001** - POST /api/payments
- SPEC Requirement: Requires Bearer Token authentication
- Actual check:
  - ✅ Has @UseGuards(AuthGuard) decorator
  - ✅ Token verification logic correct
```

---

### Phase 7: Generate Review Report

```markdown
# SPEC Review Report

Generated at: $(date)

## 📊 Overall Score

| Dimension | Score | Status |
|-----------|-------|--------|
| Format Completeness | 100% | ✅ |
| Requirement Completeness | 85% | ⚠️ |
| Architecture Consistency | 90% | ✅ |
| Data Consistency | 75% | ⚠️ |
| API Consistency | 95% | ✅ |
| CLAUDE.md Compliance | 100% | ✅ |

**Overall Score: 89%**

---

## ✅ Passed Items

**Format Validation:**
- ✅ All file formats correct
- ✅ ID formats compliant
- ✅ VERSION format correct

**Architecture Consistency:**
- ✅ All ARCH-XXX modules implemented
- ✅ Technology stack matches SPEC

**API Consistency:**
- ✅ 95% of APIs implemented
- ✅ Error code definitions complete

---

## ⚠️ Warning Items

**Requirement Completeness:**
- ⚠️ REQ-USER-005 missing acceptance criteria
- ⚠️ REQ-ORDER-003 priority not defined

**Data Consistency:**
- ⚠️ DATA-PRODUCT-001 missing idx_price index
- ⚠️ DATA-ORDER-001 foreign key cascade rules not implemented

---

## ❌ Failed Items

**Requirement Implementation Incomplete:**
- ❌ REQ-CHECKOUT-001 code not implemented
- ❌ REQ-PAYMENT-002 code partially implemented (missing refund functionality)

**Suggestions:**
1. Supplement missing acceptance criteria
2. Implement incomplete requirements
3. Add missing database indexes
4. Fix API response format inconsistencies

---

## 📋 Problem List

| ID | Type | Severity | Description | Suggestion |
|----|------|----------|-------------|------------|
| 1 | Requirement | Medium | REQ-USER-005 missing acceptance criteria | Supplement acceptance criteria |
| 2 | Requirement | High | REQ-CHECKOUT-001 not implemented | Implement this feature |
| 3 | Data | Medium | DATA-PRODUCT-001 missing index | Add idx_price |
| 4 | API | Medium | API-USER-001 response format mismatch | Correct to code/message |

---

## 🎯 Improvement Suggestions

1. **Requirement Completeness**
   - Supplement acceptance criteria for all requirements
   - Clarify priorities for all requirements
   - Implement all unfinished requirements

2. **Data Consistency**
   - Run database migration to add missing indexes
   - Implement all foreign key constraints

3. **API Consistency**
   - Fix response format inconsistency issues
   - Supplement missing error code handling

4. **Documentation Updates**
   - Update SPEC promptly to reflect latest implementation
   - Ensure SPEC and code remain synchronized
```

---

## Completion Prompt

```markdown
✅ SPEC Review Completed!

**Review Results:**
- Format Completeness: ✅ 100%
- Requirement Completeness: ⚠️ 85%
- Architecture Consistency: ✅ 90%
- Data Consistency: ⚠️ 75%
- API Consistency: ✅ 95%
- CLAUDE.md Compliance: ✅ 100%

**Overall Score: 89%**

**Next Steps:**
1. 📝 View complete report: SPEC-AUDIT-REPORT.md generated
2. 🔧 Fix issues: Use /architect to correct SPEC
3. 💻 Complete implementation: Use /programmer to supplement code

**Priority Suggestions:**
1. Supplement missing acceptance criteria
2. Implement unfinished requirements
3. Add missing database indexes
```

---

## Collaboration with Other Commands

```
/spec-audit
    ↓ (discover issues and gaps)
/architect
    ↓ (correct SPEC)
/programmer
    ↓ (supplement implementation)
/spec-audit (review again, verify improvements)
```

---

## Review Standards

### Passing Criteria (all ✅)

- Format Completeness = 100%
- Requirement Completeness ≥ 90%
- Architecture Consistency ≥ 90%
- Data Consistency ≥ 90%
- API Consistency ≥ 90%
- CLAUDE.md Compliance = 100% (content follows SPEC pointer positioning)

### Excellence Criteria

- All dimensions ≥ 95%
- No warnings or failed items
- All requirements implemented

---

## Core Principles

**cc-spec-lite Simplified Version**

- ✅ Review only requirement completeness
- ✅ Check only code-SPEC consistency
- ✅ Review CLAUDE.md content compliance (must be SPEC pointer, no length limit)
- ❌ No test coverage management
- ❌ No code quality management
- ❌ No delivery standards

**CLAUDE.md Audit Focus:**
- ✅ Content nature: Whether it contains content that should be in SPEC
- ❌ No file length check: Framework projects can be long, business projects should be brief
- ✅ Content type: Requirements, architecture, data models, API definitions must be in SPEC

For testing, quality, and delivery related features, please use the full version cc-spec.