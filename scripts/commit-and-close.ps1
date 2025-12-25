# commit-and-close.ps1
# Function: Execute git commit + Close GitHub Issue + Auto-update SPEC status
# Usage: .\commit-and-close.ps1 --message "feat: xxx [REQ-XXX]" --issue 123

#Requires -Version 5.1

param(
    [Alias("m")]
    [string]$Message,

    [Alias("i")]
    [string]$Issue,

    [Alias("h")]
    [switch]$Help
)

$ErrorActionPreference = "Stop"

function Show-Help {
    @"
Usage: .\commit-and-close.ps1 --message <commit_message> --issue <issue_number>

Parameters:
  --message, -m  Commit message (must contain requirement ID, e.g., [REQ-XXX])
  --issue, -i    GitHub Issue number (optional, will auto-detect)

Examples:
  .\commit-and-close.ps1 -m 'feat: implement user auth [REQ-AUTH-001]' -i 123
  .\commit-and-close.ps1 -m 'feat: implement user auth [REQ-AUTH-001]'  # Auto-detect Issue
"@
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Show help if requested
if ($Help) {
    Show-Help
    exit 0
}

# Validate parameters
if ([string]::IsNullOrEmpty($Message)) {
    Write-ColorOutput "Error: Missing --message parameter" "Red"
    exit 1
}

# Auto-detect Issue number if not provided
if ([string]::IsNullOrEmpty($Issue)) {
    Write-ColorOutput "Warning: No Issue number provided, attempting auto-detection..." "Yellow"

    # Method 1: Get from most recent Issue
    try {
        $issueJson = gh issue list --limit 1 --search "sort:created-desc" --json number 2>$null
        if ($issueJson) {
            $issueData = $issueJson | ConvertFrom-Json
            if ($issueData -and $issueData.Count -gt 0) {
                $Issue = $issueData[0].number.ToString()
            }
        }
    } catch {
        # Ignore errors
    }

    # Method 2: Try to infer from branch name
    if ([string]::IsNullOrEmpty($Issue)) {
        try {
            $branchName = git branch --show-current 2>$null
            if ($branchName -match 'issue-?(\d+)') {
                $Issue = $Matches[1]
            }
        } catch {
            # Ignore errors
        }
    }

    # Method 3: Try to find from recent commit
    if ([string]::IsNullOrEmpty($Issue)) {
        try {
            $commitMsg = git log -1 --pretty=format:'%s' 2>$null
            if ($commitMsg -match '#(\d+)') {
                $Issue = $Matches[1]
            }
        } catch {
            # Ignore errors
        }
    }

    if ($Issue) {
        Write-ColorOutput "Auto-detected Issue number: $Issue" "Green"
    } else {
        Write-ColorOutput "Warning: Unable to auto-detect Issue number, will skip Issue closing" "Yellow"
    }
}

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Check if in git repository
try {
    git rev-parse --git-dir 2>$null | Out-Null
} catch {
    Write-ColorOutput "Error: Current directory is not a git repository" "Red"
    exit 1
}

# Check for staged changes
$stagedChanges = git diff --cached --quiet 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-ColorOutput "Warning: No staged changes detected, will stage all modified files" "Yellow"
    git add .
}

# 1. Execute git commit
Write-ColorOutput "Executing Git Commit..." "Cyan"
git commit --no-verify -m $Message
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Error: Git commit failed" "Red"
    exit 1
}

$CommitHash = git rev-parse --short HEAD
Write-ColorOutput "Git commit: $CommitHash" "Green"

# 1.1 Push code to remote
Write-ColorOutput "Pushing code to remote..." "Cyan"
git push 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Warning: Push failed, trying to set upstream branch..." "Yellow"
    $currentBranch = git branch --show-current
    git push -u origin $currentBranch 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Code pushed to remote (upstream branch set)" "Green"
    } else {
        Write-ColorOutput "Push failed, please manually execute: git push" "Red"
    }
} else {
    Write-ColorOutput "Code pushed to remote" "Green"
}

