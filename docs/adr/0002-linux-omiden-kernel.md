# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0002: Own kernel package `linux-omiden`

Status: Draft (Phase 0)

## Context

The live media and installed systems must present OmidenOS identity on
all user-visible surfaces, including `uname -r`, `/proc/version` and the
dmesg banner. The stock `linux` package carries the version suffix
`arch1` (package `linux 7.3.4.arch1-2` in core; suffix comes from the
kernel `EXTRAVERSION` set by the upstream PKGBUILD naming).

## Decision

Derive `linux-omiden` from the official `linux` PKGBUILD. Changes are
limited to: package name, `pkgbase`, kernel localversion/EXTRAVERSION
suffix (`-omiden`), and any build-host/user strings that end up in the
kernel banner. No configuration changes in v1 unless a functional gap is
found (documented separately if so).

## Alternatives

- Ship the stock `linux` package: rejected, breaks section 6.3.1.
- Rebuild with `kernelname` patches: equivalent cost to the PKGBUILD
  derivation; more invasive; rejected.

## Consequences

- Every kernel release must be rebuilt and published in `[omidenos]`.
  Build cost estimate (unverified, measured in Phase 3): ~1–2 h on the
  8-core build host, ~4–8 GiB scratch space per build; package size
  comparable to `linux` (151 MiB compressed, ~152 MiB installed for the
  kernel package itself; headers ~73 MiB compressed).
- `upstream-watch` tracks the official `linux` PKGBUILD and opens a
  rebuild task on change.
- `linux-omiden-headers` is required for optional DKMS packages (Wi-Fi
  drivers, GPU out-of-tree drivers).
- No second kernel in v1 (LTS kernel: backlog).
