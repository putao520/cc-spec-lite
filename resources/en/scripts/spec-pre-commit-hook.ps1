# spec-pre-commit-hook.ps1
# SPEC Consistency Validation Pre-Commit Hook
#
# Installation:
#   Copy to .git/hooks/pre-commit (rename without .ps1 extension)
#   Or configure Git to use PowerShell for hooks
#
# Features:
#   1. Check if sensitive files are being committed
#   2. Check if code changes are associated with SPEC IDs
#   3. Validate SPEC file format integrity

#Requires -Version 5.1

$ErrorActionPreference = "Continue"

# Configuration
$SPEC_DIR = "SPEC"
$SPEC_ID_PATTERN = '(REQ|ARCH|DATA|API)-[A-Z0-9]+-[0-9]+'
$CODE_EXTENSIONS = '\.(go|ts|tsx|js|jsx|py|rs|java|kt)$'
$SENSITIVE_PATTERNS = '\.(env|pem|key)$|credentials|secret|password'

# Statistics
$script:Warnings = 0
$script:Errors = 0

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "  SPEC Pre-Commit Validation" "Cyan"
Write-ColorOutput "========================================" "Cyan"

# ============================================================
# Check 1: Sensitive File Detection
# ============================================================
function Test-SensitiveFiles {
    Write-ColorOutput "`n[1/3] Checking sensitive files..." "Cyan"

    $stagedFiles = git diff --cached --name-only 2>$null
    $sensitiveFiles = $stagedFiles | Where-Object { $_ -match $SENSITIVE_PATTERNS }

    if ($sensitiveFiles) {
        Write-ColorOutput "Error: Sensitive files detected:" "Red"
        foreach ($file in $sensitiveFiles) {
            Write-ColorOutput "   - $file" "Red"
        }
        Write-ColorOutput "   Tip: Use 'git reset HEAD <file>' to remove sensitive files" "Yellow"
        $script:Errors++
        return $false
    }

    Write-ColorOutput "OK: No sensitive files" "Green"
    return $true
}

# ============================================================
# Check 2: Code Change SPEC Association
# ============================================================
function Test-CodeSpecAssociation {
    Write-ColorOutput "`n[2/3] Checking code changes SPEC association..." "Cyan"

    $stagedFiles = git diff --cached --name-only 2>$null
    $codeFiles = $stagedFiles | Where-Object { $_ -match $CODE_EXTENSIONS }

    if (-not $codeFiles) {
        Write-ColorOutput "OK: No code file changes" "Green"
        return $true
    }

    $untrackedFiles = @()
    $trackedCount = 0
    $untrackedCount = 0

    foreach ($file in $codeFiles) {
        # Skip test files
        if ($file -match '_test\.go$|\.test\.(ts|js)$|\.spec\.(ts|js)$|test_.*\.py$') {
            continue
        }

        # Check if file content contains SPEC ID reference
        $fileContent = git diff --cached $file 2>$null | Where-Object { $_ -match '^\+' -and $_ -notmatch '^\+\+\+' }
        $contentString = $fileContent -join "`n"

        if ($contentString -match $SPEC_ID_PATTERN) {
            $trackedCount++
        } else {
            $untrackedFiles += $file
            $untrackedCount++
        }
    }

    if ($untrackedCount -gt 0) {
        Write-ColorOutput "Warning: Following code changes do not reference SPEC ID in code:" "Yellow"
        foreach ($file in $untrackedFiles) {
            Write-ColorOutput "   - $file" "Yellow"
        }
        Write-ColorOutput "   Tip: Add // REQ-XXX or // ARCH-XXX in comments" "Yellow"
        Write-ColorOutput "   Or include [REQ-XXX] in commit message" "Yellow"
        $script:Warnings++
    }

    if ($trackedCount -gt 0) {
        Write-ColorOutput "OK: $trackedCount file(s) associated with SPEC ID" "Green"
    }

    return $true
}

