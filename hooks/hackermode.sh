#!/bin/bash
# hackermode [on|off|toggle|status|track [list|<name>]]
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
AUDIO="$DIR/../audio"
LIB="$AUDIO/library"
STATE="${HACKER_VIBE_STATE:-$HOME/.hacker-vibe-state}"

state()   { if [ -f "$STATE" ]; then tr -d '[:space:]' < "$STATE"; else echo on; fi; }
current() { basename "$(readlink "$AUDIO/music.mp3" 2>/dev/null)" .mp3 2>/dev/null; }
save()    { mkdir -p "$(dirname "$STATE")" 2>/dev/null; printf '%s\n' "$1" > "$STATE"; }

case "${1:-toggle}" in
    on)
        save on
        echo "hackermode on — $(current)"
        ;;
    off)
        save off
        bash "$DIR/stop-audio.sh"
        echo "hackermode off"
        ;;
    toggle)
        if [ "$(state)" = "off" ]; then
            exec bash "$DIR/hackermode.sh" on
        else
            exec bash "$DIR/hackermode.sh" off
        fi
        ;;
    status)
        echo "hackermode $(state) — $(current)"
        ;;
    track)
        shift
        if [ -z "$1" ] || [ "$1" = "list" ]; then
            for f in "$LIB"/*.mp3; do
                [ -e "$f" ] || continue
                n="$(basename "$f" .mp3)"
                if [ "$n" = "$(current)" ]; then echo "* $n"; else echo "  $n"; fi
            done
            exit 0
        fi
        for f in "$LIB"/*.mp3; do
            [ -e "$f" ] || continue
            n="$(basename "$f" .mp3)"
            case "$n" in
                "$1"*)
                    ln -sf "library/$n.mp3" "$AUDIO/music.mp3"
                    bash "$DIR/stop-audio.sh"
                    echo "track: $n"
                    exit 0
                    ;;
            esac
        done
        echo "no track matching '$1'" >&2
        exit 1
        ;;
    *)
        echo "usage: hackermode [on|off|toggle|status|track [list|<name>]]" >&2
        exit 2
        ;;
esac

exit 0
