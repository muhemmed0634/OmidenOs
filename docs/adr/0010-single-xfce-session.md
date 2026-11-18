# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0010: Desktop session — XFCE only in v1.0

Status: Accepted (owner decision, 2026-11-18). Supersedes the three-session
scope previously recorded in `docs/BACKLOG.md` and Phase 5 of
`docs/ROADMAP.md` (KDE Plasma, GNOME, Hyprland).

## Context

The three-session plan cost more than it returned. Each session needed its
own defaults file, its own way of applying the wallpaper (Hyprland reads
none of the XDG autostart entries, GNOME and KDE read different keys), its
own session-file name in SDDM, and its own cell in the Phase 6 install
matrix. Only the panel files of KDE Plasma and GNOME were stock; the
project-specific parts — panel layout, wallpaper, menu — had to be written
three times and checked three times on two hypervisors.

The owner asked for a single session instead: XFCE, with the login going
straight into it. XFCE is an X11 desktop, so the Wayland half of the
graphics stack is no longer exercised by any session in this profile.

## Decision

v1.0 ships exactly one desktop session: **XFCE on X11**, started by SDDM
(ADR-0006 unchanged) with autologin for the live user. The session carries
project defaults rather than the stock first-run look:

- `xfce4-panel` with the project menu (whisker menu, project icon), window
  list, notification area, mixer and clock, written to the live user's
  xfconf channel — this also removes the panel's first-start dialog on a
  medium where the user has never logged in.
- `xfwm4` with four named workspaces and the stock window theme.
- `xsettings` with the dark stock theme (`Adwaita-dark`) and the stock icon
  set; no theme is pulled from outside the medium.
- `xfce4-desktop` with the project wallpaper on the single-monitor path;
  `omidenos-session` fills in the per-monitor backdrop properties that only
  exist after xfdesktop has probed the display.
- The project icon at `/usr/share/icons/hicolor/{48x48,256x256}/apps/omidenos-logo.png`,
  derived from `branding/source/logo.png`, is what the menu button and
  `LOGO=` in the identity file point at.

Removed with this decision: `gnome`, `plasma-meta`, `plasma-nm`,
`hyprland`, `waybar`, `wofi`, `kitty`, `swaybg`, `xorg-xwayland` and the
`xdg-desktop-portal-{gnome,kde,hyprland}` backends, plus the Hyprland
configuration that `customize_airootfs.sh` used to write.

## Alternatives

- Keep three sessions: rejected by the owner. The cost was in the session
  defaults and in the install matrix, not in the package size alone.
- KDE Plasma as the single session: rejected by the owner as well. Plasma
  pulls a larger dependency set and its defaults need the same amount of
  project-specific work as XFCE's.
- LightDM instead of SDDM: not re-opened. ADR-0006 already accepts X11
  sessions through SDDM, and switching would change the greeter and the
  Calamares `displaymanager` module at the same time.

## Consequences

- The Phase 6 install matrix collapses from three sessions × two toolset
  tiers to one session × two toolset tiers: N = 2.
- Wayland is not exercised anywhere in v1.0. `xorg-xwayland` is out of the
  package set; a future Wayland session adds it back together with its
  portal backend.
- The brand scan in screens mode has one session to check instead of three,
  which is the phase-5 exit criterion.
- GNOME, KDE Plasma and Hyprland are not cancelled, they are out of v1.0.
  A fourth session returns only on an explicit owner decision, recorded in
  this file or in a new ADR.
