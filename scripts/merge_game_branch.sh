#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <game-id>"
  exit 1
fi

GAME_ID="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_DIR="$ROOT_DIR/external/source-sdk-2013"
GAME_REPO="$ROOT_DIR/external/games/$GAME_ID"

if [[ ! -d "$SDK_DIR/.git" ]]; then
  echo "SDK repository not found at $SDK_DIR"
  exit 1
fi

if [[ ! -d "$GAME_REPO/.git" ]]; then
  echo "Game repository not found at $GAME_REPO"
  exit 1
fi

cd "$SDK_DIR"

git remote remove "game-$GAME_ID" >/dev/null 2>&1 || true
git remote add "game-$GAME_ID" "$GAME_REPO"
git fetch "game-$GAME_ID" --tags

git checkout -B "integration/$GAME_ID" master
git merge --allow-unrelated-histories --no-commit "game-$GAME_ID/HEAD" || true

echo "Merge staged in branch integration/$GAME_ID."
echo "Resolve conflicts, then commit manually in $SDK_DIR."
