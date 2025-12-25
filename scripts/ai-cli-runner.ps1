# ai-cli-runner.ps1 - AI CLI Tool Executor (PowerShell Version)
# Provides standardized injection text for AI CLI tools and executes them directly

#Requires -Version 5.1

$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "ai-cli-runner"
$SCRIPT_VERSION = "3.0.0"

function Show-Usage {
    @"
AI CLI Runner - AI CLI Tool Executor (Lite Version)

Usage: $SCRIPT_NAME <task_type> <spec_ids> <task_description> [task_context] [ai_tool] [provider]

Arguments:
  task_type          Task type (frontend, database, big-data, game, blockchain, ml, embedded, graphics, multimedia, iot, deployment, devops)
  spec_ids           Associated SPEC IDs, comma-separated (e.g., REQ-AUTH-001,ARCH-AUTH-001,API-AUTH-001)
  task_description   Task description
  task_context       (Optional) Task list and background info
  ai_tool            (Optional) AI agent selector, default: codex (options: claude, codex, gemini, all, "agent1|agent2")
  provider           (Optional) AI provider for routing (e.g., glm, openrouter, anthropic)

Examples:
  # Single requirement ID (using default codex)
  .\$SCRIPT_NAME.ps1 "frontend" "REQ-UI-005" "create React dashboard component"

  # Multiple associated IDs (requirement+architecture+API) using specified AI
  .\$SCRIPT_NAME.ps1 "backend" "REQ-AUTH-001,ARCH-AUTH-001,API-AUTH-001,API-AUTH-002" "implement JWT authentication" "" "claude"

Task Types:
  frontend, database/db, big-data/bigdata, game/gaming, blockchain/web3,
  ml/ai/machine-learning, embedded/mcu, graphics/rendering, multimedia/audio/video,
  iot/sensor, deployment, security, quality, debugger

AI Tools: claude, codex, gemini, all, "agent1|agent2" (default: codex)
Providers: glm, openrouter, anthropic, google, etc. (optional, for cost optimization)
"@
}

function Get-RolesPath {
    $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    return Join-Path $homePath ".claude" "roles"
}

function Get-SpecInjection {
    param([string]$SpecIds)

    if ([string]::IsNullOrEmpty($SpecIds)) {
        return Get-GeneralInjection
    }

    @"
===============================================================
  AI CLI Coding Execution Standards - SPEC Strict Compliance Mode
===============================================================

CRITICAL: SPEC is the Single Source of Truth (SSOT), Absolute Authority!

Important Reminders:
1. Task descriptions may be incomplete, SPEC is the only true requirement source
2. SPEC > Task Description > AI Understanding > Verbal Requests
3. Any understanding conflicting with SPEC must defer to SPEC
4. Discovery of SPEC contradictions or gaps must stop immediately and report

MANDATORY EXECUTION FLOW - Violation Means Failure:

Step 1: STOP coding immediately, verify SPEC authority
- Read all relevant SPEC documents completely
- Find detailed requirements for each SPEC ID (REQ-XXX, ARCH-XXX, DATA-XXX, API-XXX)
- Verify SPEC's functionality, performance, constraints, acceptance criteria
- Confirm task description consistency with SPEC, defer to SPEC on conflicts

Step 2: SPEC Completeness Verification
- Confirm specific requirements and constraints for each SPEC ID
- Identify tech stack, architecture patterns, data structures, interface specs
- Check for SPEC contradictions, gaps, or ambiguities
- Stop on issues found, wait for clarification, no autonomous decisions

Step 3: Fusion Principle Execution (Based on SPEC Authority)

3a. SPEC-Guided Deep Analysis:
- Comprehensive scan of existing modules: utilities, infrastructure, domain, platform-specific
- Precise matching assessment based on SPEC requirements: full match, partial, no match
- SPEC functional completeness verification: does existing implementation meet all SPEC requirements
- Smart reuse decision: Full match with SPEC -> direct reuse; otherwise destroy and rebuild

3b. SPEC-Driven Complete Rewrite:
- Delete all code violating SPEC, implement new solution from scratch
- Prohibit any incremental development: additions, compatibility code, migrations
- Each SPEC ID must have clear, fully SPEC-compliant implementation

3c. SPEC Absolute Compliance:
- Prohibit any "I think this is better" deviations from SPEC
- Prohibit simplification, extension, selective compliance with SPEC
- On code vs SPEC conflicts, change code not SPEC

Step 4: SPEC Verification
- Check each implementation item against SPEC
- Every SPEC-specified feature must be 100% implemented
- No TODO, FIXME, stub placeholders

PROHIBITED BEHAVIORS - Task Failure Markers:
- Starting to code without reading SPEC
- Believing task description is more accurate than SPEC
- "I think X is better than Y" deviations from SPEC
- "SPEC is too complex, let me simplify"
- "SPEC didn't say, but I think we should add"
- Implementing only partial SPEC requirements
- Using tech stack not specified in SPEC

REQUIRED STANDARDS - Success Markers:
- Must completely read relevant SPEC documents before coding
- Understand specific requirements and constraints of each SPEC ID
- Code implementation 100% consistent with SPEC
- Every SPEC requirement has clear code correspondence
- Report SPEC issues promptly instead of autonomous decisions

CORE PHILOSOPHY:
- SPEC is the Single Source of Truth (SSOT)
- Your understanding may be wrong, but SPEC is authoritative
- Task description is just a clue, SPEC is the truth
- Better to delay implementation than implement incorrectly

Remember: After receiving this prompt, your first action should be to READ SPEC, not start coding!
"@
}

