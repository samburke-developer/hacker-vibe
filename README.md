# hacker-vibe

![hacker-vibe](assets/banner.jpg)

Plays cyberpunk synth and mechanical-keyboard ASMR while Claude Code is working. Stops when
it finishes.

Needs `afplay` (built into macOS) or `ffplay` (`brew install ffmpeg`).

## Install

```
/plugin marketplace add https://github.com/samburke-developer/hacker-vibe.git
/plugin install hacker-vibe@hacker-vibe
/reload-plugins
```

One command per line. For a local checkout, `/plugin marketplace add ~/repos/hacker-vibe`.

<details>
<summary>Without the plugin system</summary>

Use this **or** the plugin, never both — two copies race over the same PID files and strand
orphaned players.

Merge into `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command", "command": "bash /path/to/hacker-vibe/hooks/start-audio.sh" } ] }
    ],
    "Stop": [
      { "hooks": [ { "type": "command", "command": "bash /path/to/hacker-vibe/hooks/stop-audio.sh" } ] }
    ],
    "SessionEnd": [
      { "hooks": [ { "type": "command", "command": "bash /path/to/hacker-vibe/hooks/stop-audio.sh" } ] }
    ]
  }
}
```

Copy `skills/hackermode/SKILL.md` to `~/.claude/commands/hackermode.md`, replacing
`${CLAUDE_PLUGIN_ROOT}` with the repo path, then restart.

</details>

## Usage

```
/hackermode                 toggle
/hackermode off             silence, stop playback
/hackermode status          state and current track
/hackermode track list      list tracks
/hackermode track chrome    switch (prefix match)
```

Namespaced `/hacker-vibe:hackermode` when installed as a plugin. Also runs as a script:
`hooks/hackermode.sh off`.

State lives in `~/.hacker-vibe-state`, overridable with `$HACKER_VIBE_STATE`. Absent means
enabled.

Stuck audio: `bash hooks/stop-audio.sh`.

## Tracks

| Track | Style |
|---|---|
| `velocity-surge` | high-octane synth *(default)* |
| `chrome-metropolis` | darksynth |
| `digital-shrapnel` | aggressive electro house |
| `44-caliber-killer` | darksynth, heavier |

`audio/music.mp3` symlinks into `audio/library/`. Drop in your own `.mp3` and
`hackermode track <name>` picks it up.

Volume: `-v 0.45` music, `-v 0.9` keyboard, both in `start-audio.sh`.

## Licence

Code [MIT](LICENSE). Audio CC BY, credited in [ATTRIBUTION.md](ATTRIBUTION.md) — keep that
file in forks.
