#!/bin/bash
# =============================================================
# Script 2: FOSS Package Inspector
# Author: Harsh Yadav | Registration: 24BCE10563
# Course: Open Source Software | Capstone Project
# Software Audited: Mozilla Firefox
# =============================================================

# --- Target package name ---
# On Debian/Ubuntu: firefox or firefox-esr
# On Fedora/RHEL: firefox
PACKAGE="firefox"

# --- Detect package manager ---
# Different Linux distros use different package managers
if command -v rpm &>/dev/null; then
    PKG_MANAGER="rpm"
elif command -v dpkg &>/dev/null; then
    PKG_MANAGER="dpkg"
else
    PKG_MANAGER="unknown"
fi

echo "=============================================="
echo "   FOSS Package Inspector — $PACKAGE"
echo "=============================================="
echo ""

# --- Check if Firefox is installed using if-then-else ---
# We try multiple methods to support both RPM and DEB-based systems

INSTALLED=false

if [ "$PKG_MANAGER" = "rpm" ]; then
    # RPM-based check (Fedora, RHEL, CentOS)
    if rpm -q $PACKAGE &>/dev/null; then
        INSTALLED=true
        echo "[✔] $PACKAGE is installed (RPM system detected)."
        echo ""
        echo "  [ Package Details ]"
        # Extract Version, License, and Summary using grep with regex
        rpm -qi $PACKAGE | grep -E "^(Version|License|Summary|URL|Vendor)" | \
            while IFS=: read -r key value; do
                printf "  %-10s: %s\n" "$key" "$(echo $value | xargs)"
            done
    else
        echo "[✘] $PACKAGE is NOT installed on this RPM system."
        echo "    Install with: sudo dnf install firefox"
    fi

elif [ "$PKG_MANAGER" = "dpkg" ]; then
    # DEB-based check (Ubuntu, Debian, Mint)
    if dpkg -l $PACKAGE 2>/dev/null | grep -q "^ii"; then
        INSTALLED=true
        echo "[✔] $PACKAGE is installed (DEB system detected)."
        echo ""
        echo "  [ Package Details ]"
        # Use dpkg-query to extract structured info
        dpkg-query -W -f='  Version   : ${Version}\n  Section   : ${Section}\n  Homepage  : ${Homepage}\n' $PACKAGE 2>/dev/null
    else
        echo "[✘] $PACKAGE is NOT installed on this DEB system."
        echo "    Install with: sudo apt install firefox"
    fi

else
    # Fallback: try 'which' command to see if binary exists
    if which firefox &>/dev/null; then
        INSTALLED=true
        echo "[✔] $PACKAGE binary found at: $(which firefox)"
        echo "    Version: $(firefox --version 2>/dev/null)"
    else
        echo "[✘] Package manager not recognized and firefox binary not found."
    fi
fi

echo ""

# --- Case statement: Print philosophy note based on package name ---
# This maps known FOSS packages to their philosophical significance
echo "  [ FOSS Philosophy Note ]"

case $PACKAGE in
    firefox)
        echo "  Firefox (Mozilla): A nonprofit browser fighting for an open web."
        echo "  Mozilla's mission is to keep the internet a global public resource,"
        echo "  open and accessible to all. Firefox exists to give users a browser"
        echo "  not driven by advertising revenue or data harvesting."
        ;;
    httpd|apache2)
        echo "  Apache: The web server that built the open internet."
        echo "  Born from patches to the NCSA HTTPd server, Apache proved that"
        echo "  collaborative open development could outperform proprietary software."
        ;;
    mysql|mariadb)
        echo "  MySQL/MariaDB: Open source at the heart of millions of apps."
        echo "  MySQL's dual-license model (GPL + Commercial) sparked one of the"
        echo "  most important debates about open source sustainability."
        ;;
    vlc)
        echo "  VLC: Built by students in Paris who just wanted to watch videos."
        echo "  It plays everything because its LGPL license lets it include codecs"
        echo "  that commercial players cannot legally bundle."
        ;;
    git)
        echo "  Git: Linus Torvalds built this in 2 weeks after a proprietary VCS"
        echo "  revoked Linux's free license. A direct product of open source values."
        ;;
    python3|python)
        echo "  Python: A language shaped entirely by community under the PSF license."
        echo "  Its open governance model is a blueprint for FOSS project management."
        ;;
    libreoffice)
        echo "  LibreOffice: Born from a community fork of OpenOffice when Oracle"
        echo "  acquired Sun Microsystems — a testament to the power of copyleft."
        ;;
    *)
        echo "  Package '$PACKAGE' is part of the rich FOSS ecosystem."
        echo "  Every open-source package represents a choice to share knowledge freely."
        ;;
esac

echo ""
echo "=============================================="
echo "  Inspector completed at: $(date '+%H:%M:%S')"
echo "=============================================="
