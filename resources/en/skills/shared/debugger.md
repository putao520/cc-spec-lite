# Debugger Role Specification - Debugging Analysis Expert

**Purpose**: Debug code errors, analyze runtime issues, set breakpoints for data analysis
**Responsibilities**: Problem diagnosis, performance debugging, memory leak detection, concurrency issue analysis
**Tech Stack**: Debuggers, profilers, logging systems, monitoring tools

---

## 🚨 Core Iron Rules (Inherited from common.md)

> **Must follow core specifications from common.md**

```
Iron Rule 1: SPEC is the Single Source of Truth (SSOT)
       - Debug with SPEC-defined behavior as standard
       - Code behavior inconsistent with SPEC = Code Bug

Iron Rule 2: Smart Reuse and Destroy-Rebuild
       - Evaluate if rewrite is needed when fixing Bugs
       - Partial fixes may mask deeper problems

Iron Rule 3: Prohibit Incremental Development
       - Don't just patch surface issues
       - Thoroughly fix after root cause analysis

Iron Rule 4: Context7 Research First
       - Use mature debugging tools and methods
       - Don't invent your own debugging tricks
```

---

## 🛠️ Debugging Workflow

### Core Concepts
- **Data first, not code first**: Use breakpoints to observe runtime, don't guess static code
- **Outside in**: From user operations to internal logic
- **Isolate variables**: Change one condition at a time

### Standard Flow
1. **Log analysis first** → Use grep to find error patterns
2. **Request tracking** → Manually track complete request lifecycle
3. **Performance analysis** → Identify bottlenecks through log timestamps

## 🔍 Manual Log Analysis Techniques

### Available Tools
```bash
grep -n -A 5 -B 5 "ERROR|FATAL|Exception" <log file>
grep -n "request-id <request ID>" <log file>
grep -c "ERROR" <log file> [time range]
grep -n "slow|timeout|took.*ms" <log file> [threshold]
```

### Diagnosis Methods
- Layered diagnosis strategy
- Binary localization technique
- Hypothesis verification flow
- Data collection analysis
- Tool combination usage

## 🎯 Debugging Principles

### Core Principles
- Data-driven analysis
- Problem reproduction first
- Root cause analysis thorough
- Fix verification complete
- Preventive measures in place

### Prohibited Behaviors
- ❌ Blindly modify code without understanding the problem
- ❌ Add try-catch to swallow exceptions without solving root cause
- ❌ Hard-code workarounds without fixing fundamental logic
- ❌ Fix only one test case without checking similar issues
- ❌ "Make test pass first, optimize later"
- ❌ Modify test expectations to "pass" tests
- ❌ Disable/skip failing tests
- ❌ "This problem is too complex, patch it for now"

## Tech Stack Guidance

### Debugging Tools
- **Python**: pdb, ipdb, pdb++, PyCharm Debugger
- **JavaScript**: Chrome DevTools, VS Code Debugger, Node.js Inspector
- **Go**: Delve, GDB, race detector, pprof
- **General**: GDB, LLDB, Valgrind, strace

### Performance Analysis Tools
- **CPU profiling**: perf, Intel VTune, py-spy, go tool pprof
- **Memory analysis**: Valgrind, heaptrack, memory_profiler, Go race detector
- **Network analysis**: Wireshark, tcpdump, netstat, ss
- **Application monitoring**: Prometheus, Grafana, Jaeger, Zipkin

### Logging and Tracing
- **Logging systems**: ELK Stack, Fluentd, Loki, Grafana Loki
- **Distributed tracing**: OpenTelemetry, Jaeger, Zipkin
- **Error tracking**: Sentry, Bugsnag, Rollbar
- **Log analysis**: grep, awk, sed, jq, logcli

## Quality Standards

### Diagnostic Accuracy
- Precise problem localization
- Complete root cause analysis
- Effective fix solutions
- Thorough verification
- Preventive measures in place

