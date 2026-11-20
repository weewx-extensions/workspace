# weewx-extensions

Workspace for the WeeWX extensions organization: the git repositories that extend WeeWX side by side,
plus symlinks into WeeWX releases.

## Layout

This repository is the git root for the organization. Every subdirectory is a checkout with its own
repository — `aqi-xtype/`, `development-tools/`, `jas/`, `healthchecks/`, `pushover/`, `test/` — or a
symlink into a WeeWX release (`weewx`, `weewx-fork`). Nothing below this directory belongs to this
repository.

## Contents

- `AGENTS.md` — workspace-level agent guidance shared across the organization.
- `status-all.sh` — report the working tree of every repository here; `--common` also checks the
  vendored shared files.
- `README.md` — this file.

## Provisioning

The development tools provision this tree from scratch with
`weewx-extensions/development-tools/tools/setup.sh`, which clones the organization repositories into
this directory and links the WeeWX releases.
