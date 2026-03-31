#!/bin/bash
# =============================================================
# Script 5: Open Source Manifesto Generator
# Author: Harsh Yadav | Registration: 24BCE10563
# Course: Open Source Software | Capstone Project
# Software Audited: Mozilla Firefox
# =============================================================
# This script interactively collects user responses and composes
# a personalised open-source philosophy manifesto, saving it
# to a .txt file with their username in the filename.
# =============================================================

# --- Alias concept demonstration ---
# In shell scripting, aliases create shorthand for longer commands.
# They are typically defined in ~/.bashrc for interactive shells.
# Below we show the alias concept via comments and a function equivalent:
#
#   alias today='date +%d-%B-%Y'       # Example alias for date formatting
#   alias myname='echo $(whoami)'      # Example alias for username
#
# Since aliases don't work reliably in non-interactive scripts,
# we implement the same behaviour using functions:

get_today() {
    date '+%d %B %Y'    # Returns formatted date — equivalent of alias today='date...'
}

get_username() {
    whoami              # Returns current user — equivalent of alias myname='whoami'
}

# --- Output filename uses the username (via function above) ---
OUTPUT="manifesto_$(get_username).txt"

# --- Display welcome banner ---
echo "=============================================================="
echo "      OPEN SOURCE MANIFESTO GENERATOR"
echo "      Software Audited: Mozilla Firefox"
echo "=============================================================="
echo ""
echo "  Answer three questions to generate your personal"
echo "  open-source philosophy statement."
echo ""
echo "  Your manifesto will be saved to: $OUTPUT"
echo "--------------------------------------------------------------"
echo ""

# --- Question 1: read user input into variable TOOL ---
read -p "  1. Name one open-source tool you use every day: " TOOL

# --- Question 2: read user input into variable FREEDOM ---
read -p "  2. In one word, what does 'freedom' mean to you? " FREEDOM

# --- Question 3: read user input into variable BUILD ---
read -p "  3. Name one thing you would build and share freely: " BUILD

# --- Validate inputs: ensure none are empty ---
# If any answer is blank, replace it with a default value
[ -z "$TOOL" ]    && TOOL="Firefox"
[ -z "$FREEDOM" ] && FREEDOM="choice"
[ -z "$BUILD" ]   && BUILD="a tool that helps others"

# --- Capture current date using command substitution ---
DATE=$(get_today)     # Uses our alias-equivalent function
USER=$(get_username)  # Uses our alias-equivalent function

echo ""
echo "--------------------------------------------------------------"
echo "  Generating your manifesto..."
echo "--------------------------------------------------------------"
echo ""

# --- Compose manifesto using string concatenation and write to file ---
# The '>' operator creates/overwrites the file
# The '>>' operator appends to the file
# We use '>>' throughout to build the file line by line

# Write title and metadata
echo "=============================================================="  > "$OUTPUT"
echo "  OPEN SOURCE MANIFESTO"                                        >> "$OUTPUT"
echo "  By: $USER  |  Date: $DATE"                                   >> "$OUTPUT"
echo "  Course: Open Source Software — Firefox Audit"                >> "$OUTPUT"
echo "==============================================================" >> "$OUTPUT"
echo ""                                                               >> "$OUTPUT"

# Write the personalised philosophy paragraph using string concatenation
# Variables $TOOL, $FREEDOM, and $BUILD are embedded directly in the text
echo "  Every day, I rely on $TOOL — a piece of software that someone"    >> "$OUTPUT"
echo "  built, shared, and gave to the world without asking for payment."  >> "$OUTPUT"
echo "  To me, freedom means $FREEDOM. That is exactly what open-source"  >> "$OUTPUT"
echo "  software represents: the $FREEDOM to use, study, modify, and"     >> "$OUTPUT"
echo "  share the tools we depend on."                                     >> "$OUTPUT"
echo ""                                                                    >> "$OUTPUT"
echo "  Mozilla Firefox embodies this ideal. It is a browser built not"   >> "$OUTPUT"
echo "  to maximise profit, but to protect the open web — to ensure the"  >> "$OUTPUT"
echo "  internet remains a resource that belongs to everyone, not to a"   >> "$OUTPUT"
echo "  single corporation. Its source code is public. Its mission is"    >> "$OUTPUT"
echo "  public. Its values are written into its license."                 >> "$OUTPUT"
echo ""                                                                    >> "$OUTPUT"
echo "  Inspired by that spirit, I commit to building $BUILD and"         >> "$OUTPUT"
echo "  sharing it freely — because knowledge grows when it is shared,"   >> "$OUTPUT"
echo "  and software is knowledge."                                        >> "$OUTPUT"
echo ""                                                                    >> "$OUTPUT"
echo "  The open-source movement taught us that the most powerful tools"  >> "$OUTPUT"
echo "  in the world — Linux, Python, the Apache web server, Firefox —"   >> "$OUTPUT"
echo "  were not built by one company in secret. They were built by"      >> "$OUTPUT"
echo "  communities in the open, one contribution at a time."             >> "$OUTPUT"
echo ""                                                                    >> "$OUTPUT"
echo "  I choose to be part of that community."                           >> "$OUTPUT"
echo ""                                                                    >> "$OUTPUT"
echo "  — $USER, $DATE"                                                   >> "$OUTPUT"
echo "==============================================================" >> "$OUTPUT"

# --- Confirm the file was written successfully ---
if [ -f "$OUTPUT" ]; then
    echo "  [✔] Manifesto successfully saved to: $OUTPUT"
    echo ""
    echo "--------------------------------------------------------------"
    echo "  PREVIEW:"
    echo "--------------------------------------------------------------"
    # cat reads and displays the file contents
    cat "$OUTPUT"
else
    echo "  [ERROR] Failed to write manifesto. Check write permissions."
    exit 1
fi

echo ""
echo "=============================================================="
echo "  Manifesto generated at: $(date '+%H:%M:%S')"
echo "=============================================================="
