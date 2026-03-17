# ============================================================
# Nexus Framework — Setup PowerShell Profile
# Chạy 1 lần trên máy mới để thêm nexus-install vào profile
# ============================================================

$NexusRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  🔗 NEXUS PROFILE SETUP" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""

# --- Kiểm tra profile đã có nexus-install chưa ---
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath

# Tạo thư mục profile nếu chưa có
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "  ▶ Tạo thư mục profile: $profileDir" -ForegroundColor Cyan
}

# Tạo file profile nếu chưa có
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-Host "  ▶ Tạo file profile: $profilePath" -ForegroundColor Cyan
}

# Kiểm tra đã có nexus-install chưa
$profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($profileContent -match "nexus-install") {
    Write-Host "  ⏭️ nexus-install đã có trong profile" -ForegroundColor Yellow
    Write-Host "  📂 Profile: $profilePath" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Không cần setup lại. Dùng nexus-install bình thường." -ForegroundColor Green
    Write-Host ""
    exit 0
}

# --- Thêm nexus-install vào profile ---
$installScript = Join-Path $NexusRoot "install.ps1"

$block = @"

# ============================================================
# Nexus Framework — Global Installer Function
# ============================================================
function nexus-install {
    param(
        [string]`$Path = ".",
        [switch]`$Force,
        [switch]`$Dev
    )
    & "$installScript" -ProjectPath `$Path -Force:`$Force -Dev:`$Dev
}
"@

Add-Content -Path $profilePath -Value $block -Encoding UTF8

Write-Host "  ✅ Đã thêm nexus-install vào PowerShell profile" -ForegroundColor Green
Write-Host "  📂 Profile: $profilePath" -ForegroundColor DarkGray
Write-Host "  📂 Nexus:   $NexusRoot" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ▶ Khởi động lại terminal hoặc chạy:" -ForegroundColor White
Write-Host "    . `$PROFILE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Sau đó dùng:" -ForegroundColor White
Write-Host "    nexus-install              # Cài tại thư mục hiện tại" -ForegroundColor Cyan
Write-Host "    nexus-install -Force       # Ghi đè" -ForegroundColor Cyan
Write-Host "    nexus-install -Dev         # Symlink mode" -ForegroundColor Cyan
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
