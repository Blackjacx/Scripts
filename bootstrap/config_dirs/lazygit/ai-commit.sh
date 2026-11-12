#!/usr/bin/env bash
# AI commit message via Claude Code — hardened:
# no tools, no MCP, no customizations, no repo config, empty cwd.
set -uo pipefail

MODEL="${AI_COMMIT_MODEL:-haiku}"

fail() {
    printf '\n\033[31m✗ %s\033[0m\n' "$1" >&2
    if [ -n "${2:-}" ] && [ -s "$2" ]; then
        printf '\n' >&2
        cat "$2" >&2
    fi
    exit 1
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
diff="$work/diff"
out="$work/out"
msg="$work/msg"
cwd="$work/cwd"
mkdir "$cwd"

command -v claude >/dev/null || fail "claude not found in PATH"
claude auth status >/dev/null 2>&1 ||
    fail "Claude not logged in or session expired. Run: claude auth login"

git diff --cached --no-ext-diff >"$diff" || fail "git diff failed"
[ -s "$diff" ] || fail "Nothing staged"

prompt='Write a git commit message for the staged diff on stdin.
Follow the rules of conventional commits (
https://www.conventionalcommits.org/en/v1.0.0/#summary). Title 
max 50 chars. Blank line, then body as "- " bullets, no blank 
lines between them, max 72 chars per line. Output only the 
message: no preamble, no code fences.'

printf 'Generating commit message (%s)…\n' "$MODEL"

if ! (cd "$cwd" && claude -p \
    --safe-mode \
    --setting-sources user \
    --tools "" \
    --disallowedTools "*" \
    --strict-mcp-config \
    --no-session-persistence \
    --model "$MODEL" \
    "$prompt" <"$diff" >"$out" 2>&1); then
    fail "Claude failed:" "$out"
fi

sed -e '/^```/d' "$out" >"$msg"
grep -q '[^[:space:]]' "$msg" || fail "Claude returned an empty message" "$out"

git commit -e -F "$msg" || fail "Commit aborted or failed"
