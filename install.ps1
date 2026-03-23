# ============================================================
# Nexus Framework Installer
# Cài đặt Nexus vào dự án và cấu hình MCP servers
# ============================================================

param(
    [string]$ProjectPath = ".",
    [switch]$Force,
    [switch]$Dev
)

# --- Auto-detect Nexus source from script location (Fix #1) ---
$NexusRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$NexusVersion = "3.5"


# --- Helpers ---
function Write-Step($msg) { Write-Host "  ▶ $msg" -ForegroundColor Cyan }
function Write-OK($msg) { Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Skip($msg) { Write-Host "  ⏭️ $msg" -ForegroundColor Yellow }
function Write-Err($msg) { Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-Warn($msg) { Write-Host "  ⚠️ $msg" -ForegroundColor Yellow }

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  🔗 NEXUS FRAMEWORK INSTALLER v$NexusVersion" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""

# --- Validate source ---
if (-not (Test-Path "$NexusRoot\.agent")) {
    Write-Err "Nexus framework not found at $NexusRoot"
    Write-Err "Script phải nằm cùng thư mục với .agent/"
    exit 1
}

$ProjectPath = Resolve-Path $ProjectPath
Write-Host "  📂 Source:  $NexusRoot" -ForegroundColor DarkGray
Write-Host "  📂 Dự án:   $ProjectPath" -ForegroundColor White
Write-Host ""

# ============================================================
# BƯỚC 1: Kiểm tra Dependencies (Fix #7 — check TRƯỚC MCP)
# ============================================================
Write-Host "━━━ Bước 1/3: Kiểm tra Dependencies ━━━" -ForegroundColor White

$hasNode = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
$hasUv = $null -ne (Get-Command uv -ErrorAction SilentlyContinue)
$hasNpx = $null -ne (Get-Command npx -ErrorAction SilentlyContinue)

if ($hasNode) {
    $nodeVer = & node --version
    Write-OK "Node.js: $nodeVer"
}
else {
    Write-Err "Node.js chưa cài (cần cho Context7)"
}

if ($hasUv) {
    Write-OK "uv: đã cài (cần cho Serena)"
}
else {
    Write-Err "uv chưa cài — Serena MCP sẽ không hoạt động"
    Write-Host "    → Cài uv: https://docs.astral.sh/uv/getting-started/installation/" -ForegroundColor DarkGray
}

if ($hasNpx) {
    Write-OK "npx: đã cài"
}
else {
    Write-Err "npx chưa cài — Context7 sẽ không hoạt động"
}

Write-Host ""

# ============================================================
# BƯỚC 2: Copy .agent/ (toàn bộ framework)
# ============================================================
Write-Host "━━━ Bước 2/3: Cài đặt Framework ━━━" -ForegroundColor White

$agentDst = Join-Path $ProjectPath ".agent"

# Fix #2: Warn if .nexus/ exists (reinstall scenario)
$nexusDst = Join-Path $ProjectPath ".nexus"
if ((Test-Path $nexusDst) -and $Force) {
    Write-Warn ".nexus/ đã tồn tại — framework sẽ được update nhưng state giữ nguyên"
    Write-Host "    Nếu gặp lỗi incompatible, xóa .nexus/ và chạy /init lại" -ForegroundColor DarkGray
}

# --- .agent/ ---
$agentInstalled = $false
if ((Test-Path $agentDst) -and -not $Force) {
    Write-Skip ".agent/ đã tồn tại (dùng -Force để ghi đè)"
}
else {
    # Fix #12: Symlink dev mode
    if ($Dev) {
        Write-Step "Tạo symlink .agent/ → $NexusRoot\.agent (dev mode)"
        if (Test-Path $agentDst) { Remove-Item $agentDst -Recurse -Force }
        try {
            New-Item -ItemType Junction -Path $agentDst -Target "$NexusRoot\.agent" -ErrorAction Stop | Out-Null
            Write-OK ".agent/ linked (dev mode — thay đổi auto-sync)"
            $agentInstalled = $true
        }
        catch {
            Write-Err "Không tạo được symlink: $($_.Exception.Message)"
            Write-Step "Fallback: copy thay vì link..."
            $Dev = $false
        }
    }

    if (-not $Dev) {
        Write-Step "Copy .agent/ → dự án"

        # Fix #5: Safe copy with error handling
        try {
            if (Test-Path $agentDst) {
                Remove-Item $agentDst -Recurse -Force -ErrorAction Stop
            }
            Copy-Item -Path "$NexusRoot\.agent" -Destination $agentDst -Recurse -Force -ErrorAction Stop
            Write-OK ".agent/ đã cài đặt"
            $agentInstalled = $true
        }
        catch {
            Write-Err "Lỗi copy .agent/: $($_.Exception.Message)"
            Write-Err "Kiểm tra không có file nào đang bị lock bởi IDE"
            exit 1
        }
    }

    Write-Host "    • workflows/ (17) • skills/ (119)" -ForegroundColor DarkGray
    Write-Host "    • agents/ (6+13)  • orchestration/" -ForegroundColor DarkGray
    Write-Host "    • maintenance/    • templates/ (10)" -ForegroundColor DarkGray
    Write-Host "    • knowledge/      • rules/" -ForegroundColor DarkGray
}

# --- GEMINI.md ---
$geminiMd = Join-Path $ProjectPath "GEMINI.md"
if ((Test-Path $geminiMd) -and -not $Force) {
    Write-Skip "GEMINI.md đã tồn tại (dùng -Force để ghi đè)"
}
else {
    Copy-Item -Path "$NexusRoot\GEMINI.md" -Destination $geminiMd -Force
    Write-OK "GEMINI.md đã cài (Antigravity auto-load)"
}

# --- nexus.json ---
$nexusJson = Join-Path $ProjectPath "nexus.json"
if ((Test-Path $nexusJson) -and -not $Force) {
    Write-Skip "nexus.json đã tồn tại (dùng -Force để ghi đè)"
}
else {
    Copy-Item -Path "$NexusRoot\nexus.json" -Destination $nexusJson -Force
    Write-OK "nexus.json đã cài"
}

# Fix #6: Write version file
$versionFile = Join-Path $ProjectPath ".agent\.nexus-version"
Set-Content -Path $versionFile -Value $NexusVersion -Encoding UTF8 -Force
Write-OK "Version: $NexusVersion"

# Knowledge Sync: Write source path for backflow (only if .agent/ was installed)
if ($agentInstalled -and -not $Dev) {
    $sourcePath = $NexusRoot -replace '\\', '/'
    $sourceFile = Join-Path $ProjectPath ".agent\.nexus-source"
    Set-Content -Path $sourceFile -Value $sourcePath -Encoding UTF8 -Force
    Write-OK "Source path: $sourcePath (knowledge sync enabled)"
}
elseif ($Dev) {
    Write-Skip "Source path: không cần (dev mode — symlink auto-sync)"
}

# Fix #3: Add .gitignore entries
$gitignore = Join-Path $ProjectPath ".gitignore"
$entriesToAdd = @(
    "",
    "# Nexus Framework (auto-generated by installer)",
    ".nexus/memory/",
    ".nexus/logs/usage-log.md"
)

if (Test-Path $gitignore) {
    $gitContent = Get-Content $gitignore -Raw -ErrorAction SilentlyContinue
    if ($gitContent -notmatch "Nexus Framework") {
        Write-Step "Thêm entries vào .gitignore"
        $entriesToAdd | Add-Content -Path $gitignore -Encoding UTF8
        Write-OK ".gitignore đã cập nhật (memory + logs excluded)"
    }
    else {
        Write-Skip ".gitignore đã có Nexus entries"
    }
}
else {
    Write-Step "Tạo .gitignore"
    $entriesToAdd | Set-Content -Path $gitignore -Encoding UTF8
    Write-OK ".gitignore đã tạo"
}

# Fix #11: Post-install validation
# Separate agent-internal files from root files
# Only check agent files if .agent/ was actually installed in this run
$agentWasInstalled = $agentInstalled
$agentCriticalFiles = @(
    ".agent\workflows\init.md",
    ".agent\agents\executor\SKILL.md",
    ".agent\orchestration\orchestrator.md",
    ".agent\skills\nexus\SKILL.md",
    ".agent\templates\reasoning-bank.json",
    ".agent\templates\critical-functions.md",
    ".agent\skills\quality\import-guard.md"
)
$rootCriticalFiles = @(
    "GEMINI.md",
    "nexus.json"
)

$criticalFiles = @()
if ($agentWasInstalled) {
    $criticalFiles += $agentCriticalFiles
}
else {
    Write-Skip "Integrity check: bỏ qua .agent/ files (không được cài đặt lần này)"
}
$criticalFiles += $rootCriticalFiles

$missingCount = 0
foreach ($f in $criticalFiles) {
    if (-not (Test-Path (Join-Path $ProjectPath $f))) {
        Write-Err "Missing critical file: $f"
        $missingCount++
    }
}
if ($missingCount -eq 0) {
    Write-OK "Integrity check: $($criticalFiles.Count)/$($criticalFiles.Count) critical files OK"
}
else {
    Write-Err "Integrity check FAILED: $missingCount file(s) missing"
    if (-not $agentWasInstalled) {
        Write-Warn "Chạy lại với -Force để cập nhật .agent/ lên phiên bản mới nhất"
    }
}

Write-Host ""

Write-Host ""

# ============================================================
# BƯỚC 4: Tóm tắt
# ============================================================
Write-Host "━━━ Bước 3/3: Tóm tắt & Hướng dẫn ━━━" -ForegroundColor White
Write-Host ""

$installed = @()
if (Test-Path (Join-Path $ProjectPath ".agent\workflows")) { $installed += "Workflows (17)" }
if (Test-Path (Join-Path $ProjectPath ".agent\skills\nexus")) { $installed += "Skills (119)" }
if (Test-Path (Join-Path $ProjectPath ".agent\agents")) { $installed += "Agents (6+13)" }
if (Test-Path (Join-Path $ProjectPath ".agent\rules")) { $installed += "Rules" }
if (Test-Path (Join-Path $ProjectPath ".agent\orchestration")) { $installed += "Orchestration" }
if (Test-Path (Join-Path $ProjectPath "GEMINI.md")) { $installed += "GEMINI.md" }
if (Test-Path (Join-Path $ProjectPath "nexus.json")) { $installed += "nexus.json" }

$mode = if ($Dev) { "DEV (symlink)" } else { "PRODUCTION (copy)" }
Write-Host "  📦 Đã cài: $($installed -join ', ')" -ForegroundColor Green
Write-Host "  📂 Dự án:  $ProjectPath" -ForegroundColor White
Write-Host "  🔖 Version: $NexusVersion" -ForegroundColor White
Write-Host "  ⚙️ Mode:    $mode" -ForegroundColor White
Write-Host ""

# ============================================================
# BƯỚC 5: Hướng dẫn tiếp theo
# ============================================================
Write-Host "  ━━━ Bước tiếp theo ━━━" -ForegroundColor White
Write-Host ""
Write-Host "  1. Mở Antigravity IDE tại thư mục dự án" -ForegroundColor White
Write-Host "  2. Gõ: " -NoNewline; Write-Host "/init" -ForegroundColor Cyan -NoNewline; Write-Host " để khởi tạo dự án" -ForegroundColor White
Write-Host "  3. Theo hướng dẫn guide để bắt đầu" -ForegroundColor White
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
