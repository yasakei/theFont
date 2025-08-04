@echo off
setlocal
if "%~1"=="" (
    echo Usage: tf ^<font-url^>
    echo Example: tf https://www.dafont.com/minecraft.font
    exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tf.ps1" %*