function Get-GeneralInjection {
    @"
===============================================================
  AI CLI Coding Execution Standards - General Task Mode
===============================================================

TASK TYPE: General task without SPEC ID
Applicable scenarios: Bug fixes, small changes, tech debt, refactoring

EXECUTION REQUIREMENTS:

Step 1: Analyze Task Background
- Understand task description and specific problem to solve
- Review relevant code and documentation
- Identify scope of impact and dependencies

Step 2: Check Existing Implementation
- Analyze current state of related code
- Find root cause of the problem
- Understand existing architecture and design patterns

Step 3: Fusion Principle Implementation (General Task Mode)

3a. Deep Analysis (Reuse Assessment):
- Scan relevant code areas, look for fully matching existing implementations
- Assess if solution meets functionality, performance, constraint requirements
- Identify parts needing destroy and rebuild (partial or no match)

3b. Execution Strategy (General Software Development):
- Reusable: Existing implementation fully meets requirements, use directly
- Needs Rebuild: Existing implementation doesn't meet requirements, delete and reimplement from scratch
- Prohibited: Incremental modifications, compatibility code, incremental extensions, keeping old logic

3c. Fix Implementation:
- Apply best practices for specific problem types
- Maintain consistency with existing code architecture and style
- Ensure fix doesn't introduce new problems or tech debt

Step 4: Verification
- Verify fix resolves original problem
- Check for impact on other functionality
- Ensure code quality and maintainability

PROHIBITED BEHAVIORS:
- Blindly modifying code without understanding the problem
- Breaking existing architecture and design patterns
- Introducing unnecessary complexity
- Leaving TODO or FIXME placeholders

QUALITY REQUIREMENTS:
- Fully understand problem before making changes
- Maintain code style and architecture consistency
- Completely solve problem, no lingering issues
- Write clear comments explaining modification reasons
- Consider edge cases and exception handling

BEST PRACTICES:
- Understand existing code before modifying
- Prefer simplest effective solution
- Maintain code readability and maintainability
- Verify no existing functionality is broken after changes

Remember: For bug fixes, understanding the problem is more important than quick fixes!
"@
}

function Get-FusionPrinciples {
    @"

===============================================================
  Smart Reuse and Destroy-Rebuild Principles - AI Development Core Methodology
===============================================================

TARGET: Deep Reuse, Complete Rewrite (General Software Development)

SPEC Absolute Authority (SSOT Principle):
- SPEC is the only true requirement source, all decisions must follow SPEC
- SPEC > Task Description > AI Understanding > Verbal Requests
- Discovery of SPEC contradictions or gaps must stop immediately and report

Phase 1: SPEC-Guided Deep Analysis (Reuse Decision)
- Comprehensive scan of existing modules: utilities, infrastructure, domain, platform-specific
- Precise matching assessment based on SPEC requirements: full match, partial, no match
- SPEC functional completeness verification: does existing implementation meet all SPEC requirements
- Smart reuse decision:
  * Full match with SPEC -> direct reuse, no development needed
  * Partial/no match violating SPEC -> execute destroy and rebuild

Phase 2: SPEC-Driven Complete Rewrite (Destroy and Rebuild)
- Delete all code violating SPEC
- Design new implementation from scratch that fully complies with SPEC
- Prohibited incremental development behaviors:
  * Keep old implementation, add new features (violates SPEC completeness)
  * Compatibility code, support old interfaces (violates SPEC constraints)
  * Migration code, gradual conversion (introduces tech debt)
  * Extend existing implementation, add features (deviates from SPEC requirements)
  * Modify existing code, add parameters (breaks SPEC design)

Key Fusion Principles:
- Reuse based on SPEC functional completeness, not code similarity
- Partial match equals no match, must destroy and rebuild
- Strictly prohibit any SPEC-deviating incremental thinking
- Each SPEC ID must have clear, fully SPEC-compliant implementation
"@
}

