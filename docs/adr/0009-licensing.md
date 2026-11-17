# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0009: Licensing state

Status: Draft — needs owner confirmation before Phase 1 closes

## Context

The project spec requires GPL-3.0-or-later for project code and
CC-BY-SA-4.0 for brand assets, with `reuse lint` clean. The repository
root `LICENSE` (owner-authored, dated before this project structure)
is BSD 3-Clause, Copyright (c) 2026, muhemmed0634.

## Decision (proposed)

- Keep the owner's root `LICENSE` (BSD 3-Clause) unchanged unless the
  owner explicitly chooses GPL-3.0-or-later; the SPDX headers on all
  project files use `BSD-3-Clause` to match the root license.
- Either choice must be recorded here before Phase 1 closes;
  a mixed state (root BSD + file GPL) is not acceptable.

## Alternatives

- Switch everything to GPL-3.0-or-later per the spec: possible only
  with owner confirmation, since the root LICENSE is the owner's file
  and changing another party's license grant is not ours to do.

## Consequences

- `reuse lint` (when installed) validates the SPDX header set; the
  root LICENSE file is the project license and brand assets get their
  own CC-BY-SA-4.0 headers when the logo pipeline lands (Phase 5).
