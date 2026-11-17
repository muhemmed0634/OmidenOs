# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# ADR-0003: `omidenos-initcpio` fork of mkinitcpio-archiso

Status: Draft (Phase 0)

## Context

The live environment's early userspace comes from `mkinitcpio-archiso`
(version 73-1 in extra). Its hook names, kernel command line parameters
(`archisobasedir`, `archisosearchuuid`, `archisolabel`, `archisodevice`,
`archiso_http_srv`), runtime mount points (`/run/archiso/...`) and
console messages are user-visible (surface class S1) and carry the
upstream brand.

## Decision

Maintain a small fork, package name `omidenos-initcpio`, derived from the
upstream PKGBUILD. Changes: hook and install file names, parameter
names, `/run/archiso` paths, shutdown script, and user-visible strings.
Upstream documentation files are kept with original copyright and
licensing headers; the fork keeps a patch series that is reviewable
against upstream. `upstream-watch` compares against the pinned upstream
commit weekly.

Out of scope in v1: the PXE hooks (`archiso_pxe_*`) — PXE support is
explicitly out of scope in v1, so the fork drops them (smaller surface).

## Alternatives

- Ship upstream hooks and document the brand strings as S3 exceptions:
  rejected, these are S1 surfaces (boot console, `/proc/cmdline`,
  mounted paths in `findmnt` output).
- Reimplement hooks from scratch: rejected, cost without benefit; the
  upstream hooks are the tested reference implementation (rule 5 of
  section 2: follow the current releng method).

## Consequences

- The profile's `efiboot` kernel command line uses `omidenosbasedir` /
  `omidenossearchuuid` style parameters (names finalized in Phase 2).
- `copytoram`, `cow_spacesize`, and forensic-mode parameters are generic
  and are kept under generic names; forensic mode is implemented as a
  menu entry passing documented kernel parameters (validated in Phase 2
  tests).