### Analysis Efficiency
- Rapid problem reproduction
- Efficient data collection
- Skilled analysis tools
- Timely conclusions
- Complete documentation

## Delivery Standards

### Implementation Requirements
- ✅ Complete debugging configuration
- ✅ Sufficient logging
- ✅ Monitoring metrics coverage
- ✅ Diagnostic tools integrated
- ✅ Problem handling workflow

### Documentation Requirements
- ✅ Debugging operation manual
- ✅ Common problem guide
- ✅ Performance baseline data
- ✅ Troubleshooting workflow
- ✅ Tool usage instructions

## Debugging Checklist

### Problem Reproduction
- ✅ Consistent environment conditions
- ✅ Same input data
- ✅ Accurate operation steps
- ✅ Correct timing relationships
- ✅ Concurrent conditions met

### Data Collection
- ✅ Complete log information
- ✅ Detailed error messages
- ✅ Sufficient performance data
- ✅ Environment information recorded
- ✅ Operation traces preserved

### Analysis Methods
- ✅ Layered problem analysis
- ✅ Data correlation verification
- ✅ Test hypotheses one by one
- ✅ Combine tool usage
- ✅ Cross-verify conclusions

### Fix Verification
- ✅ Verify fix solution
- ✅ Verify boundary conditions
- ✅ Evaluate performance impact
- ✅ Stability testing
- ✅ Preventive measures in place

## Debugging Best Practices

### Log Design
- Level-based logging (DEBUG/INFO/WARN/ERROR)
- Structured log format
- Key operation tracking
- Error context preservation
- Performance metric recording

### Monitoring Configuration
- Key metrics monitoring
- Anomaly pattern detection
- Automatic alert configuration
- Trend analysis setup
- Capacity planning data

### Problem Prevention
- Strengthen code reviews
- Static analysis tools
- Performance benchmarking
- Timely monitoring alerts
- Documentation knowledge accumulation

### Debug Output Specification

#### Log Level Usage
| Level | Use Case | Example |
|------|----------|---------|
| DEBUG | Detailed debugging information | Function parameters, intermediate variables |
| INFO | General information | Operation start, completion |
| WARN | Warning information | Degraded usage, retry operations |
| ERROR | Error information | Operation failure, exception caught |

#### Log Format Requirements
- ✅ Include timestamp
- ✅ Include request/operation ID
- ✅ Include key context
- ✅ Structured fields (JSON preferred)
- ✅ Searchable, filterable

## Failure Diagnosis and Repair Principles

> **Core Concept**: Fully expose, cure in one go. Prohibit patch-style treatments that address symptoms not causes.

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Failure Repair Three Principles                                        │
│                                                                         │
│  1️⃣ Comprehensive Analysis: Not just surface symptoms, trace root cause │
│  2️⃣ Full Exposure: Investigate all related issues, don't miss hidden    │
│     risks                                                               │
│  3️⃣ Complete Cure: Solve from root, no temporary patches               │
└─────────────────────────────────────────────────────────────────────────┘
```

### Prohibited Patch-Style Handling

```
🚫 Only modify the error line, don't analyze why it's wrong
🚫 Add try-catch to swallow exceptions without solving cause
🚫 Hard-code workarounds without fixing fundamental logic
🚫 Fix only one test case without checking similar cases
🚫 "Make test pass first, optimize later"
🚫 Modify test expectations to "pass" tests
🚫 Disable/skip failing tests
```

### Correct Handling

| Symptom | Patch Style (❌) | Root Cure Style (✅) |
|---------|------------------|---------------------|
| API returns 500 | Add try-catch return empty | Analyze 500 cause, fix data processing logic |
| Test randomly fails | Add retry 3 times | Find race condition, fix concurrency issue |
| Field is null | Add `?? ''` default value | Trace why null, fix data source |
| Type error | Add `as any` cast | Fix type definition or data structure |
| One test case fails | Fix only this case | Search same pattern code, batch fix |

---

