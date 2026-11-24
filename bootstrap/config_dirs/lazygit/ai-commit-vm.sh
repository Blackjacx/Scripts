#!/usr/bin/env bash
# Reads a staged diff on stdin, prints a commit message on stdout.
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH" # non-interactive SSH has a minimal PATH

MODEL="${AI_COMMIT_MODEL:-haiku}"

# claude is installed via mise, which isn't activated over non-interactive SSH.
claude() { mise exec -- claude "$@"; }

fail() {
    printf '✗ %s\n' "$1" >&2
    if [ -n "${2:-}" ] && [ -s "$2" ]; then cat "$2" >&2; fi
    exit 1
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
diff="$work/diff"
out="$work/out"
msg="$work/msg"
cwd="$work/cwd"
err="$work/err" # Claude's stderr (warnings etc.), kept out of the message
mkdir "$cwd"

cat >"$diff"
[ -s "$diff" ] || fail "Nothing staged"

command -v mise >/dev/null || fail "mise not found on VM"
claude auth status >/dev/null 2>&1 ||
    fail "Claude not logged in on VM. ssh in and run: claude auth login"

prompt='Write a git commit message for the staged diff on stdin.
Conventional Commits. Title max 50 chars. Blank line, then body as
"- " bullets, no blank lines between them, max 72 chars per line.
Output only the message: no preamble, no code fences.'

if ! (cd "$cwd" && claude -p \
    --safe-mode \
    --setting-sources user \
    --tools "" \
    --disallowedTools "*" \
    --strict-mcp-config \
    --no-session-persistence \
    --model "$MODEL" \
    "$prompt" <"$diff" >"$out" 2>"$err"); then
    fail "Claude failed:" "$err"
fi

sed -e '/^```/d' "$out" >"$msg"
grep -q '[^[:space:]]' "$msg" || fail "Claude returned an empty message" "$err"
cat "$msg"
