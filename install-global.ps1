# ============================================================
# Nexus Global Installer
# Add Nexus CLI to PATH for global access
# ============================================================

$NexusRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BinDir = Join-Path $NexusRoot "bin"

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  NEXUS GLOBAL INSTALLER" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

# --- Step 1: Verify bin/nexus.ps1 exists ---
$wrapperPath = Join-Path $BinDir "nexus.ps1"
if (-not (Test-Path $wrapperPath)) {
    Write-Host "  [X] bin\nexus.ps1 not found" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] bin\nexus.ps1 ready" -ForegroundColor Green

# --- Step 2: Add to User PATH ---
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $currentPath) { $currentPath = "" }
$pathEntries = $currentPath -split ";"

if ($pathEntries -contains $BinDir) {
    Write-Host "  [SKIP] $BinDir already in PATH" -ForegroundColor Yellow
}
else {
    Write-Host "  [>>] Adding $BinDir to User PATH..." -ForegroundColor Cyan
    if ($currentPath -eq "") {
        $newPath = $BinDir
    }
    else {
        $newPath = $currentPath + ";" + $BinDir
    }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "  [OK] Added to PATH successfully" -ForegroundColor Green
}

# --- Step 3: Create batch wrapper for cmd.exe compatibility ---
$batPath = Join-Path $BinDir "nexus.cmd"
$line1 = "@echo off"
$line2 = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0nexus.ps1" %*'
Set-Content -Path $batPath -Value ($line1, $line2) -Encoding ASCII -Force
Write-Host "  [OK] nexus.cmd created (cmd.exe compatible)" -ForegroundColor Green

# --- Summary ---
Write-Host ""
Write-Host "--- Done ---" -ForegroundColor White
Write-Host ""
Write-Host "  Source:  $NexusRoot" -ForegroundColor White
Write-Host "  CLI:     $BinDir" -ForegroundColor White
Write-Host ""
Write-Host "  Open a NEW terminal, then try:" -ForegroundColor Yellow
Write-Host ""
Write-Host "    nexus help       # Show help" -ForegroundColor Cyan
Write-Host "    nexus version    # Show version" -ForegroundColor Cyan
Write-Host "    nexus            # Install into current project" -ForegroundColor Cyan
Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
