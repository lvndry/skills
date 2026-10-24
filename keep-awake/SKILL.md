---
name: keep-awake
description: >-
  Keeps the computer from sleeping while the agent works toward a long goal
  (caffeinate on macOS, systemd-inhibit on Linux), in the background, and
  releases it once the goal is achieved. Offer it, and ask before starting it, when work is long-running
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

## The goal decides, not a process

Hold the assertion for the whole goal the user gave you. Release it only when
that goal is achieved, abandoned, or blocked on the user. A command finishing,
a subagent returning, a test run going green or a turn ending is not the goal
being achieved. While work toward the goal remains, keep holding, including
while you wait on background agents, CI, a deploy or a /loop wakeup.

## A goal: `start` and `stop`

This is the default.

1. **Once the user says yes, start before the work toward the goal begins.**

   ```bash
   bash <skill-dir>/scripts/keep-awake.sh start
   ```

   It returns immediately. The assertion runs in the background and is scoped
   to the current agent session. Running `start` again while it is held does
   nothing.

2. **Work toward the goal.** Before you end a turn, check the goal against
   what the user asked for. If it is not achieved and you will keep working
   without the user, such as when background work will wake you, leave the
   assertion held.

3. **Stop once the goal is achieved.** Every `start` needs a matching `stop`.
   Run it when the goal is achieved, when you abandon it, or when you need the
   user before you can go on. Run it before you write your final reply:

   ```bash
   bash <skill-dir>/scripts/keep-awake.sh stop
   ```

4. **Confirm the release.** `status` must print `not running` before you
   reply. If it doesn't, run `stop` again.

## When the goal is one command: `run`

Use `run` only when the entire goal is a single command, so the command
exiting means the goal is done. It holds the assertion exactly as long as the
command runs and passes its exit status through. If anything follows the
command, such as reading its output, fixing failures and re-running, use
`start` and `stop` instead.

```bash
bash <skill-dir>/scripts/keep-awake.sh run -- bun test
```

## Safety nets

These release a `start` assertion if `stop` never runs. They are fallbacks
for when the agent can no longer work toward the goal; they never mean the
goal is done, and a goal still ends with `stop`. The first one to happen ends
the assertion:
- The agent process exits, including a crash or a closed terminal.
- The time cap runs out. It is 12 hours by default. `--hours N` changes it, and
  `--hours 0` removes it. Pass a longer cap for multi-day unattended runs.

## Platform behavior

- **macOS:** `caffeinate -ims` stops idle sleep, system sleep on AC power, and
  disk sleep. The display can still turn off and the screen can still lock,
  so the work keeps running. Closing the lid still puts the Mac to sleep, on
  battery and on AC, unless an external display is connected (clamshell
  mode). See "Lid closed" below.
- **Linux:** `systemd-inhibit --what=idle:sleep`. It needs systemd.
- **Anything else:** the script exits non-zero. Tell the user the machine is
  not being kept awake and suggest they change their power settings by hand.

## Lid closed (macOS)

`start` prints a lid line after the `awake` line. Pass it on to the user in
the same line you use to report the start.

When the user will close the lid, such as leaving it to finish overnight,
start with `--lid`:

```bash
bash <skill-dir>/scripts/keep-awake.sh start --lid
```

It disables lid-close sleep with `pmset disablesleep 1` for the life of the
hold. Every release turns lid sleep back on, whether it comes from `stop`, the
agent exiting or the cap, so the Mac can sleep once the goal is achieved. A
setting the user made by hand is left alone.

`pmset` needs root, so `--lid` uses `sudo -n` and never prompts. If `start`
prints `could not disable lid sleep`, the hold still runs without the lid
part. Tell the user, and give them the one-time setup command that `start`
printed, with the `!` prefix so it runs in this session. It allows exactly
`pmset -a disablesleep 1` and `pmset -a disablesleep 0` without a password,
and nothing else.

If `stop` prints `could not re-enable lid sleep` or `lid sleep is disabled
outside keep-awake`, end the final reply with this command for the user:

```
! sudo pmset -a disablesleep 0
```

A Mac that cannot sleep can overheat in a closed bag, so never leave lid sleep
disabled after a release. Without `--lid`, the only way to run lid-closed is
clamshell mode: AC power plus an external display.

## Reporting

When you start, tell the user in one line, with the cap and the lid note. When you stop, say so
in the final reply. If `start` fails, say that before you begin the long work,
so the user knows the machine may sleep.
