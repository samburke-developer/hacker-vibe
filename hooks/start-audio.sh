#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
AUDIO="$DIR/../audio"
STATE="${HACKER_VIBE_STATE:-$HOME/.hacker-vibe-state}"

bash "$DIR/stop-audio.sh"

if [ -f "$STATE" ] && [ "$(tr -d '[:space:]' < "$STATE")" = "off" ]; then
    exit 0
fi

set -m

track() {
    for ext in mp3 wav m4a aiff; do
        [ -f "$AUDIO/$1.$ext" ] && { echo "$AUDIO/$1.$ext"; return; }
    done
}

MUSIC="$(track music)"
KEYS="$(track keyboard)"

if command -v afplay >/dev/null 2>&1; then
    [ -n "$MUSIC" ] && { while :; do afplay -v 0.45 "$MUSIC" || sleep 1; done & echo $! > /tmp/claude_music.pid; }
    [ -n "$KEYS" ]  && { while :; do afplay -v 0.9 "$KEYS"  || sleep 1; done & echo $! > /tmp/claude_keyboard.pid; }
elif command -v ffplay >/dev/null 2>&1; then
    [ -n "$MUSIC" ] && { ffplay -nodisp -volume 45 -loop 0 "$MUSIC" >/dev/null 2>&1 & echo $! > /tmp/claude_music.pid; }
    [ -n "$KEYS" ]  && { ffplay -nodisp -volume 90 -loop 0 "$KEYS"  >/dev/null 2>&1 & echo $! > /tmp/claude_keyboard.pid; }
fi

exit 0
