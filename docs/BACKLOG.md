# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# Backlog

Items are ordered roughly by the phase in which they become actionable.
Nothing in this file is claimed to work; these are pending items.

## Blocked on owner input

- `branding/source/logo.svg`: owner will provide the vector source
  (decision of 2026-11-17). Until it arrives,
  `branding/source/logo.png` (the owner's 2026-11-17 update: cat and
  crescent emblem) is the current asset; the desktop wallpaper uses the
  provided logo as-is per owner instruction.
- Palette adaptation: `branding/palette.toml` is written and the mapping is
  in `docs/adr/0012-palette.md`; the accent was sampled from the crest
  rather than generated, so a vector crest only changes the sampling input.
- Greeter backdrop artwork (optional): the generated frame in
  `usr/share/backgrounds/omidenos/greeter.png` is the fallback. A hand-made
  frame is welcome but not blocking; it must be 1920×1080 with the crest in
  the left two thirds and the right third dark.

## v1.0 scope decisions recorded

- Desktop scope: one session in v1.0 — XFCE on X11, autologin behind
  SDDM (ADR-0010, 2026-11-18). KDE Plasma, GNOME, Hyprland and i3 are out
  of v1.0; a second session returns only on an explicit owner decision.
- Language: English is the default and only language of the v1.0 medium.
  A Turkish variant is planned as a separate artefact (translated motd,
  issue, boot text and session hints) and needs its own decision record
  before it is built.
- Secure Boot: unsupported in v1.0; the ISO is not signed. Investigation
  notes (shim + MOK enrollment, or own-key enrollment) go into
  `docs/uefi.md` when Phase 2/7 writes it; implementation stays here.
- LTS second kernel: out of v1.0 scope.
- Text-based fallback installer: out of v1.0 scope.

## Phase 1+

- REUSE-compliant license headers on every file; `reuse lint` green.
- Lint toolchain (shellcheck, shfmt, ruff, mypy, reuse) installed in the
  build container because the host needs sudo for package installs.
- Decision on `docs/PART3-ARCHISO.md`-style legacy docs: none of the
  deleted content is reintroduced; new docs come from phases 2–7.

## Phase 3

- `docs/dev/hosting.md`: document GitHub Releases as the `[omidenos]`
  distribution channel (decision of 2026-11-17) and the mirror-use
  policy for upstream repos (S3 exception, no own mirrors).
- Forensic-mode activation: wire the `omidenosforensic` parameter into
  the omidenos-initcpio hooks (read-only block devices, no auto-mount,
  no swap/zram) and verify the entry in `archiso/efiboot/` boots with
  the expected behavior. The Phase 2 menu entry is a placeholder until
  then; the allowlist rows in `branding/upstream-allowlist.toml` are
  removed in the same step.

## Phase 4

- Verify maintenance status of AUR candidates (`ubertooth` 2020.12.R1,
  `steghide`, `autopsy`, `sigma` packaging identity) and re-select
  replacements where the activity bar (last ~2 years) fails.
- Size budget measurement; demote heavy Python toolsets (prowler,
  scoutsuite, checkov, pacu) to `extended` tier if the 6 GiB budget is
  exceeded.

## Phase 5

- Boot splash: verified on the 2026-11-18 16:43 build (crest, wordmark and
  the pulsing dots on screen in VirtualBox/VMSVGA). A QEMU/OVMF run is still
  worth doing for the `nomodeset` entries, which do not paint the splash by
  design.
- Greeter: verified on the 2026-11-18 16:43 build by logging out of the live
  session - the card, clock and artwork paint, and the username is
  pre-filled. What is still uncovered: a failed login (wrong password) and the
  `keyboard.capsLock` hint, because the live user has no password to get
  wrong.
- The wallpaper write depends on xfdesktop keying backdrops by monitor
  connector (`monitor<connector>`). Upstream carries a note that it intends to
  move to `xfw_monitor_get_identifier()`, which would change the key string
  again; `omidenos-session` writes `monitor0` as a fallback and the behaviour
  is covered by `tests/test_session_monitors.py`.
- Greeter backdrop is generated, not designed: `greeter.png` is composed
  from the wallpaper by `scripts/compose-artwork.py`. If the owner
  provides a hand-made frame, it only has to be 1920×1080 with the right
  third quiet; `theme.conf` then points at it and nothing else changes.
- `/usr/bin/sddm-greeter` is replaced with a symlink to
  `sddm-greeter-qt6` by `customize_airootfs.sh`, because the package's
  unversioned greeter is Qt5-linked and the medium ships no Qt5: it exits
  127 and SDDM paints a black tty1. This is a package-owned file written by
  the customize step, the same class of debt as `/usr/lib/os-release`; drop
  the symlink if the package ever ships a Qt6 unversioned greeter or if a
  Qt5 greeter theme is added.
- Phase 5c's `brand-scan --mode screens` does not exist yet; the greeter and
  desktop have boot evidence in `docs/dev/verification.md`, but no automated
  screen check.
- `brand-scan` in screens mode does not exist yet; the phase-5 exit
  criterion depends on it running against the one session.

## Out of v1.0 scope (owner decision, 2026-11-17)

- GRUB bootloader option and its theme (`omidenos-grub-theme`).
- LUKS full-disk encryption option.
- btrfs and xfs filesystem options (ext4 is the default and only
  first-class v1.0 target).

## Licensing note (to resolve in Phase 1)

- The current `LICENSE` at the repository root is BSD 3-Clause
  (Copyright (c) 2026, muhemmed0634). The project spec requires
  GPL-3.0-or-later for code and CC-BY-SA-4.0 for brand assets. The
  license set (root LICENSE + per-file SPDX headers) must be aligned
  with the owner before Phase 1 closes; this is the only open licensing
  question.

## No placeholder URLs in use

- The repository URL is real (GitHub). No RFC 2606 `.invalid`
  placeholders are currently in the tree; if any appear, they are
  tracked here until replaced.
