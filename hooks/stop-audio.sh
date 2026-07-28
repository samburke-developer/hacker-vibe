#!/bin/bash
for f in /tmp/claude_music.pid /tmp/claude_keyboard.pid; do
    [ -f "$f" ] || continue
    pid="$(cat "$f")"
    if [ -n "$pid" ]; then
        # Kill the group, not the PID, or afplay is orphaned.
        kill -9 -- "-$pid" 2>/dev/null
        kill -9 "$pid" 2>/dev/null
    fi
    rm -f "$f"
done

# Sweep strays. Without this a lost PID file leaves audio unkillable.
# Match the script name only: the cmdline path varies with how it was invoked.
for p in $(pgrep -f 'start-audio\.sh' 2>/dev/null); do
    if [ "$p" != "$$" ] && [ "$p" != "$PPID" ]; then
        kill -9 -- "-$p" 2>/dev/null
        kill -9 "$p" 2>/dev/null
    fi
done
pkill -9 -f 'afplay .*audio/(music|keyboard)\.' 2>/dev/null
pkill -9 -f 'ffplay .*audio/(music|keyboard)\.' 2>/dev/null

exit 0
