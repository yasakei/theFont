# theFont — simple font installer for Linux and macOS

## 🌟 What is this?
`theFont` is a clean and minimalistic CLI tool to easily download and install fonts from [daFont.com](https://www.dafont.com) and [1001fonts.com](https://www.1001fonts.com).

## 🚀 Install

**Bash/Zsh:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh)
```

**Fish:**
```fish
curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.fish | fish
```

## 💻 Usage

```bash
tf https://www.dafont.com/super-adorable.font
tf https://www.1001fonts.com/your-font-name-font.html
```

## 🔧 Features

* Installs any font from daFont or 1001fonts with a single command
* Downloads + extracts + caches automatically
* No sudo needed, installs to `~/.local/share/fonts` (Linux) or `~/Library/Fonts` (macOS)

## 🧠 Requirements

*   Python 3
*   Python libraries: `requests`, `beautifulsoup4`, `tqdm`
    *   The installer will attempt to install these via `pip --user`.
    *   For Arch Linux users, the installer will prompt to install system packages (`python-requests`, `python-bs4`, `python-tqdm`) via `pacman`.
*   System utilities: `curl` (for installation script), `unzip`, `fc-cache` (Linux)

## 🐚 Shell Compatibility

`theFont` is designed to work across various shells, including `bash`, `zsh`, and `fish`.

- **Bash/Zsh**: Use `install.sh`
- **Fish**: Use `install.fish`

The installers attempt to automatically add `~/.local/bin` (Linux) or `/usr/local/bin` (macOS) to your `PATH` in your shell's configuration file (`.bashrc`, `.zshrc`, or `config.fish`).

### Non-POSIX Terminals

While `theFont` itself is a Python script and should function on most terminals, the install scripts (`install.sh` and `install.fish`) rely on `bash` and standard POSIX commands. If you are using a non-POSIX compliant terminal or shell, you may need to manually execute the commands within the install script or adjust them for your environment.

**Note on ASCII Art:** The installer displays a small ASCII art cat. Its appearance may vary or appear broken on some terminals due to font rendering or terminal capabilities. This does not affect the functionality of the installer.

## 📦 Uninstall

To uninstall, run the installer script with the `-u` or `--uninstall` flag:

**Bash/Zsh:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh) --uninstall
```

**Fish:**
```fish
curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.fish | fish --uninstall
```

## 👤 Author

Made with 💖 by [@yasakei](https://github.com/yasakei)

---

✨ tf = typeface... but stylish