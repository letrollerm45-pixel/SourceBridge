#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT_DIR/games/games.manifest.json"
EXTERNAL_DIR="$ROOT_DIR/external"
GAMES_DIR="$EXTERNAL_DIR/games"
SDK_DIR="$EXTERNAL_DIR/source-sdk-2013"

command -v jq >/dev/null 2>&1 || {
  echo "jq is required. Install jq and rerun." >&2
  exit 1
}

mkdir -p "$GAMES_DIR"

sdk_repo=$(jq -r '.sdk.repo' "$MANIFEST")
sdk_branch=$(jq -r '.sdk.branch' "$MANIFEST")

if [[ ! -d "$SDK_DIR/.git" ]]; then
  git clone --branch "$sdk_branch" "$sdk_repo" "$SDK_DIR"
else
  git -C "$SDK_DIR" fetch origin
  git -C "$SDK_DIR" checkout "$sdk_branch"
  git -C "$SDK_DIR" pull --ff-only
fi

jq -c '.games[]' "$MANIFEST" | while read -r game; do
  id=$(jq -r '.id' <<<"$game")
  repo=$(jq -r '.repo' <<<"$game")
  branch=$(jq -r '.branch' <<<"$game")
  target="$GAMES_DIR/$id"

  if [[ ! -d "$target/.git" ]]; then
    git clone --branch "$branch" "$repo" "$target"
  else
    git -C "$target" fetch origin
    git -C "$target" checkout "$branch"
    git -C "$target" pull --ff-only
  fi

done

echo "Bootstrap complete. Repositories are available in: $EXTERNAL_DIR"
