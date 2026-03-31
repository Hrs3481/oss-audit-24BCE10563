#!/bin/bash
# =============================================================
# Script 3: Disk and Permission Auditor
# Author: Harsh Yadav | Registration: 24BCE10563
# Course: Open Source Software | Capstone Project
# Software Audited: Mozilla Firefox
# =============================================================

# --- List of important system directories to audit ---
# These are standard Linux directories defined by the FHS (Filesystem Hierarchy Standard)
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/lib" "/var/cache")

echo "=============================================================="
echo "        DISK AND PERMISSION AUDITOR"
echo "=============================================================="
echo ""
printf "%-20s %-25s %-10s\n" "DIRECTORY" "PERMISSIONS (perms owner grp)" "SIZE"
echo "--------------------------------------------------------------"

# --- For loop: iterate over each directory in the list ---
for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        # Extract permissions, owner, and group using ls and awk
        # ls -ld gives: drwxr-xr-x 1 root root 4096 Jan 1 /etc
        # awk '{print $1, $3, $4}' extracts: drwxr-xr-x root root
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')

        # du -sh gives human-readable size; cut -f1 removes the path column
        # 2>/dev/null suppresses "Permission denied" errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # printf for aligned, readable output
        printf "%-20s %-25s %-10s\n" "$DIR" "$PERMS" "${SIZE:-N/A}"
    else
        # Directory does not exist on this system
        printf "%-20s %-25s %-10s\n" "$DIR" "[DOES NOT EXIST]" "-"
    fi
done

echo ""
echo "=============================================================="
echo "  FIREFOX-SPECIFIC DIRECTORY AUDIT"
echo "=============================================================="
echo ""

# --- Firefox config and data directories ---
# Firefox stores user profiles and system-wide config in known locations
FIREFOX_DIRS=(
    "/usr/lib/firefox"
    "/usr/lib64/firefox"
    "/usr/share/firefox"
    "/etc/firefox"
    "/usr/bin/firefox"
)

echo "Checking Firefox installation directories..."
echo ""

FOUND_ANY=false  # Track if any Firefox directory was found

for FDIR in "${FIREFOX_DIRS[@]}"; do
    # Check for both directories and files (firefox binary is a file)
    if [ -d "$FDIR" ] || [ -f "$FDIR" ]; then
        FOUND_ANY=true
        # Get type (file or directory)
        TYPE="dir"
        [ -f "$FDIR" ] && TYPE="file"

        # Get permissions and owner
        PERMS=$(ls -ld "$FDIR" | awk '{print $1, $3, $4}')

        # Get size only if it's a directory
        if [ -d "$FDIR" ]; then
            SIZE=$(du -sh "$FDIR" 2>/dev/null | cut -f1)
        else
            SIZE=$(ls -lh "$FDIR" | awk '{print $5}')
        fi

        echo "  [FOUND - $TYPE] $FDIR"
        echo "  Permissions : $PERMS"
        echo "  Size        : ${SIZE:-N/A}"
        echo ""
    fi
done

# --- If no Firefox directory was found ---
if [ "$FOUND_ANY" = false ]; then
    echo "  [!] Firefox does not appear to be installed in standard locations."
    echo "      Common install paths checked: ${FIREFOX_DIRS[*]}"
    echo ""
    echo "  To install Firefox:"
    echo "    Ubuntu/Debian : sudo apt install firefox"
    echo "    Fedora/RHEL   : sudo dnf install firefox"
fi

# --- Check user's Firefox profile directory ---
echo "--------------------------------------------------------------"
echo "  User Profile Directory:"
FF_PROFILE="$HOME/.mozilla/firefox"

if [ -d "$FF_PROFILE" ]; then
    PROFILE_SIZE=$(du -sh "$FF_PROFILE" 2>/dev/null | cut -f1)
    echo "  [FOUND] $FF_PROFILE"
    echo "  Size    : ${PROFILE_SIZE:-N/A}"
    echo "  Perms   : $(ls -ld "$FF_PROFILE" | awk '{print $1, $3, $4}')"
    echo ""
    echo "  Profile subdirectories:"
    # List immediate subdirectories of the Firefox profile folder
    for PDIR in "$FF_PROFILE"/*/; do
        [ -d "$PDIR" ] && echo "    $(basename "$PDIR")"
    done
else
    echo "  [NOT FOUND] $FF_PROFILE — Firefox may not have been run yet."
fi

echo ""
echo "=============================================================="
echo "  Audit completed at: $(date '+%d %B %Y, %H:%M:%S')"
echo "=============================================================="
