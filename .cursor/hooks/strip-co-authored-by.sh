#!/usr/bin/env bash
# Removes Co-authored-by lines appended by Cursor Cloud Agent commit-msg.cursor.co-author.
set -euo pipefail

COMMIT_MSG_FILE="${1:?commit message file required}"

if [ ! -f "$COMMIT_MSG_FILE" ]; then
  exit 0
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

awk '
  BEGIN { skip_blank = 0 }
  /^[Cc]o-[Aa]uthored-[Bb]y:/ { skip_blank = 1; next }
  skip_blank && /^[[:space:]]*$/ { next }
  { skip_blank = 0; print }
' "$COMMIT_MSG_FILE" > "$tmp"

mv "$tmp" "$COMMIT_MSG_FILE"
trap - EXIT
