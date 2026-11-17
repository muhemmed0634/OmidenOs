# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# Roadmap

Sequence and gates only. The item-level list of open work lives in
`docs/BACKLOG.md`; decision records live in `docs/adr/`.

A phase closes when its exit criterion is backed by a recorded check in
`docs/dev/`, not when the files look complete. Effort figures are
estimates for one developer on the recorded build host, which cannot
install packages without a password and builds the ISO as root by hand.

## Where the project stands

| Phase | Content | State | Evidence |
| --- | --- | --- | --- |
| 0 | Discovery, tool resolution, decisions | done | `docs/dev/phase-0-report.md` |
| 1 | Repository skeleton, lint chain, brand scan | done | `make lint`, CI green |
| 2 | UEFI-only live medium | done 2026-11-17 | `docs/dev/verification.md` |
| 3 | Own repository, own hooks, own kernel | next | not started |
| 4 | Tool manifest and meta packages | planned | not started |
| 5 | Desktops (KDE Plasma, GNOME, Hyprland) and identity | in progress | sessions in tree, no build yet |
| 6 | Calamares, install matrix | planned | not started |
| 7 | Hardening, SBOM, signed release | planned | not started |

Phase 1 stays formally open on one item: the license choice in
`docs/adr/0009-licensing.md`. Nothing else in it is outstanding.

## Phase 3 — own repository and own hooks (next, 3 weeks)

Two tracks that share a signing key and a package repository.

3a. Distribution channel (1 week)
- GPG signing key for the project; public key packaged as
  `omidenos-keyring` so installs can trust the repository.
- `[omidenos]` repository published on GitHub Releases, `repo-add` in the
  release job, `pacman.conf` in the profile gaining the stanza.
- `tools/sources.lock.toml`: upstream sources pinned by commit or tag.
- `docs/dev/hosting.md`, referenced by `docs/BACKLOG.md`, recording the
  channel and the mirror policy.
- Exit: a package installs from `[omidenos]` in the live medium and
  `pacman -Qkk` reports nothing.

3b. `omidenos-initcpio` fork (2 weeks)
- Derived from the upstream live hooks: hook names, kernel command line
  parameters, `/run` mount paths and console strings carry the project
  name (ADR-0003).
- PXE hooks dropped, they are out of v1.0 scope.
- Forensic mode made real: `omidenosforensic` mounts block devices
  read-only, skips automounting, disables swap and zram.
- Exit: the medium boots with the fork, the forensic entry behaves as
  documented, `brand-scan` in runtime mode is green, and
  `branding/upstream-allowlist.toml` is empty.

Sequencing note: 3a must land before 3b, because the fork is delivered as
a package from `[omidenos]`.

## Phase 3c — own kernel (recommended for v1.1, not v1.0)

`linux-omiden` changes the package name, the localversion suffix and the
build-user strings, nothing functional (ADR-0002). It costs one long
build per upstream kernel release and blocks the release train whenever
it breaks.

Recommendation: keep the stock kernel through v1.0, ship it as the first
item of v1.1. The brand scan already allows the stock suffix for that
reason, and `docs/dev/verification.md` records the leak honestly.

## Phase 4 — tool manifest (3 weeks)

- `tools/manifest.toml`: id, binary, tier (`core` / `extended`), source
  (official / AUR / upstream), license, and how the tool is verified to
  exist and run.
- Generators from the manifest to meta packages
  (`omidenos-tools-core`, `omidenos-tools-extended`) and to the profile
  package list.
- Vet the AUR candidates from `docs/dev/tool-resolution-report.md`:
  57 entries is a maintenance burden, cut to about 40 with a documented
  replacement for each drop, keeping only packages active in the last
  two years.
- Size budget: measure, and demote the Python-heavy toolsets to
  `extended` if the medium passes the 6 GiB target.
- Exit: `make count` reports at least 100 tools, the manifest validates
  in CI, and the measured ISO size is recorded.

## Phase 5 — desktops and identity (4 weeks)

Three sessions in v1.0 over one display manager: KDE Plasma (Wayland,
default), GNOME (Wayland) and Hyprland (Wayland). XFCE and i3 are
dropped from the plan. Package set and session files land first,
theming afterwards.

5a. Sessions (1 week)
- SDDM as the only display manager (ADR-0006); autologin to KDE Plasma
  on the live medium, text console on tty2 as the fallback.
- Hyprland gets a short configuration written by the project; GNOME and
  KDE keep their own defaults.
- Exit: each session starts from SDDM and survives a reboot. Hyprland
  needs OpenGL, so it is verified both in QEMU with GL enabled and in
  VirtualBox with 3D acceleration on.

5b. Identity (2 weeks)
- `branding/palette.toml` with the accent colour derived from the crest,
  and the mapping recorded in an ADR.