function Get-CommonStandards {
    $rolesPath = Get-RolesPath
    $commonFile = Join-Path $rolesPath "common.md"

    $output = @"

===============================================================
  General Coding Standards - common.md
===============================================================

"@

    if (Test-Path $commonFile) {
        $output += Get-Content $commonFile -Raw
    } else {
        $output += "Warning: Common standards file not found: $commonFile"
    }

    return $output
}

function Get-DomainStandards {
    param([string]$TaskType)

    $rolesPath = Get-RolesPath

    $output = @"

===============================================================
  Domain-Specific Standards - Task Type: $TaskType
===============================================================

"@

    $standardsFile = switch -Regex ($TaskType) {
        "^backend$" {
            $output += "Backend development task (general): Using general coding standards (no domain-specific standards)`n"
            $null
        }
        "^(system|os)$" {
            $output += "System programming task: Using general coding standards (no domain-specific standards)`n"
            $null
        }
        "^frontend$" { "frontend-standards.md" }
        "^(database|db)$" { "database-standards.md" }
        "^(big-data|bigdata)$" { "big-data-standards.md" }
        "^(game|gaming)$" { "game.md" }
        "^(blockchain|web3)$" { "blockchain.md" }
        "^(ml|ai|machine-learning)$" { "ml.md" }
        "^(embedded|mcu)$" { "embedded.md" }
        "^(graphics|rendering)$" { "graphics.md" }
        "^(multimedia|audio|video)$" { "multimedia.md" }
        "^(iot|sensor)$" { "iot.md" }
        "^deployment$" { "deployment.md" }
        "^devops$" { "devops.md" }
        "^security$" { "security.md" }
        "^quality$" { "quality.md" }
        "^debugger$" { "debugger.md" }
        default {
            $output += "Unrecognized task type '$TaskType', using general coding standards only`n"
            $null
        }
    }

    if ($standardsFile) {
        $filePath = Join-Path $rolesPath $standardsFile
        if (Test-Path $filePath) {
            $output += Get-Content $filePath -Raw
        } else {
            $output += "Warning: Domain standards file not found: $filePath`n"
            $output += Get-FallbackStandards $TaskType
        }
    }

    return $output
}

function Get-FallbackStandards {
    param([string]$TaskType)

    switch -Regex ($TaskType) {
        "^deployment$" {
            @"
Deployment Requirements:
- Container configuration
- Environment variable management
- Health check mechanisms
- Log collection configuration
- Monitoring and alerting setup
- Automated deployment process
- Rollback mechanisms
"@
        }
        "^devops$" {
            @"
DevOps Requirements:
- CI/CD pipeline design
- Infrastructure as Code
- Security scanning integration
- Monitoring and logging systems
- Automated deployment
- Performance monitoring
- Failure recovery mechanisms
"@
        }
        "^security$" {
            @"
Security Development Requirements:
- Principle of least privilege
- Defense in depth strategy
- Input validation and sanitization
- Output encoding and escaping
- Authentication and authorization
- Session management
- Secure error handling
"@
        }
        "^quality$" {
            @"
Code Quality Requirements:
- Readability first
- Maintainability design
- SOLID principles application
- Code review
- Architecture pattern validation
- Performance analysis
"@
        }
        "^debugger$" {
            @"
Debug Analysis Requirements:
- Data-driven analysis
- Problem reproduction priority
- Thorough root cause analysis
- Complete fix verification
- Prevention measures in place
- Log analysis techniques
"@
        }
        default { "" }
    }
}

function Get-SpecIdGuidance {
    param([string]$SpecIds)

    if ([string]::IsNullOrEmpty($SpecIds)) {
        return ""
    }

    $branch = try { git rev-parse --abbrev-ref HEAD 2>$null } catch { "unknown" }
    $specVersion = if (Test-Path "SPEC/VERSION") { Get-Content "SPEC/VERSION" -Raw } else { "unknown" }

    @"

===============================================================
  SPEC IDs Associated with This Task
===============================================================

SPEC ID List: $SpecIds

You must find the specific content for these IDs in SPEC files:
  - REQ-XXX -> SPEC/01-REQUIREMENTS.md (Functional requirements and acceptance criteria)
  - ARCH-XXX -> SPEC/02-ARCHITECTURE.md (Architecture decisions and tech stack)
  - DATA-XXX -> SPEC/03-DATA-STRUCTURE.md (Data models and table structures)
  - API-XXX -> SPEC/04-API-DESIGN.md (Interface specs and error codes)

IMPORTANT: You must completely read these SPEC documents before coding!
DO NOT rely on task descriptions, SPEC is the true requirement source!

Project Info:
  Current Branch: $branch
  SPEC Version: v$specVersion
"@
}

function Get-TaskContext {
    param([string]$Context)

    if ([string]::IsNullOrEmpty($Context)) {
        return ""
    }

    @"

===============================================================
  Task Background and Checklist
===============================================================

The following is the task background information and checklist:

$Context

Please execute the development task based on the above background, understanding the overall goal and current progress.
"@
}

