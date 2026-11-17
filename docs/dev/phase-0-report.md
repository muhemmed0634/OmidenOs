# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# Phase 0 report — discovery and plan

Date: 2026-11-17. Host: `cachyos-x8664`, kernel 7.3.3-1-cachyos.

## Environment verification (all measured on this host)

| requirement | measured value | verdict |
| --- | --- | --- |
| pacman-based host | CachyOS (pacman 7.1.0, `ID_LIKE=arch`) | OK |
| archiso | `archiso 92-1` installed; `mkarchiso` at `/usr/bin/mkarchiso`; releng profile at `/usr/share/archiso/configs/releng/` | OK |
| releng `bootmodes` names | `('bios.syslinux', 'uefi.systemd-boot')` (profiledef.sh). UEFI-only profile keeps only `uefi.systemd-boot` | OK |
| KVM | `/dev/kvm` present, `vmx`/`svm` flags present | OK |
| RAM | 15 GiB (+15 GiB swap) | OK (16 GiB recommendation met in effect) |
| disk | 417 GiB free on `/` | OK |
| CPU | 8 threads | OK |
| root access | user `cachy` is not root; `sudo` requires a password; user is in `docker` group and Docker daemon is reachable (server 29.9.3) | partially OK: privileged build via container works without sudo; package installation on the host needs user-run sudo commands |
| build helpers | `devtools` (pkgctl) not installed; shellcheck/shfmt/ruff/mypy/reuse not installed | missing, needed in Phase 1 (host install or container) |
| test tooling | `qemu-system-x86_64`, `edk2-ovmf 202608-1` (OVMF at `/usr/share/edk2/x64/OVMF_CODE.4m.fd`, `OVMF_VARS.4m.fd`), `xorriso` | OK |

Network note: `archlinux.org` main site is unreachable from this network
(TLS reset, verified repeatedly), while sync mirrors and
`aur.archlinux.org` work. Nothing in the build path depends on the main
site; discovery used mirror-hosted repo databases instead.

## Tool resolution

See `docs/dev/tool-resolution-report.md`. Summary: 168 ids → 96 official,
57 AUR, 15 third-party-proxy-only, 0 unresolvable.

## Upstream name inventory

See `docs/dev/upstream-name-inventory.md`.

## Kernel build cost estimate (unverified, to be measured in Phase 3)

- Stock `linux 7.3.4.arch1-2`: 151 MiB compressed package.
- Expected per-build cost on this host: ~1–2 h compile, ~4–8 GiB scratch,
  with a clean-chroot container build adding image download time.
- CI implication: kernel builds are the long pole; the `build-iso.yml`
  job builds the kernel only when its version bumps, caching the
  `[omidenos]` repository between runs.

## Bootloader × LUKS × filesystem research

See `docs/adr/0007-bootloader-luks-fs-constraints.md`. Key constraint:
GRUB cannot unlock LUKS2/Argon2id boot devices; the installer must use
PBKDF2 for GRUB's boot device or an unencrypted `/boot`. Runtime tests
in Phase 6 verify each cell of the compatibility table.

## Risk register (Phase 0 view)

| risk | impact | mitigation |
| --- | --- | --- |
| sudo needs password for host package installs | Phase 1 lint tooling install | run installs as user-entered sudo commands, or do everything in the privileged container |
| `archlinux.org` unreachable | API-based checks fail | use mirror DBs and AUR RPC for `upstream-watch` |
| Logo exists only as 1280×720 raster PNG | 6.1 requires an SVG source for derivatives | owner provides vector file, or auto-vectorization (quality-limited) in Phase 5; decision requested |
| AUR package quality varies | broken/abandoned packages in `[omidenos]` | PKGBUILDs reviewed per package, pinned to commit, built in clean chroot; unmaintained candidates (e.g. `ubertooth 2020.12.R1`) flagged for re-selection in Phase 4 |
| `pacu`, `scoutsuite`, `checkov`, `prowler` are Python-heavy | ISO size budget 6 GiB | measure in Phase 4; demote to `extended` tier if needed |
| Host repos (cachyos/blackarch) leak into builds | contamination | build profile `pacman.conf` pins `[core]`, `[extra]`, `file:// [omidenos]` only |
| Old project content still tracked in git while deleted on disk | unclear repository history | decision requested from owner |

## Phase timeline (proposal)

| phase | content | exit criterion |
| --- | --- | --- |
| 1 | repo skeleton, licenses/REUSE, lint chain, Makefile, brand-scan skeleton | `make lint` green |
| 2 | UEFI-only profile from releng, identity files, omidenos-initcpio | OVMF live boot proof, no BIOS traces, `brand-scan strict` green |
| 3 | PKGBUILDs, signed `[omidenos]` repo, linux-omiden | live boot with own kernel, `brand-scan runtime` green |
| 4 | manifest + generators + meta packages to ≥100 tools | `make count` ≥ 100, size budget measured |
| 5 | brand pipeline, Plymouth, DM, XFCE then KDE/i3/GNOME sub-phases | `brand-scan screens` green per desktop |
| 6 | Calamares config, UEFI precheck, choices, cleanup, matrix tests | `make matrix` green, `verify --installed` clean |
| 7 | hardening review, docs, SBOM, release pipeline | section 15 definition-of-done audit |

## Decisions recorded (owner confirmed, 2026-11-17)

1. Logo: the owner will provide a vector `logo.svg`; until then
   `branding/source/logo.png` (the provided 1280×720 raster) is the
   reference asset. Tracked in `docs/BACKLOG.md`; blocks Phase 5.
2. Project URLs: GitHub repo `https://github.com/muhemmed0634/OmidenOs`
   is the homepage and issue tracker; no placeholder URLs needed.
3. Desktop scope: XFCE only in v1.0. KDE Plasma, i3 and GNOME move to
   v1.1+ sub-phases (BACKLOG).
4. Pairwise full-install test count: N = 12.
5. Secure Boot: unsupported in v1, ISO unsigned (default confirmed).
6. `[omidenos]` hosting: GitHub Releases of this repository; no mirror
   infrastructure exists.
7. Legacy content (previous iteration's `archiso-profile/`, `dotfiles/`,
   `site/` etc. deleted on disk): removal committed, fresh structure in
   Phase 1.
