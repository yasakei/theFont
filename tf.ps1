# PowerShell script for installing fonts on Windows

param(
    [Parameter(Mandatory=$true)]
    [string]$url
)

# --- Platform-specific configuration ---
$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$systemFontDir = "$env:windir\Fonts"
$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
# ---

# Function to install font using Windows Shell
function Install-Font {
    param([string]$fontPath)
    $fontName = [System.IO.Path]::GetFileName($fontPath)
    $targetPath = Join-Path $systemFontDir $fontName
    
    # Copy to Windows Fonts directory
    Copy-Item -Path $fontPath -Destination $targetPath -Force
    
    # Register font in registry
    $shellApp = New-Object -ComObject Shell.Application
    $shellNamespace = $shellApp.Namespace(0x14) # Windows Fonts folder
    $shellNamespace.CopyHere($fontPath)
}

# Parse URL and determine download URL
$uri = [System.Uri]$url
$domain = $uri.Host
$fontSlug = ""
$downloadUrl = ""

if ($domain -like "*dafont.com") {
    $fontSlug = $url.TrimEnd('/').Split('/')[-1].Replace('.font', '')
    $downloadSlug = $fontSlug.Replace('-', '_')
    $downloadUrl = "https://dl.dafont.com/dl/?f=$downloadSlug"
}
elseif ($domain -like "*1001fonts.com") {
    $fontSlug = $url.TrimEnd('/').Split('/')[-1].Replace('-font.html', '')
    $downloadUrl = "https://www.1001fonts.com/download/$fontSlug.zip"
}
else {
    Write-Host "❌ Unsupported font website: $domain"
    exit 1
}

Write-Host "📦 Downloading $fontSlug from $downloadUrl"

# Download the zip file
$zipPath = "$fontSlug.zip"
$webClient = New-Object System.Net.WebClient
$webClient.Headers.Add("User-Agent", $userAgent)

try {
    $webClient.DownloadFile($downloadUrl, $zipPath)
}
catch {
    Write-Host "❌ Failed to download the font zip: $_"
    exit 1
}

Write-Host "📂 Extracting fonts..."

$tempDir = ".\.tf-temp"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
}
catch {
    Write-Host "❌ File is not a valid zip file."
    Remove-Item $zipPath -Force
    exit 1
}

Remove-Item $zipPath -Force

$fontFiles = Get-ChildItem -Path $tempDir -Recurse -Include "*.ttf","*.otf"

if ($fontFiles.Count -eq 0) {
    Write-Host "❌ No font files found in the zip."
    Remove-Item $tempDir -Recurse -Force
    exit 1
}

# Create font directories if they don't exist
if (-not (Test-Path $fontDir)) {
    New-Item -ItemType Directory -Path $fontDir | Out-Null
}

foreach ($fontFile in $fontFiles) {
    try {
        Install-Font $fontFile.FullName
        Write-Host "✅ Installed: $($fontFile.Name)"
    }
    catch {
        Write-Host "❌ Failed to install: $($fontFile.Name)"
    }
}

# Cleanup
Remove-Item $tempDir -Recurse -Force

Write-Host "✨ Font installation complete!"
