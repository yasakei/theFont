#!/bin/bash

SCRIPT_NAME="tf"
SCRIPT_URL="https://raw.githubusercontent.com/yasakei/theFont/main/tf.py"
VERSION="V2"
BRANCH="Beta"

ASCII_CAT=f"
 /\_/\  
( o.o )  theFont ${VERSION} ${BRANCH}
 > ^ <  
"

# --- Functions ---

uninstall() {
    echo "Uninstalling theFont..."
    if [[ "$(uname)" == "Darwin" ]]; then
        INSTALL_PATH="/usr/local/bin/tf"
    else
        INSTALL_PATH="$HOME/.local/bin/tf"
    fi

    if [ -f "$INSTALL_PATH" ]; then
        rm "$INSTALL_PATH"
        echo "✅ Uninstalled theFont."
    else
        echo "theFont is not installed in the expected location ($INSTALL_PATH)."
    fi
    exit 0
}

install() {
    echo "🌟 Installing theFont $VERSION..."

    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        INSTALL_PATH="/usr/local/bin"
        
        if ! command -v pip3 &> /dev/null; then
            echo "pip3 not found. Please install Python and pip3."
            echo "You can install it with Homebrew: brew install python"
            exit 1
        fi

        echo "Installing Python libs with pip..."
        pip3 install --user requests beautifulsoup4 tqdm
        pip3 install --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility
        
        SHELL_RC="$HOME/.zshrc" # Defaulting to .zshrc for modern macOS
        if [[ "$SHELL" == *"bash"* ]]; then
            SHELL_RC="$HOME/.bash_profile"
        fi
        PATH_TO_ADD="/usr/local/bin"

    else
        # Linux
        INSTALL_PATH="$HOME/.local/bin"
        
        if grep -qi arch /etc/os-release 2>/dev/null; then
            echo "Detected Arch Linux."
            echo "Installing Python libs with pip using --break-system-packages..."
            pip install --break-system-packages --user requests beautifulsoup4 tqdm
            pip install --break-system-packages --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility
        else
            echo "Non-Arch system detected. Installing Python libs with pip --user..."
            pip install --user requests beautifulsoup4 tqdm
            pip install --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility
        fi
        
        SHELL_RC="$HOME/.bashrc"
        [ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"
        PATH_TO_ADD="$HOME/.local/bin"
    fi

    mkdir -p "$INSTALL_PATH"

    echo "Downloading theFont script..."
    curl -sL "$SCRIPT_URL" -o "$INSTALL_PATH/$SCRIPT_NAME"
    chmod +x "$INSTALL_PATH/$SCRIPT_NAME"

    echo "✅ Installed as $INSTALL_PATH/$SCRIPT_NAME"

    if ! echo "$PATH" | grep -q "$PATH_TO_ADD"; then
      echo "export PATH=\"$PATH_TO_ADD:\$PATH\"" >> "$SHELL_RC"
      echo "🔁 Added $PATH_TO_ADD to PATH. Restart your shell or run 'source $SHELL_RC'"
    fi

    echo "🚀 Done! Run 'tf <dafont-font-url>' to install fonts."
}

# --- Main Script ---

echo "$ASCII_CAT"

if [[ "$1" == "-u" || "$1" == "--uninstall" ]]; then
    uninstall
else
    install
fi