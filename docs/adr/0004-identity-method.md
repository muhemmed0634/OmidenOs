# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# ADR-0004: Identity files — method comparison pending, placeholder decision

Status: Draft (Phase 0) — final choice after measurement in Phase 3

## Context

`/etc/os-release`, `/usr/lib/os-release`, `/etc/issue`, `/etc/motd` and
the `LOGO=` reference come from the `filesystem` package
(2025.10.12-1: `ID=arch`, `NAME="Arch Linux"`, `LOGO=archlinux-logo`).
They are the most user-visible identity surfaces (S1).

## Decision (placeholder)

Evaluate the three candidate methods from section 6.3.3 and select the
one with least friction:

1. `omidenos-filesystem` package that `Replaces: filesystem` and ships
   rewritten identity files.
2. `NoExtract` in the target `pacman.conf` plus identity files from
   `omidenos-base`.
3. A pacman hook that rewrites files after every `filesystem` upgrade.

Measured criteria (Phase 3): clean install, `pacman -Syu` simulation,
`pacman -Qkk` result, and upgrade collisions. The measurement protocol
runs against the live `core`/`extra` databases of the release day.

## Alternatives

Already enumerated above; all three are implemented behind a common
identifier-pkg interface so the comparison is cheap.

## Consequences

- `/etc/os-release` gets `ID=omidenos` (no `ID_LIKE` by default;
  ADR exception only if a concrete breakage of common tooling is
  demonstrated and reproducible), `LOGO=omidenos` plus the hicolor icon.
- The sysctl file `10-arch.conf` (filename and upstream comment URLs) is
  either replaced by an equivalent `omidenos-base` file (S2 method b) or
  recorded as an exception in `upstream-allowlist.toml`.
