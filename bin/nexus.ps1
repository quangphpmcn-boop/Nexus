# ============================================================
# Nexus CLI - Global wrapper for Nexus Framework
# Run from anywhere: nexus [options]
# ============================================================

param(
    [string]$ProjectPath = ".",
    [switch]$Force,
    [switch]$Dev,
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]$Commands
)

$NexusRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$NexusVersion = "3.1"

# --- Subcommands ---
$subcommand = if ($Commands.Count -gt 0) { $Commands[0] } else { $null }

switch ($subcommand) {
    "help" {
        Write-Host ""
        Write-Host "  NEXUS FRAMEWORK CLI v$NexusVersion" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "  Usage:" -ForegroundColor White
        Write-Host '    nexus                          Install Nexus into current project' -ForegroundColor Gray
        Write-Host '    nexus -ProjectPath "D:\App"    Install into specified project' -ForegroundColor Gray
        Write-Host '    nexus -Force                   Overwrite existing installation' -ForegroundColor Gray
        Write-Host '    nexus -Dev                     Dev mode (symlink instead of copy)' -ForegroundColor Gray
        Write-Host '    nexus help                     Show this help' -ForegroundColor Gray
        Write-Host '    nexus version                  Show version' -ForegroundColor Gray
        Write-Host ""
        Write-Host "  Source: $NexusRoot" -ForegroundColor DarkGray
        Write-Host ""
        return
    }
    "version" {
        Write-Host "Nexus Framework v$NexusVersion" -ForegroundColor Cyan
        Write-Host "Source: $NexusRoot" -ForegroundColor DarkGray
        return
    }
}

# --- Forward to installer ---
$installerPath = Join-Path $NexusRoot "install.ps1"

if (-not (Test-Path $installerPath)) {
    Write-Host "  [X] install.ps1 not found at $NexusRoot" -ForegroundColor Red
    exit 1
}

# Use hashtable splatting (not array) so switches are parsed correctly
$installParams = @{
    ProjectPath = $ProjectPath
}
if ($Force) { $installParams["Force"] = $true }
if ($Dev) { $installParams["Dev"] = $true }

& $installerPath @installParams
