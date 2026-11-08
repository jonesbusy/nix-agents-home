#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
home_dir="$(mktemp -d)"
trap 'rm -rf "$home_dir"' EXIT

HOME="$home_dir" DRY_RUN_CMD= bash "$repo_root/home/hermes-state.sh"
HOME="$home_dir" DRY_RUN_CMD= bash "$repo_root/home/hermes-state.sh"

test "$(stat -c '%a' "$home_dir/.hermes")" = 700
test "$(stat -c '%a' "$home_dir/.hermes/.env")" = 600
