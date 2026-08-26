#!/usr/bin/env bash
# Installs commit-msg.cursor.co-author-strip into the Cursor-managed hooks directory.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STRIP_SCRIPT="$REPO_ROOT/.cursor/hooks/strip-co-authored-by.sh"
WRAPPER_NAME="commit-msg.cursor.co-author-strip"

if [ ! -x "$STRIP_SCRIPT" ]; then
  chmod +x "$STRIP_SCRIPT"
fi

resolve_hooks_dir() {
  if [ -n "${CURSOR_AGENT_HOOKS_DIR:-}" ] && [ -d "$CURSOR_AGENT_HOOKS_DIR" ]; then
    printf '%s\n' "$CURSOR_AGENT_HOOKS_DIR"
    return 0
  fi

  local git_hooks
  git_hooks="$(readlink -f "$REPO_ROOT/.git/hooks" 2>/dev/null || true)"
  if [ -n "$git_hooks" ] && [ -d "$git_hooks" ]; then
    printf '%s\n' "$git_hooks"
    return 0
  fi

  return 1
}

HOOKS_DIR="$(resolve_hooks_dir)" || {
  echo "error: Cursor agent hooks directory not found." >&2
  echo "Set CURSOR_AGENT_HOOKS_DIR and retry." >&2
  exit 1
}

WRAPPER_PATH="$HOOKS_DIR/$WRAPPER_NAME"

cat > "$WRAPPER_PATH" <<EOF
#!/usr/bin/env bash
exec "$STRIP_SCRIPT" "\$@"
EOF

chmod +x "$WRAPPER_PATH"
echo "Installed $WRAPPER_PATH"
