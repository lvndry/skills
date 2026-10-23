---
name: keep-awake
description: >-
  Keeps the computer from sleeping while a long task runs (caffeinate on
  macOS, systemd-inhibit on Linux), in the background, and releases it when the
  task is done. Offer it, and ask before starting it, when work is long-running
  or its time to completion can't be predicted: long builds, full test or eval
  suites, migrations, large refactors, multi-agent workflows, /loop runs,
  overnight or unattended sessions. Start it without asking when the user says
  "keep the computer awake", "don't let it sleep", "caffeinate", "I'm stepping
  away", or "run this overnight".
argument-hint: "[start|stop|status] [--hours N]"
---

# Keep Awake

Hold a sleep-prevention assertion for the length of a task, then release it.

<request> #$ARGUMENTS </request>

The script is `scripts/keep-awake.sh` in this skill's directory. Run it with
`bash`, using its absolute path.

## Ask first

Keeping a machine awake changes its power state, so get the user's yes before
starting. Ask in one line, before the long work begins, and give the cap:

> This may run a while and I can't tell how long. Keep the computer awake
> until it finishes? (capped at 12h)

Offer it when any of these is true:

- You can't estimate how long the work will take.
- The work will likely take more than about 10 minutes.
- The user is stepping away or wants it to run unattended.

Skip the question when the user asked to keep the machine awake, or already
said yes earlier in this session. If they decline, don't offer it again in
the same session.

When the run is unattended and there is no one to ask, don't start it. Mention
in the final reply that the machine could have slept.

## One long command: `run`

When the long work is a single command, wrap it. The assertion lasts exactly
as long as the command and is released when the command exits, whether it
succeeds or fails. The command's exit status passes through.

```bash
bash <skill-dir>/scripts/keep-awake.sh run -- bun test
```

## A multi-step task: `start` and `stop`

1. **Once the user says yes, start before the long work begins.**

   ```bash
   bash <skill-dir>/scripts/keep-awake.sh start
   ```

   It returns immediately. The assertion runs in the background and is scoped
   to the current agent session. Running `start` again while it is held does
   nothing.

2. **Do the task.**

3. **Stop as soon as the task is complete.** Every `start` needs a matching
   `stop`, whether the task succeeded, failed, was abandoned, or is now waiting
   on the user. Run it before you write your final reply:

   ```bash
   bash <skill-dir>/scripts/keep-awake.sh stop
   ```

4. **Confirm the release.** `status` must print `not running` before you
   reply. If it doesn't, run `stop` again.

## Safety nets

These release a `start` assertion if `stop` never runs. They are fallbacks
only, and the task still has to end with `stop`. The first one to happen ends
the assertion:
- The agent process exits, including a crash or a closed terminal.
- The time cap runs out. It is 12 hours by default. `--hours N` changes it, and
  `--hours 0` removes it. Pass a longer cap for multi-day unattended runs.

## Platform behavior

- **macOS:** `caffeinate -ims` stops idle sleep, system sleep on AC power, and
  disk sleep. The display can still turn off and the screen can still lock,
  so the work keeps running. Closing the lid on battery still puts the Mac to
  sleep, because macOS overrides the assertion there. Tell the user to keep the
  lid open or stay plugged in.
- **Linux:** `systemd-inhibit --what=idle:sleep`. It needs systemd.
- **Anything else:** the script exits non-zero. Tell the user the machine is
  not being kept awake and suggest they change their power settings by hand.

## Reporting

When you start, tell the user in one line, with the cap. When you stop, say so
in the final reply. If `start` fails, say that before you begin the long work,
so the user knows the machine may sleep.
