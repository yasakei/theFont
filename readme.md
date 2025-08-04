# theFont — simple font installer (Under Development)

## 🌟 What is this?
`theFont` is a clean and minimalistic CLI tool to download and install fonts from [daFont.com](https://www.dafont.com) and [1001fonts.com](https://www.1001fonts.com) with a single command.

## 🚀 Install

### Windows
Just paste this in PowerShell:
```powershell
irm https://raw.githubusercontent.com/yasakei/theFont/main/install.ps1 | iex
```

### Linux/macOS

```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh)
```

## 💻 Usage

The command is the same on all platforms:
```
tf <font-url>
```

Examples:
```
tf https://www.dafont.com/minecraft.font
tf https://www.1001fonts.com/share-tech-mono-font.html
```

## 🔧 Features

* Installs any font from daFont or 1001fonts with a single command
* Downloads + extracts + caches automatically
* Platform-specific installation:
  * Windows: Installs to system fonts directory
  * Linux: Installs to `~/.local/share/fonts`
  * macOS: Installs to `~/Library/Fonts`

## 🧠 Requirements

### Windows
* Windows 10 or 11
* PowerShell (pre-installed on Windows 10/11)
* Run PowerShell as Administrator if you get permission errors

### Linux/macOS

*   Python 3
*   Python libraries: `requests`, `beautifulsoup4`, `tqdm`
    *   The installer will attempt to install these via `pip --user`.
    *   For Arch Linux users, the installer will prompt to install system packages (`python-requests`, `python-bs4`, `python-tqdm`) via `pacman`.
*   System utilities: `curl` (for installation script), `unzip`, `fc-cache` (Linux)

## 🐚 Shell Compatibility

### Windows
Works in both Command Prompt (cmd.exe) and PowerShell. The `tf.cmd` wrapper allows usage from either shell.

### Linux/macOS
`theFont` is designed to work across various shells, including `bash`, `zsh`, and `fish`. The installer attempts to automatically add `~/.local/bin` (Linux) or `/usr/local/bin` (macOS) to your `PATH` in your shell's configuration file (`.bashrc`, `.zshrc`, or `config.fish`).

### Non-POSIX Terminals

While `theFont` itself is a Python script and should function on most terminals, the `install.sh` script relies on `bash` and standard POSIX commands. If you are using a non-POSIX compliant terminal or shell, you may need to manually execute the commands within `install.sh` or adjust them for your environment.

**Note on ASCII Art:** The installer displays a small ASCII art cat. Its appearance may vary or appear broken on some terminals due to font rendering or terminal capabilities. This does not affect the functionality of the installer.

## 📦 Uninstall

### Windows
Just paste this in PowerShell:
```powershell
irm https://raw.githubusercontent.com/yasakei/theFont/main/install.ps1 -Headers @{"Cache-Control"="no-cache"} | iex -
```
Or manually:
```powershell
Remove-Item "$env:LOCALAPPDATA\theFont" -Recurse -Force
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User") -split ';' | Where-Object { $_ -ne "$env:LOCALAPPDATA\theFont" }
[Environment]::SetEnvironmentVariable("Path", ($UserPath -join ';'), "User")
```

### Linux/macOS
Run the installer script with the `-u` or `--uninstall` flag:
```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh) --uninstall
```

## 👤 Author

Made with 💖 by [@yasakei](https://github.com/yasakei)

---

✨ tf = typeface... but stylish