# ============================================================
# Check 3: SPEC File Format Validation
# ============================================================
function Test-SpecFormat {
    Write-ColorOutput "`n[3/3] Validating SPEC file format..." "Cyan"

    $stagedFiles = git diff --cached --name-only 2>$null
    $specFiles = $stagedFiles | Where-Object { $_ -match "^$SPEC_DIR/.*\.md$" }

    if (-not $specFiles) {
        Write-ColorOutput "OK: No SPEC file changes" "Green"
        return $true
    }

    $formatErrors = 0

    foreach ($specFile in $specFiles) {
        # Skip deleted files
        if (-not (Test-Path $specFile)) {
            continue
        }

        $filename = Split-Path $specFile -Leaf
        $content = Get-Content $specFile -Raw -ErrorAction SilentlyContinue

        if (-not $content) {
            continue
        }

        # Check 01-REQUIREMENTS.md format
        if ($filename -eq "01-REQUIREMENTS.md") {
            if ($content -notmatch '^## ') {
                Write-ColorOutput "Error: $specFile - Missing section header (## )" "Red"
                $formatErrors++
            }
            if ($content -notmatch 'REQ-[A-Z]+-[0-9]+') {
                Write-ColorOutput "Warning: $specFile - No REQ-XXX-NNN format requirement ID detected" "Yellow"
                $script:Warnings++
            }
        }

        # Check 02-ARCHITECTURE.md format
        if ($filename -eq "02-ARCHITECTURE.md") {
            if ($content -notmatch '^## ') {
                Write-ColorOutput "Error: $specFile - Missing section header (## )" "Red"
                $formatErrors++
            }
        }

        # Check 03-DATA-STRUCTURE.md format
        if ($filename -eq "03-DATA-STRUCTURE.md") {
            if ($content -notmatch 'DATA-[A-Z]+-[0-9]+' -and $content -match 'table|Table') {
                Write-ColorOutput "Warning: $specFile - Suggest adding DATA-XXX-NNN ID for data table definitions" "Yellow"
                $script:Warnings++
            }
        }

        # Check 04-API-DESIGN.md format
        if ($filename -eq "04-API-DESIGN.md") {
            if ($content -notmatch 'API-[A-Z]+-[0-9]+' -and $content -match '(GET|POST|PUT|DELETE|PATCH)') {
                Write-ColorOutput "Warning: $specFile - Suggest adding API-XXX-NNN ID for API endpoints" "Yellow"
                $script:Warnings++
            }
        }

        # General check: Prohibit TODO/FIXME in SPEC
        if ($content -match 'TODO|FIXME|TBD') {
            Write-ColorOutput "Warning: $specFile - Contains incomplete markers (TODO/FIXME/TBD)" "Yellow"
            $script:Warnings++
        }
    }

    if ($formatErrors -gt 0) {
        $script:Errors++
        return $false
    }

    Write-ColorOutput "OK: SPEC file format check passed" "Green"
    return $true
}

# ============================================================
# Check 4: Commit Message Hint (Optional)
# ============================================================
function Show-CommitMessageHint {
    Write-ColorOutput "`n[Hint] Commit Message Standard:" "Cyan"
    Write-Host "   Format: <type>(<scope>): <description> [REQ-XXX]"
    Write-Host "   Example: feat(auth): implement JWT verification [REQ-AUTH-001]"
    Write-ColorOutput "   Use commit-and-close.ps1 script to ensure compliance" "Yellow"
}

# ============================================================
# Main Flow
# ============================================================
function Main {
    # Check if in git repository
    try {
        git rev-parse --git-dir 2>$null | Out-Null
    } catch {
        Write-ColorOutput "Error: Not in a git repository" "Red"
        exit 1
    }

    # Check for staged changes
    $stagedChanges = git diff --cached --quiet 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "No staged changes, skipping checks" "Yellow"
        exit 0
    }

    # Execute checks
    Test-SensitiveFiles | Out-Null
    Test-CodeSpecAssociation | Out-Null
    Test-SpecFormat | Out-Null
    Show-CommitMessageHint

    # Output summary
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "  Validation Results" "Cyan"
    Write-ColorOutput "========================================" "Cyan"

    if ($script:Errors -gt 0) {
        Write-ColorOutput "Errors: $($script:Errors) | Warnings: $($script:Warnings)" "Red"
        Write-ColorOutput "Commit blocked, please fix the above errors" "Red"
        Write-ColorOutput "`nTo force commit (not recommended), use: git commit --no-verify" "Yellow"
        exit 1
    } elseif ($script:Warnings -gt 0) {
        Write-ColorOutput "Warnings: $($script:Warnings)" "Yellow"
        Write-ColorOutput "Commit allowed, but recommend fixing above warnings" "Green"
        exit 0
    } else {
        Write-ColorOutput "All checks passed" "Green"
        exit 0
    }
}

# Run main flow
Main
