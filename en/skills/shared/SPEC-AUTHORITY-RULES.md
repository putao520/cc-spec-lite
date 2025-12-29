# SPEC Absolute Authority Principles (SSOT - Single Source of Truth)

> This document defines SPEC authority principles, referenced by all skills as the single authoritative source

---

## Core Principles

```
┌─────────────────────────────────────────────────────────────────────────┐
│  What SPEC defines → is what we do                                      │
│  How SPEC defines → is how we do it                                    │
│  What SPEC doesn't define → cannot be assumed                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## SPEC Priority

```
SPEC > Task Description > AI Understanding > User Verbal Requests
```

- Any understanding conflicting with SPEC must follow SPEC
- Prohibit any deviation for "I think this is better"

## SPEC Verification Process

1. **Must completely read relevant SPEC documents before development**
2. **Must 100% understand each REQ-XXX, ARCH-XXX, DATA-XXX, API-XXX**
3. **Must stop and report for clarification when discovering SPEC contradictions or omissions**

## SPEC to Implementation Mapping

- Each SPEC ID must have clear code implementation
- Prohibit selective compliance, simplification, or extension of SPEC requirements
- When code conflicts with SPEC, change code not SPEC

## Mandatory Compliance Rules

### 1. Interface Method Determined by SPEC

- SPEC defines WebSocket → Must use WebSocket
- SPEC defines REST API → Must use REST API
- SPEC defines gRPC → Must use gRPC
- **Prohibited**: Change interface method because "some approach is better/easier"

### 2. API Endpoints Determined by SPEC

- Only request endpoints defined in 04-API-DESIGN.md
- **Prohibited**: Assume/invent APIs not in SPEC
- **Prohibited**: Use an API in code because "this API should exist"

### 3. Data Structure Determined by SPEC

- Request/response formats must match SPEC definitions
- **Prohibited**: Assume field names or structures different from SPEC

## Handling SPEC Issues

| Situation | Handling |
|-----------|----------|
| Required API doesn't exist | Stop, report SPEC defect, wait for architect to supplement |
| SPEC design unreasonable | Stop, report issue, wait for user decision |
| SPEC internal contradiction | Stop, report contradiction, wait for clarification |
| "I think we should do this" | Invalid, execute SPEC definition |

## Prohibited Behaviors

- ❌ **Unauthorized adaptation**: "SPEC says use A, but B is better" → Prohibited
- ❌ **Unauthorized assumption**: "This should exist" → Prohibited
- ❌ **Unauthorized simplification**: "Too complex, simplify it" → Prohibited
- ❌ **Unauthorized extension**: "SPEC doesn't say, but I think we should add" → Prohibited
- ❌ **Post-hoc rationalization**: "Code is done, make SPEC match code" → Prohibited
- ❌ **Selective compliance**: "This rule is unimportant, skip it" → Prohibited

## Code Must Specify SPEC Basis

Each implementation must clearly specify its SPEC source:

```python
# Implement REQ-AUTH-001: User login functionality
# Follow API-AUTH-001: POST /api/auth/login
def login(username: str, password: str) -> Token:
    ...
```

```typescript
/**
 * Implement REQ-USER-001: User list query
 * Follow API-USER-001: GET /api/users
 */
async function getUsers(): Promise<User[]> {
    ...
}
```

---

*This specification is referenced by the following skills: architect, programmer*
