#!/usr/bin/env bash
# lazygit helper: generate a commit message on ai-vm, edit it in nvim, commit.
set -uo pipefail

f=$(mktemp)
trap 'rm -f "$f"' EXIT

if git diff --cached --no-ext-diff | ssh -T lume-macos-tahoe-sandbox '~/dev/scripts/bootstrap/config_dirs/lazygit/ai-commit-vm.sh' >"$f"; then
    git commit -e -F "$f"
else
    rc=$?
    exit "$rc"
fi
