# Skills

Landry's collection of agent skills. Works with Claude Code, Jazz, and any setup that discovers `SKILL.md` files.

## Skills

| Skill | What it does |
| ----- | ------------ |
| `assemble-a-team` | Compose a team of role-specialist subagents instead of reasoning as one generalist |
| `help-me-think` | Spin up a team of subagents that challenge your idea, find blind spots, and surface options |
| `investigate-bug` | Investigate a reported bug like a detective before assuming it exists |
| `keep-awake` | Keep the computer from sleeping while a long task runs (caffeinate / systemd-inhibit) |

## Installing a skill

Clone the repo, then symlink a skill into the skills folder your setup discovers:

```bash
git clone git@github.com:lvndry/skills.git ~/skills

# Claude Code
ln -s ~/skills/keep-awake ~/.claude/skills/keep-awake

# Jazz / agent frameworks using ~/.agents
ln -s ~/skills/keep-awake ~/.agents/skills/keep-awake
```

To install all skills at once:

```bash
for skill in ~/skills/*/; do
  ln -sf "$skill" ~/.claude/skills/"$(basename "$skill")"
done
```

Keep them up to date with `cd ~/skills && git pull` — the symlinks pick up changes automatically.

## Adding a new skill

Create a branch like `skill/your-skill-name`, add `your-skill-name/SKILL.md` with YAML frontmatter (`name` and a trigger-rich `description`), symlink it into your skills folder, exercise it until it behaves as intended, then commit, push, and open a PR against `main`.

## Writing a good SKILL.md

- The `description` is the only signal the agent uses to decide when to load the skill — write it in third person with concrete trigger phrases.
- Keep it under 500 lines; move reference material to a linked file (e.g. `reference.md`).
- Write steps with concrete commands, not prose that narrates obvious things.
- Match freedom to fragility: guidelines for multiple valid approaches, exact commands when the sequence must be right.
- Scripts belong in `scripts/` next to the SKILL.md; run them by absolute path.
