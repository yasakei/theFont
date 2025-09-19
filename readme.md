# theFont — simple font installer for Linux and macOS

## 🌟 What is this?
`theFont` is a clean and minimalistic CLI tool to easily download and install fonts from multiple font services including [daFont.com](https://www.dafont.com), [1001fonts.com](https://www.1001fonts.com), [FontSquirrel](https://www.fontsquirrel.com), [Urban Fonts](https://www.urbanfonts.com), [Abstract Fonts](https://www.abstractfonts.com), [Font Space](https://www.fontspace.com), [FontLib](https://fontlib.com), [FontGet](https://www.fontget.com), [BeFonts](https://befonts.com), and [NetFonts](https://www.netfonts.com).

## 🚀 Install

```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh)
```

## 💻 Usage

```bash
# DaFont
tf https://www.dafont.com/super-adorable.font

# 1001 Fonts
tf https://www.1001fonts.com/your-font-name-font.html

# FontSquirrel
tf https://www.fontsquirrel.com/fonts/open-sans

# Urban Fonts
tf https://www.urbanfonts.com/fonts/Roboto.htm

# Abstract Fonts
tf https://www.abstractfonts.com/font/helvetica-neue

# Font Space
tf https://www.fontspace.com/roboto-font-f43234

# FontLib
tf https://fontlib.com/font/arial.html

# FontGet
tf https://www.fontget.com/font/roboto/

# BeFonts
tf https://befonts.com/awesome-font.html

# NetFonts
tf https://www.netfonts.com/fonts/arial-bold
```

## 🔧 Features

* Installs fonts from multiple font services with a single command:
  * **DaFont** - Free fonts for download
  * **1001 Fonts** - Comprehensive font collection
  * **FontSquirrel** - High-quality free fonts
  * **Urban Fonts** - Modern and urban typography
  * **Abstract Fonts** - Creative and artistic fonts
  * **Font Space** - Large font repository
  * **FontLib** - Professional font library
  * **FontGet** - Free font downloads
  * **BeFonts** - Beautiful and modern fonts
  * **NetFonts** - Network of premium fonts
* Downloads + extracts + caches automatically
* No sudo needed, installs to `~/.local/share/fonts` (Linux) or `~/Library/Fonts` (macOS)

## 🧠 Requirements

*   Python 3
*   Python libraries: `requests`, `beautifulsoup4`, `tqdm`
    *   The installer will attempt to install these via `pip --user`.
    *   For Arch Linux users, the installer will prompt to install system packages (`python-requests`, `python-bs4`, `python-tqdm`) via `pacman`.
*   System utilities: `curl` (for installation script), `unzip`, `fc-cache` (Linux)

## 🐚 Shell Compatibility

`theFont` is designed to work across various shells, including `bash`, `zsh`, and `fish`. The installer attempts to automatically add `~/.local/bin` (Linux) or `/usr/local/bin` (macOS) to your `PATH` in your shell's configuration file (`.bashrc`, `.zshrc`, or `config.fish`).

### Non-POSIX Terminals

While `theFont` itself is a Python script and should function on most terminals, the `install.sh` script relies on `bash` and standard POSIX commands. If you are using a non-POSIX compliant terminal or shell, you may need to manually execute the commands within `install.sh` or adjust them for your environment.

**Note on ASCII Art:** The installer displays a small ASCII art cat. Its appearance may vary or appear broken on some terminals due to font rendering or terminal capabilities. This does not affect the functionality of the installer.

## 📦 Uninstall

To uninstall, run the installer script with the `-u` or `--uninstall` flag:
```bash
bash <(curl -sL https://raw.githubusercontent.com/yasakei/theFont/main/install.sh) --uninstall
```

## 👤 Author

Made with 💖 by [@yasakei](https://github.com/yasakei)

---

✨ tf = typeface... but stylish