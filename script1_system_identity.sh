#!/bin/bash
# =============================================================
# Script 1: System Identity Report
# Author: Harsh Yadav | Registration: 24BCE10563
# Course: Open Source Software | Capstone Project
# Software Audited: Mozilla Firefox
# =============================================================

# --- Student Information ---
STUDENT_NAME="Harsh Yadav"           # Replace with your full name
REG_NUMBER="24BCE10563"       # Replace with your registration number
SOFTWARE_CHOICE="Mozilla Firefox"   # Chosen open-source software

# --- Collect System Information using command substitution ---
KERNEL=$(uname -r)                          # Kernel release version
DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')  # Distro name
USER_NAME=$(whoami)                         # Current logged-in user
HOME_DIR=$HOME                              # Home directory of current user
UPTIME=$(uptime -p)                         # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')       # Formatted current date
CURRENT_TIME=$(date '+%H:%M:%S %Z')        # Current time with timezone
HOSTNAME=$(hostname)                        # Machine hostname
ARCH=$(uname -m)                            # CPU architecture

# --- OS License Detection ---
# Most Linux distributions are licensed under GPL v2 or GPL v3
# We detect the distro and map its primary license
if echo "$DISTRO" | grep -iq "ubuntu\|debian\|mint"; then
    OS_LICENSE="GPL v2 / GPL v3 (Debian-based)"
elif echo "$DISTRO" | grep -iq "fedora\|centos\|rhel\|rocky"; then
    OS_LICENSE="GPL v2 (RPM-based)"
elif echo "$DISTRO" | grep -iq "arch"; then
    OS_LICENSE="GPL v2 (Arch Linux)"
else
    OS_LICENSE="GPL v2 (Linux Kernel core license)"
fi

# --- Display Header ---
echo "================================================================"
echo "       OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT"
echo "================================================================"
echo "  Student : $STUDENT_NAME ($REG_NUMBER)"
echo "  Software: $SOFTWARE_CHOICE"
echo "================================================================"

# --- Display System Info ---
echo ""
echo "  [ SYSTEM INFORMATION ]"
echo "  Hostname       : $HOSTNAME"
echo "  Distribution   : $DISTRO"
echo "  Kernel Version : $KERNEL"
echo "  Architecture   : $ARCH"

# --- Display User Info ---
echo ""
echo "  [ USER INFORMATION ]"
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"

# --- Display Time Info ---
echo ""
echo "  [ DATE & TIME ]"
echo "  Date           : $CURRENT_DATE"
echo "  Time           : $CURRENT_TIME"
echo "  Uptime         : $UPTIME"

# --- Display License Info ---
echo ""
echo "  [ LICENSE INFORMATION ]"
echo "  OS License     : $OS_LICENSE"
echo "  Firefox License: Mozilla Public License (MPL) 2.0"
echo ""
echo "  The MPL 2.0 grants users the freedom to use, study,"
echo "  modify, and distribute Firefox and its source code."
echo "  It is a file-level copyleft license, meaning modified"
echo "  source files must remain open, but can be combined"
echo "  with proprietary code."

# --- Footer ---
echo ""
echo "================================================================"
echo "  Report generated on: $(date)"
echo "================================================================"
