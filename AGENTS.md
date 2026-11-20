# AGENTS.md

Workspace for the WeeWX extensions organization: the git repositories that extend WeeWX side by side,
plus symlinks into WeeWX releases. A session started in any of them loads this file, so it holds only
what is true across repositories; each repository's own `AGENTS.md` holds its details.

## Repositories

| Directory | What it is |
| --- | --- |
| `aqi-xtype/` | WeeWX extension adding an air-quality index type. |
| `development-tools/` | The shared development toolkit: CI workflows, tools, configs, docs and workflow templates, and a sample extension. |
| `jas/` | WeeWX extension. |
| `healthchecks/` | WeeWX extension reporting health checks. |
| `pushover/` | WeeWX extension sending notifications. |
| `test/` | Sample extension the development toolkit is exercised against. |

## Order of a cross-repo change

1. Change `development-tools`, run its suite.
2. In each affected consumer: `source .devenv`, `commonrepos.sh`, then adapt the local call sites.
3. `verify.sh` in each repository.
4. Stage per repository and stop.

## Environment

Each repository has its own `.devenv`; source it in that repository's shell before running
anything.

```bash
source .devenv
export PYTHONPATH="$WEEWX_PYTHONPATH"
```

The full gate is development-tools' `verify.sh`: environment, lint of modules and tests, actionlint,
shared-config and common-repo checks, and every test suite.

## Standing rules

- **Ask before every commit, push, tag or release.** A task request is not permission to commit,
  and "do it" for a change does not include committing it. Propose the commit message (and the
  release version, if any) and wait for an explicit go-ahead. Don't pre-stage; the user stages
  while reviewing large changes, so staged files are not a commit request. Once approved, stage
  and commit that logical step in one go, and push only when asked.
- Python 3.9 syntax — the CI matrix starts at 3.9.13.
- **Comments explain why, not how.** The code is the definitive description of what it does;
  comments should record intent, trade-offs, invariants and hazards — not narrate the statements
  below them. Use a comment when the reason would otherwise be invisible, and point at the
  symbol/file rather than repeating its logic.
- A new config option needs the `install.py` template and the matching docs page (each
  repository's `AGENTS.md` says where).

## Sessions

- One repository, one change: start in that repository. Worktrees, `.devenv`, `verify.sh` and git
  all align there.
- Cross-repo work (shared change, rename, wording pass): start here and `cd` per repository.
  `./status-all.sh` shows the working tree of every repository here (`--common` also checks the
  vendored shared files); a plain `git status` here only sees the workspace files.
