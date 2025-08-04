$ErrorActionPreference = 'Stop'
$Version = "V2"
$Branch = "Beta"

Write-Host @"
 /\_/\  
( o.o )  theFont $Version $Branch
 > ^ <  
"@

$InstallPath = "$env:LOCALAPPDATA\theFont"
$PS1Url = "https://raw.githubusercontent.com/yasakei/theFont/win/tf.ps1"
$CmdUrl = "https://raw.githubusercontent.com/yasakei/theFont/win/tf.cmd"

# Create install directory
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

# Download files
Write-Host "📦 Downloading theFont files..."
try {
    Invoke-RestMethod -Uri $PS1Url -OutFile "$InstallPath\tf.ps1"
    Invoke-RestMethod -Uri $CmdUrl -OutFile "$InstallPath\tf.cmd"
} catch {
    Write-Host "❌ Failed to download files: $_"
    exit 1
}

# Add to PATH if not already there
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallPath*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$UserPath;$InstallPath",
        "User"
    )
    Write-Host "✅ Added to PATH. You may need to restart your terminal."
} else {
    Write-Host "✨ Path already configured."
}

Write-Host @"

🎉 Installation complete!
   Run 'tf <font-url>' to install fonts
   Example: tf https://www.dafont.com/minecraft.font

"@
