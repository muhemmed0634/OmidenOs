# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0006: Display manager — SDDM proposed, LightDM as alternative

Status: Draft (Phase 0) — final after a boot test with XFCE in Phase 5

## Context

Section 3 requires exactly one display manager that can start X11 and,
if available, Wayland sessions, supports branded theming and is light.

## Decision (proposed)

SDDM. Rationale:

- Qt-based, themed via QML with a single logo asset (satisfies 6.1).
- Session files for both X11 and Wayland sessions are supported via the
  standard session discovery; XFCE's Wayland session support is
  immature, which is acceptable because X11 is first-class.
- Active upstream maintenance.
- Calamares' `displaymanager` module supports SDDM out of the box
  (verified in the downloaded Calamares 3.4.3 sources:
  `modules/displaymanager` lists `sddm` among supported DMs).

## Alternatives

- LightDM: GTK-based, lighter, but Wayland support depends on the
  experimental `lightdm-wayland` greeter; theme integration is less
  flexible; kept as fallback if SDDM breaks the XFCE boot test.
- GDM: rejected, pulls a large GNOME dependency set.
- Ly/console: rejected, no branded graphical login required by 6.1.

## Consequences

- `omidenos-dm-theme` provides the SDDM theme generated from
  `branding/source/logo.svg`.
- Autologin for the live user is configured only in the live media;
  the Calamares users module sets the target user without autologin.
