#!/bin/bash

echo "Detecting package manager..."

# Detect Package Manager
if command -v pacman &>/dev/null; then

    PACKAGE_MANAGER="pacman"

elif command -v apt &>/dev/null; then

    PACKAGE_MANAGER="apt"

else

    echo "Unsupported Linux Distribution."
    exit 1

fi

# =========================
# Install Dependencies
# =========================

echo "Installing required packages..."

if [ "$PACKAGE_MANAGER" = "pacman" ]; then

    sudo pacman -Sy --needed bc net-tools

elif [ "$PACKAGE_MANAGER" = "apt" ]; then

    sudo apt update
    sudo apt install -y bc net-tools

fi

# =========================
# Permissions
# =========================

chmod +x dashboard.sh
chmod +x functions.sh

# =========================
# Global Command
# =========================

sudo ln -sf "$(pwd)/dashboard.sh" /usr/local/bin/dashboard

echo "Installation Completed Successfully."