- Plymouth theme, console identity, one wallpaper set that works for all
  three sessions.
- SDDM theme generated from the crest.

5c. Screens (1 week)
- Exit: `brand-scan` in screens mode is green per session on a fresh
  install, with no third-party distribution name anywhere a user can see
  it. GNOME is not planned; a fourth session is added only on request.

## Phase 6 — installer (4 weeks)

- `omidenos-calamares-config`: branding, users, packagechooser,
  netinstall, partition, bootloader, cleanup and the UEFI precheck job
  (ADR-0005).
- Partition and bootloader pages fixed to ext4 and systemd-boot; the
  summary page states both. No encryption option (ADR-0007).
- Cleanup: remove the live user, the passwordless sudo rule, the build
  tooling and the installer itself from the target system.
- `verify --installed`: installed system carries the project identity,
  no third-party names, and no live-medium leftovers.
- Exit: `make matrix` green over the agreed dimensions, and one manual
  install reviewed end to end. With three sessions the matrix is desktop
  (KDE Plasma, GNOME, Hyprland) × toolset (core, extended) and swap and
  shell fixed, so N = 6 rather than the N = 8 of the Phase 0 report.

## Phase 7 — hardening and release (3 weeks)

- Hardening review: sysctl set, mount options, service list, sudoers,
  removal of anything the medium does not need.
- `docs/uefi.md` (ESP layout, `EFI/omidenos`, fallback `EFI/BOOT`,
  NVRAM entry, the absence of Secure Boot) and `docs/update-policy.md`.
- SBOM generated from the package manifest, attached to the release.
- Signed ISO, checksums, and a release workflow that rebuilds from a
  tagged commit rather than from a workstation.
- Exit: the definition of done below passes on a clean checkout.

## Definition of done for v1.0

| Gate | Command or artefact |
| --- | --- |
| Static checks, full tool set | `make lint` with no skipped tool |
| Medium builds reproducibly | `make iso` with a pinned `SOURCE_DATE_EPOCH` |
| Medium boots on UEFI only | `make boot-test`, serial log committed to `docs/dev/` |
| Tool count and manifest | `make count` at least 100, manifest validated |
| Install matrix | `make matrix` green, N = 8 |
| Brand | `brand-scan` strict, image, runtime and screens all green, allowlist empty |
| Release | signed ISO, sha256, SBOM, tags with assets |

`make iso`, `make boot-test`, `make count` and `make matrix` do not exist
yet; they are part of the phase that needs them, not a separate task.

## Critical path and parallel tracks

Critical path: Phase 3a → 3b → 6 → 7. The medium cannot install itself
without the hook set, and cannot ship without the installer.

Parallel after 3a: Phase 4 (manifest) and Phase 5 (brand) do not depend
on each other or on Calamares. They can absorb waiting time while the
kernel and installer work stalls.

Long poles: vetting 40 AUR packages in Phase 4, and the Phase 6 matrix
runs. Both are mechanical; automating them is cheaper than doing them
twice.

## Scope cuts already decided

- No GRUB, no LUKS, no btrfs or xfs, no second kernel, no text
  installer, no Secure Boot in v1.0 (ADR-0007 and `docs/BACKLOG.md`).
- Three sessions in v1.0: KDE Plasma (default), GNOME and Hyprland, all
  Wayland. XFCE and i3 are dropped from the plan.
- Recommended addition: move `linux-omiden` from v1.0 to v1.1 (Phase 3c
  above), because it is cosmetic and the most frequent breakage.

## Open decisions blocking the plan

| Decision | Blocks | Where |
| --- | --- | --- |
| License: BSD-3-Clause or GPL-3.0-or-later | Phase 1 closure, all asset headers | `docs/adr/0009-licensing.md` |
| Vector crest | Phase 5 artwork | `docs/BACKLOG.md` |
| Identity file method | Phase 3 packaging of the identity files | `docs/adr/0004-identity-method.md` |

The current identity mechanism writes `/usr/lib/os-release` from
`customize_airootfs.sh`, which the profile itself marks as deprecated.
Picking one of the three ADR-0004 methods removes that dependency before
the installer has to reproduce the same files.

## Risks

| Risk | Mitigation |
| --- | --- |
| AUR packages break or vanish under the tool set | pin sources, vet activity, keep an official replacement per package |
| Kernel rebuild cost swallows the schedule | keep it out of v1.0 (Phase 3c) |
| Installer test matrix grows | fix the dimensions before Phase 6 starts, do not add options mid-phase |
| Signing key custody is a single point of failure | document key handling in `docs/dev/hosting.md`, keep an offline copy |
| Phase drift: tree looks done before the gate passes | every phase exit names the file that proves it |
