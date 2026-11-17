# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0005: Calamares is built by us into `[omidenos]`

Status: Draft (Phase 0)

## Context

Calamares is not in official core/extra repositories. Verification: the
official repository databases (core.db/extra.db snapshot of 2026-11-17)
contain no `calamares` package; AUR provides `calamares 3.4.2-2`; the
blackarch repository provides `calamares 3:3.4.3-1`. The installer is a
core component, so third-party repository packages are not acceptable
(section 8).

## Decision

Use a PKGBUILD as a source only (AUR or upstream release tarball, pinned
by commit/tag in `tools/sources.lock.toml`), review it, build in a clean
chroot (`pkgctl build`), sign, and publish as `omidenos-calamares-config`
(calamares itself stays `calamares`) plus our module configurations in a
separate config package.

## Alternatives

- Use the blackarch package: rejected (third-party repo content must not
  enter the ISO).
- Use another installer: rejected; Calamares is the only mature,
  pacman-based, modular graphical installer with the module set required
  by section 5 (packagechooser, netinstall, packages, partition,
  bootloader, users, shellprocess).

## Consequences

- Rebuild required on soname changes of Qt/upstream libraries
  (`docs/update-policy.md` defines the process).
- Calamares module configuration (branding, bootloader entry name, UEFI
  precheck job) lives in `omidenos-calamares-config`.