function Generate-Injection {
    param(
        [string]$TaskType,
        [string]$SpecIds,
        [string]$TaskContext
    )

    $injection = @"
=== AI CLI Standard Injection Text ===
Task Type: $TaskType
Associated SPEC ID: $SpecIds
Generation Time: $(Get-Date)

"@

    $injection += Get-SpecInjection $SpecIds
    $injection += Get-FusionPrinciples
    $injection += Get-CommonStandards
    $injection += Get-DomainStandards $TaskType
    $injection += Get-SpecIdGuidance $SpecIds
    $injection += Get-TaskContext $TaskContext

    return $injection
}

function Execute-Task {
    param(
        [string]$TaskType,
        [string]$SpecIds,
        [string]$TaskDescription,
        [string]$TaskContext = "",
        [string]$AiTool = "codex",
        [string]$Provider = ""
    )

    Write-Host "=== AI CLI Runner Executing Task ===" -ForegroundColor Cyan
    Write-Host "Task Type: $TaskType"
    Write-Host "Associated SPEC ID: $SpecIds"
    Write-Host "AI Tool: $AiTool"
    if ($Provider) {
        Write-Host "AI Provider: $Provider"
    }
    Write-Host "Task Description: $TaskDescription"
    if ($TaskContext) {
        Write-Host "Includes Task Background: Yes"
    }
    Write-Host "Execution Time: $(Get-Date)"
    Write-Host ""

    # Generate injection text
    Write-Host "Generating injection text..."
    $injectionText = Generate-Injection -TaskType $TaskType -SpecIds $SpecIds -TaskContext $TaskContext

    Write-Host "=== AI CLI Injection Text ===" -ForegroundColor Yellow
    Write-Host $injectionText
    Write-Host ""

    Write-Host "=== Executing AI CLI Command ===" -ForegroundColor Green

    $fullPrompt = @"
$TaskDescription

$injectionText
"@

    # Execute AI CLI command
    try {
        if ($Provider) {
            & aiw $AiTool -p $Provider $fullPrompt
        } else {
            & aiw $AiTool $fullPrompt
        }
        $exitCode = $LASTEXITCODE
    } catch {
        Write-Host "Error executing aiw: $_" -ForegroundColor Red
        $exitCode = 1
    }

    if ($exitCode -eq 0) {
        Write-Host "AI CLI task completed successfully" -ForegroundColor Green
    } else {
        Write-Host "AI CLI task failed (exit code: $exitCode)" -ForegroundColor Red
    }

    return $exitCode
}

function Validate-AiTool {
    param([string]$AiTool)

    $validTools = @("claude", "codex", "gemini", "all")

    if ($AiTool -in $validTools) {
        return $true
    }

    # Check for multi-tool format (e.g., "claude|gemini")
    if ($AiTool -match '\|') {
        $tools = $AiTool -split '\|'
        foreach ($tool in $tools) {
            if ($tool -notin $validTools[0..2]) {
                Write-Host "Error: Invalid AI tool '$tool'. Supported tools: claude, codex, gemini" -ForegroundColor Red
                return $false
            }
        }
        return $true
    }

    Write-Host "Error: Invalid AI tool '$AiTool'. Supported tools: claude, codex, gemini, all, or combination like 'claude|gemini'" -ForegroundColor Red
    return $false
}

# Main entry point
function Main {
    param([string[]]$Arguments)

    if ($Arguments.Count -eq 0) {
        Show-Usage
        exit 1
    }

    if ($Arguments.Count -lt 3) {
        Write-Host "Error: At least 3 arguments required: <task_type> <spec_ids> <task_description>" -ForegroundColor Red
        Write-Host "Full usage: $SCRIPT_NAME <task_type> <spec_ids> <task_description> [task_context] [ai_tool]"
        Show-Usage
        exit 1
    }

    $taskType = $Arguments[0]
    $specIds = $Arguments[1]
    $taskDescription = $Arguments[2]
    $taskContext = if ($Arguments.Count -ge 4) { $Arguments[3] } else { "" }
    $aiTool = if ($Arguments.Count -ge 5) { $Arguments[4] } else { "codex" }
    $provider = if ($Arguments.Count -ge 6) { $Arguments[5] } else { "" }

    # Validate AI tool
    if ($Arguments.Count -ge 5) {
        if (-not (Validate-AiTool $aiTool)) {
            exit 1
        }
    }

    # Execute task
    $exitCode = Execute-Task -TaskType $taskType -SpecIds $specIds -TaskDescription $taskDescription -TaskContext $taskContext -AiTool $aiTool -Provider $provider
    exit $exitCode
}

# Run main function with script arguments
Main $args
