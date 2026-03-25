#!/usr/bin/env fish

set SCRIPT_NAME "tf"
set SCRIPT_URL "https://raw.githubusercontent.com/yasakei/theFont/main/tf.py"
set VERSION "V2"
set BRANCH "Beta"

set ASCII_CAT "f"
echo " /\_/\\"
echo "( o.o )  theFont $VERSION $BRANCH"
echo " > ^ <"

# --- Functions ---

function uninstall
    echo "Uninstalling theFont..."
    if test (uname) = "Darwin"
        set INSTALL_PATH "/usr/local/bin/tf"
    else
        set INSTALL_PATH "$HOME/.local/bin/tf"
    end

    if test -f "$INSTALL_PATH"
        rm "$INSTALL_PATH"
        echo "✅ Uninstalled theFont."
    else
        echo "theFont is not installed in the expected location ($INSTALL_PATH)."
    end
    exit 0
end

function install
    echo "🌟 Installing theFont $VERSION..."

    if test (uname) = "Darwin"
        # macOS
        set INSTALL_PATH "/usr/local/bin"

        # Detect pip command
        if command -v pip3 > /dev/null 2>&1
            set PIP_CMD "pip3"
        else if command -v pip > /dev/null 2>&1
            set PIP_CMD "pip"
        else
            echo "pip not found. Please install Python and pip."
            echo "You can install it with Homebrew: brew install python"
            exit 1
        end

        echo "Installing Python libs with $PIP_CMD..."
        $PIP_CMD install --user requests beautifulsoup4 tqdm
        $PIP_CMD install --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility

        set SHELL_RC "$HOME/.config/fish/config.fish"
        set PATH_TO_ADD "/usr/local/bin"

    else
        # Linux
        set INSTALL_PATH "$HOME/.local/bin"

        # Detect pip command
        if command -v pip3 > /dev/null 2>&1
            set PIP_CMD "pip3"
        else if command -v pip > /dev/null 2>&1
            set PIP_CMD "pip"
        else
            echo "pip not found. Please install Python and pip."
            exit 1
        end

        if grep -qi arch /etc/os-release 2>/dev/null
            echo "Detected Arch Linux."
            echo "Installing Python libs with $PIP_CMD using --break-system-packages..."
            $PIP_CMD install --break-system-packages --user requests beautifulsoup4 tqdm
            $PIP_CMD install --break-system-packages --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility
        else
            echo "Non-Arch system detected. Installing Python libs with $PIP_CMD --user..."
            $PIP_CMD install --user requests beautifulsoup4 tqdm
            $PIP_CMD install --user "urllib3<2" # Fix for urllib3 v2 and LibreSSL compatibility
        end

        set SHELL_RC "$HOME/.config/fish/config.fish"
        set PATH_TO_ADD "$HOME/.local/bin"
    end

    mkdir -p "$INSTALL_PATH"

    echo "Downloading theFont script..."
    curl -sL "$SCRIPT_URL" -o "$INSTALL_PATH/$SCRIPT_NAME"
    chmod +x "$INSTALL_PATH/$SCRIPT_NAME"

    echo "✅ Installed as $INSTALL_PATH/$SCRIPT_NAME"

    if not string match -q "*$PATH_TO_ADD*" "$PATH"
        echo "set -x PATH \"$PATH_TO_ADD\" \$PATH" >> "$SHELL_RC"
        echo "🔁 Added $PATH_TO_ADD to PATH. Restart your shell or run 'source $SHELL_RC'"
    end

    echo "🚀 Done! Run 'tf <dafont-font-url>' to install fonts."
end

# --- Main Script ---

if set -q argv[1]; and test "$argv[1]" = "-u" -o "$argv[1]" = "--uninstall"
    uninstall
else
    install
end