# 2. Close GitHub Issue (if Issue number exists)
if ($Issue) {
    Write-ColorOutput "Closing GitHub Issue #$Issue..." "Cyan"
    $issueComment = "Completed (commit: $CommitHash)"
    try {
        gh issue close $Issue -c $issueComment 2>$null
        Write-ColorOutput "Issue #$Issue closed" "Green"
    } catch {
        Write-ColorOutput "Warning: Unable to close Issue (may need gh auth login or Issue doesn't exist)" "Yellow"
    }
} else {
    Write-ColorOutput "Warning: Skipping Issue close (no Issue number)" "Yellow"
}

# 3. Parse requirement IDs (support multiple IDs)
$reqIds = @()
$patterns = @('\[REQ-[A-Z0-9-]+\]', '\[ARCH-[A-Z0-9-]+\]', '\[DATA-[A-Z0-9-]+\]', '\[API-[A-Z0-9-]+\]')

foreach ($pattern in $patterns) {
    $matches = [regex]::Matches($Message, $pattern)
    foreach ($match in $matches) {
        $reqIds += $match.Value
    }
}

$reqIdsString = ($reqIds -join ' ').Trim()

# 4. Auto-update SPEC status (if requirement IDs exist)
if ($reqIdsString) {
    Write-Host ""
    Write-ColorOutput "Auto-updating SPEC status..." "Cyan"
    Write-Host "Detected requirement IDs: $reqIdsString"

    # Call SPEC status update script
    $updateScript = Join-Path $ScriptDir "update-spec-status.ps1"
    if (Test-Path $updateScript) {
        try {
            & $updateScript -ReqIds $reqIdsString -CommitHash $CommitHash -Issue $Issue
            Write-ColorOutput "SPEC status updated successfully" "Green"
        } catch {
            Write-ColorOutput "Warning: SPEC status update failed (please update manually)" "Yellow"
            Show-ManualUpdateInstructions $reqIds $CommitHash $Issue
        }
    } else {
        Write-ColorOutput "Warning: update-spec-status.ps1 not found, skipping SPEC update" "Yellow"
        Show-ManualUpdateInstructions $reqIds $CommitHash $Issue
    }
} else {
    Write-ColorOutput "Warning: No requirement IDs detected, skipping SPEC status update" "Yellow"
}

function Show-ManualUpdateInstructions {
    param(
        [array]$ReqIds,
        [string]$CommitHash,
        [string]$Issue
    )

    Write-Host ""
    Write-ColorOutput "Please manually update SPEC files:" "Yellow"
    Write-Host ""
    Write-Host "Please complete the following updates in project SPEC files:"
    Write-Host ""
    Write-Host "1. Find the function description for related requirement IDs"
    foreach ($reqId in $ReqIds) {
        Write-Host "   - Search: $reqId"
    }
    Write-Host ""
    Write-Host "2. Mark status as completed [x]"
    Write-Host "   - Note implementation method (handwritten code/CRUD engine auto-generated/based on shared library XXX)"
    Write-Host "   - Add completion date: $(Get-Date -Format 'yyyy-MM-dd')"
    Write-Host "   - Add commit info: [commit: $CommitHash]"
    if ($Issue) {
        Write-Host "   - Add Issue info: [Issue: #$Issue]"
    }
    Write-Host ""
    Write-Host "3. Upgrade version number based on change type"
    Write-Host "   - New feature (feat:): minor version +1"
    Write-Host "   - Bug fix (fix:): patch version +1"
    Write-Host "   - Update SPEC/VERSION file"
    Write-Host ""
    Write-Host "4. Create Git Tag"
    Write-Host "   - git tag v<new_version>"
    Write-Host "   - git push origin v<new_version>"
}

Write-Host ""
Write-Host "---"
Write-ColorOutput "Script execution completed" "Green"

# Display summary
Write-Host ""
Write-Host "Execution Summary:"
Write-Host "- Commit Hash: $CommitHash"
Write-Host "- Commit Message: $Message"
Write-Host "- Requirement IDs: $(if ($reqIdsString) { $reqIdsString } else { 'None' })"
Write-Host "- Issue: $(if ($Issue) { $Issue } else { 'None' })"
Write-Host "- Execution Date: $(Get-Date -Format 'yyyy-MM-dd')"
