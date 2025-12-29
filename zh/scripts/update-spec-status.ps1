# update-spec-status.ps1
# Function: Auto-update requirement status in SPEC files
# Usage: .\update-spec-status.ps1 --req-ids "REQ-XXX REQ-YYY" --commit-hash "abc123" --issue "123"

#Requires -Version 5.1

param(
    [Alias("r")]
    [string]$ReqIds,

    [Alias("c")]
    [string]$CommitHash,

    [Alias("i")]
    [string]$Issue,

    [Alias("h")]
    [switch]$Help
)

$ErrorActionPreference = "Stop"

function Show-Help {
    @"
Usage: .\update-spec-status.ps1 --req-ids <REQ_IDS> --commit-hash <HASH> --issue <ISSUE>

Parameters:
  --req-ids, -r      Requirement ID list (space-separated)
  --commit-hash, -c  Git commit hash
  --issue, -i        GitHub Issue number

Examples:
  .\update-spec-status.ps1 -r 'REQ-AUTH-001 REQ-USER-002' -c 'a1b2c3d' -i '123'
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
if ([string]::IsNullOrEmpty($ReqIds)) {
    Write-ColorOutput "Error: Missing --req-ids parameter" "Red"
    exit 1
}

if ([string]::IsNullOrEmpty($CommitHash)) {
    Write-ColorOutput "Error: Missing --commit-hash parameter" "Red"
    exit 1
}

# Check if SPEC directory exists
if (-not (Test-Path "SPEC")) {
    Write-ColorOutput "Error: SPEC folder not found in current directory" "Red"
    exit 1
}

# Get current date
$CurrentDate = Get-Date -Format "yyyy-MM-dd"

function Update-SpecStatus {
    param([string]$ReqId)

    # Determine SPEC file based on REQ type
    $specFile = switch -Regex ($ReqId) {
        "^REQ-" { "SPEC/01-REQUIREMENTS.md" }
        "^ARCH-" { "SPEC/02-ARCHITECTURE.md" }
        "^DATA-" { "SPEC/03-DATA-STRUCTURE.md" }
        "^API-" { "SPEC/04-API-DESIGN.md" }
        default {
            Write-ColorOutput "Warning: Cannot recognize requirement ID type: $ReqId" "Yellow"
            return $false
        }
    }

    if (-not (Test-Path $specFile)) {
        Write-ColorOutput "Warning: SPEC file does not exist: $specFile" "Yellow"
        return $false
    }

    Write-ColorOutput "Updating requirement status: $ReqId" "Cyan"

    # Read file content
    $content = Get-Content $specFile -Encoding UTF8
    $updated = $false
    $newContent = @()

    foreach ($line in $content) {
        if ($line -match [regex]::Escape($ReqId)) {
            # Check if already completed
            if ($line -match "\[x\]") {
                $newContent += $line
            } else {
                # Replace [ ] with [x] and add completion info
                $updatedLine = $line -replace '\[ \]', '[x]'
                $updatedLine = "$updatedLine - Completed ($CurrentDate) [commit: $CommitHash]"
                if ($Issue) {
                    $updatedLine = "$updatedLine [Issue: #$Issue]"
                }
                $newContent += $updatedLine
                $updated = $true
            }
        } else {
            $newContent += $line
        }
    }

    # Write updated content if changes were made
    if ($updated) {
        $newContent | Set-Content $specFile -Encoding UTF8
        Write-ColorOutput "Updated: $ReqId" "Green"
        return $true
    } else {
        Write-ColorOutput "Warning: No pending requirement found: $ReqId" "Yellow"
        return $false
    }
}

function Update-Version {
    $versionFile = "SPEC/VERSION"

    if (-not (Test-Path $versionFile)) {
        Write-ColorOutput "Warning: VERSION file does not exist, skipping version update" "Yellow"
        return
    }

    # Read current version
    $currentVersion = (Get-Content $versionFile -Raw).Trim()

    # Check for version bump type
    $versionBump = $null

    foreach ($reqId in ($ReqIds -split '\s+')) {
        $cleanId = $reqId -replace '^\[', '' -replace '\]$', ''
        if ($cleanId -match "^REQ-") {
            # New feature, increment minor version
            $versionBump = "minor"
            break
        }
    }

    # If no version change needed
    if (-not $versionBump) {
        Write-ColorOutput "Warning: No version upgrade needed" "Yellow"
        return
    }

    # Parse version number
    if ($currentVersion -match '^v(\d+)\.(\d+)\.(\d+)$') {
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2]
        $patch = [int]$Matches[3]

        switch ($versionBump) {
            "major" {
                $major++
                $minor = 0
                $patch = 0
            }
            "minor" {
                $minor++
                $patch = 0
            }
            "patch" {
                $patch++
            }
        }

        $newVersion = "v$major.$minor.$patch"

        # Update version file
        $newVersion | Set-Content $versionFile -NoNewline
        Write-ColorOutput "Version updated: $currentVersion -> $newVersion" "Green"

        # Create Git tag
        try {
            git tag -a $newVersion -m "Release $newVersion" 2>$null
            Write-ColorOutput "Git tag created: $newVersion" "Green"
        } catch {
            Write-ColorOutput "Warning: Cannot create Git tag (may already exist)" "Yellow"
        }

        Write-ColorOutput "Suggestion: Push tag with: git push origin $newVersion" "Cyan"
    } else {
        Write-ColorOutput "Warning: Version format incorrect: $currentVersion" "Yellow"
    }
}

# Main processing
Write-ColorOutput "Starting SPEC status update..." "Cyan"

# Clean up REQ_IDS: remove brackets
$cleanReqIds = @()
foreach ($reqId in ($ReqIds -split '\s+')) {
    if ($reqId) {
        $cleanId = $reqId -replace '^\[', '' -replace '\]$', ''
        $cleanReqIds += $cleanId
    }
}

# Update status for each requirement
foreach ($reqId in $cleanReqIds) {
    Update-SpecStatus $reqId | Out-Null
}

# Update version
Update-Version

Write-ColorOutput "SPEC status update completed" "Green"

# Display summary
Write-Host ""
Write-Host "--- Update Summary ---"
Write-Host "Requirement IDs: $ReqIds"
Write-Host "Commit Hash: $CommitHash"
if ($Issue) {
    Write-Host "Issue Number: $Issue"
}
Write-Host "Update Date: $CurrentDate"
Write-Host "----------------------"
