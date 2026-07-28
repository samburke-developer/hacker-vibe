---
description: Toggle hacker-vibe audio on or off, or switch tracks
argument-hint: "[on|off|status|track [list|<name>]]"
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---

!`bash "${CLAUDE_PLUGIN_ROOT}/hooks/hackermode.sh" ${ARGUMENTS:-toggle}`

Report the output verbatim.
