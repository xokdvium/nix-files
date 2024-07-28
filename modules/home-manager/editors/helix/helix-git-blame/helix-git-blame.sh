#!/usr/bin/env bash

# Adapted from https://www.github.com/helix-editor/helix/issues/3035#issuecomment-1694777173

mkdir -p /tmp/helix-git-blame
OUT_FILE=$(mktemp zellij-screen.XXXXXXX -p /tmp/helix-git-blame)
zellij action dump-screen "$OUT_FILE"
PANE_OUTPUT=$(cat "$OUT_FILE")
rm "$OUT_FILE"

# Extract file and line information
RES=$(echo "$PANE_OUTPUT" | rg -e "(?:NOR|INS|SEL)\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
FILE=$(echo "$RES" | choose 0)
LINE=$(echo "$RES" | choose 1)
OFFSET=64

zellij run -- bash -c "git blame -L $LINE,+$OFFSET $FILE"
