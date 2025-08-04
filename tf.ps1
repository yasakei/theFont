[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param(
    [Parameter(Mandatory=$true)]
    [string]$url
)

$ErrorActionPreference = 'Stop'
$systemFontDir = "$env:windir\Fonts"
$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'

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

# Start installation process

# Setup paths
$zipPath = Join-Path $env:TEMP "$fontSlug.zip"
$tempDir = Join-Path $env:TEMP ".tf-temp"

# Download with progress bar
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", $userAgent)
    
    $webClient.DownloadProgressChanged = {
        param($sender, $e)
        Write-Progress -Activity "Downloading font" -Status "$([Math]::Round($e.ProgressPercentage))%" -PercentComplete $e.ProgressPercentage
    }
    $webClient.DownloadFileCompleted = {
        param($sender, $e)
        Write-Progress -Activity "Downloading font" -Completed
    }
    
    $webClient.DownloadFileTaskAsync($downloadUrl, $zipPath).Wait()
    if (-not (Test-Path $zipPath)) { throw "Download failed" }
}
catch {
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    throw
}

# Extract and process
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    Write-Progress -Activity "Installing font" -Status "Extracting" -PercentComplete 25
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    
    Write-Progress -Activity "Installing font" -Status "Finding fonts" -PercentComplete 50
    $fontFiles = Get-ChildItem -Path $tempDir -Recurse -Include "*.ttf","*.otf"
    if (-not $fontFiles) { throw "No font files found" }
# Install fonts
Write-Progress -Activity "Installing font" -Status "Installing" -PercentComplete 75
$installed = 0
$failed = 0

foreach ($fontFile in $fontFiles) {
    try {
        Install-Font $fontFile.FullName
        $installed++
    }
    catch {
        $failed++
        Write-Debug "Failed to install $($fontFile.Name): $_"
    }
}

# Cleanup
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Installing font" -Completed

# Final status (only show if there were any issues)
if ($failed -gt 0) {
    Write-Host "✨ Installed $installed fonts ($failed failed)"
} else {
    Write-Host "✨ Done"
}
