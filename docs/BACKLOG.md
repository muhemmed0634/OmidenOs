# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# Backlog

Items are ordered roughly by the phase in which they become actionable.
Nothing in this file is claimed to work; these are pending items.

## Blocked on owner input

- `branding/source/logo.svg`: owner will provide the vector source
  (decision of 2026-11-17). Until it arrives, `branding/source/logo.png`
  (1280×720 raster) is the only brand asset; the desktop wallpaper uses
  the provided logo as-is per owner instruction.

## v1.0 scope decisions recorded

- Desktop scope: XFCE only (Phase 5). KDE Plasma, i3 and GNOME are
  v1.1+ sub-phases, each with its own acceptance criteria.
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

## Phase 4

- Verify maintenance status of AUR candidates (`ubertooth` 2020.12.R1,
  `steghide`, `autopsy`, `sigma` packaging identity) and re-select
  replacements where the activity bar (last ~2 years) fails.
- Size budget measurement; demote heavy Python toolsets (prowler,
  scoutsuite, checkov, pacu) to `extended` tier if the 6 GiB budget is
  exceeded.

## Phase 6

- Runtime verification of the bootloader × LUKS × filesystem
  compatibility table in ADR-0007; update the ADR with measured results.

## No placeholder URLs in use

- The repository URL is real (GitHub). No RFC 2606 `.invalid`
  placeholders are currently in the tree; if any appear, they are
  tracked here until replaced.
