#!/bin/bash
# =============================================================
# Script 4: Log File Analyzer
# Author: Harsh Yadav | Registration: 24BCE10563
# Course: Open Source Software | Capstone Project
# Software Audited: Mozilla Firefox
# =============================================================
# Usage:
#   ./script4_log_analyzer.sh /var/log/syslog
#   ./script4_log_analyzer.sh /var/log/messages ERROR
#   ./script4_log_analyzer.sh /var/log/auth.log WARNING
# =============================================================

# --- Accept command-line arguments ---
# $1 = path to log file, $2 = keyword to search for (default: "error")
LOGFILE=$1
KEYWORD=${2:-"error"}   # If no keyword given, default to "error"

# --- Counter variable to track keyword occurrences ---
COUNT=0
MAX_RETRIES=3            # Maximum number of retries if file is empty
RETRY=0                  # Retry counter

echo "=============================================================="
echo "          LOG FILE ANALYZER"
echo "=============================================================="
echo ""

# --- Validate that a log file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "[ERROR] No log file specified."
    echo "Usage: $0 <logfile> [keyword]"
    echo ""
    echo "Common log files to try:"
    echo "  /var/log/syslog        (Ubuntu/Debian)"
    echo "  /var/log/messages      (Fedora/RHEL)"
    echo "  /var/log/auth.log      (authentication events)"
    echo "  /var/log/kern.log      (kernel messages)"
    exit 1
fi

# --- Check if file exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "[ERROR] File '$LOGFILE' not found."
    echo "Please provide a valid log file path."
    exit 1
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : $KEYWORD"
echo ""

# --- Do-while style retry loop if file is empty ---
# Bash doesn't have a native do-while, but we simulate it using a while loop
# that always executes at least once and checks the condition at the end
while true; do
    # Check if the log file is empty
    if [ ! -s "$LOGFILE" ]; then
        RETRY=$((RETRY + 1))
        echo "[WARNING] Log file is empty. Retry attempt $RETRY of $MAX_RETRIES..."

        # Wait 2 seconds before retrying (simulates waiting for log activity)
        sleep 2

        # Exit retry loop after MAX_RETRIES attempts
        if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
            echo "[ERROR] Log file is still empty after $MAX_RETRIES retries. Exiting."
            exit 1
        fi
    else
        # File has content — break out of the retry loop
        break
    fi
done

# --- Main analysis: while-read loop ---
# Read the log file line by line using while + read
# IFS= preserves leading/trailing whitespace in each line
# -r prevents backslash interpretation
echo "--------------------------------------------------------------"
echo "  Scanning log file..."
echo "--------------------------------------------------------------"

# Temporary file to store matching lines (for last-5 display later)
TMPFILE=$(mktemp /tmp/log_matches_XXXX.txt)

while IFS= read -r LINE; do
    # if-then: check if the current line contains the keyword (case-insensitive)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))           # Increment the counter variable
        echo "$LINE" >> "$TMPFILE"    # Save matching line to temp file
    fi
done < "$LOGFILE"    # Feed the log file into the while loop via input redirection

# --- Display Results ---
echo ""
echo "  [ ANALYSIS RESULTS ]"
echo "  Keyword '$KEYWORD' found : $COUNT times"
echo "  Total lines scanned      : $(wc -l < "$LOGFILE")"
echo "  Log file size            : $(du -sh "$LOGFILE" | cut -f1)"
echo ""

# --- Print the last 5 matching lines using tail + grep ---
if [ "$COUNT" -gt 0 ]; then
    echo "--------------------------------------------------------------"
    echo "  [ LAST 5 MATCHING LINES ]"
    echo "--------------------------------------------------------------"
    # tail gets last 5 lines from the temp file of matches
    tail -5 "$TMPFILE" | while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done
    echo ""
else
    echo "  [INFO] No lines matched keyword '$KEYWORD'."
    echo "  Try a different keyword such as: error, warning, fail, denied, critical"
fi

# --- Firefox-specific log check ---
# Firefox logs errors to the user's profile directory on some systems
echo "--------------------------------------------------------------"
echo "  [ FIREFOX-SPECIFIC LOG CHECK ]"
echo "--------------------------------------------------------------"

FF_LOG_LOCATIONS=(
    "$HOME/.mozilla/firefox/*/crashes/submitted"
    "/var/log/firefox.log"
    "/tmp/firefox-crash*"
)

echo "  Checking for Firefox crash/error logs..."
FOUND_FF_LOG=false

for FF_LOG_GLOB in "${FF_LOG_LOCATIONS[@]}"; do
    # Use eval to expand glob patterns safely
    for FF_LOG in $FF_LOG_GLOB; do
        if [ -e "$FF_LOG" ]; then
            FOUND_FF_LOG=true
            echo "  [FOUND] $FF_LOG"
        fi
    done
done

if [ "$FOUND_FF_LOG" = false ]; then
    echo "  [INFO] No Firefox-specific crash logs found."
    echo "         Firefox crash reports are typically submitted to crash-stats.mozilla.org"
fi

# --- Clean up temporary file ---
rm -f "$TMPFILE"

echo ""
echo "=============================================================="
echo "  Analysis completed at: $(date '+%d %B %Y, %H:%M:%S')"
echo "=============================================================="
