# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0011: Boot splash — Plymouth with the project artwork

Status: Accepted (owner decision, 2026-11-18).

## Context

Section 6.1 asks for a graphic that identifies the project from power-on,
and the owner asked for the project logo to own the screen while the medium
boots. The Phase 2 entries already run with `quiet loglevel=3`, so the
console shows almost nothing on the normal paths; the boot therefore looks
like a black screen for the ~75 s the live medium needs.

## Decision

The live medium boots through Plymouth with one project theme:

- `plymouth` is a package of the profile and sits directly after `udev` in
  `HOOKS`, where it can open the DRM device before the block and
  filesystem hooks write to the console.
- The theme lives in `archiso/airootfs/usr/share/plymouth/themes/omidenos/`
  and uses the `script` plugin: `splash.png` (1280×720, the crest and the
  wordmark, edges faded to pure black so the artwork sits on the black
  background without a border at any resolution) plus three accent dots
  that fade in sequence. No font is loaded, so the splash does not depend
  on a font package inside the initramfs.
- `/etc/plymouth/plymouthd.conf` carries `Theme=omidenos` and `ShowDelay=0`.
  It belongs to the `plymouth` package, so it is written by
  `customize_airootfs.sh`, the same mechanism as the identity file.
- The kernel package builds an initramfs during package installation, long
  before the theme and the theme selection exist, so
  `customize_airootfs.sh` runs `mkinitcpio -P` once they are in place.
  mkarchiso copies `/boot` out of the airootfs after that step.
- `splash` is added to the two quiet entries (`OmidenOS Live`, copy to
  RAM). The safe-graphics and forensic entries stay verbose: `nomodeset`
  has no DRM device for Plymouth to draw on, and the forensic entry exists
  to watch device detection.

The artwork is derived from `branding/source/logo.png` (owner's raster, the
cat crest with crescent and star). The derived files are recorded as brand
assets in `REUSE.toml`, and the same crop supplies the panel icon.

`splash.png` is 1920×1080 and is composed by
`scripts/compose-artwork.py` (mode `splash`) from the wallpaper: the
artwork filling the frame with all four edges faded to pure black, which is
the background the theme paints. Plymouth never scales an image up, so the
1280×720 version the theme first shipped would have left the crest at two
thirds of a 1080p panel. The script is in the tree so the splash can be
rebuilt when the wallpaper changes instead of being retouched by hand.

## Alternatives

- Kernel `bootsplash` patch: needs the project kernel (ADR-0002), which is
  recommended for v1.1 and not part of v1.0.
- `fbsplash`: unmaintained, and it needs the same initramfs work.
- A GRUB theme: there is no GRUB in this profile (ADR-0007).
- Leaving the console as it is: that is what the medium does today, and it
  fails 6.1 on the surface every user sees first.

## Consequences

- The initramfs grows by the artwork: `splash.png` is about 0.65 MiB.
- The splash is only in the tree, not verified: it has never been built
  into an ISO or seen on a screen. The `script` theme is the part most
  likely to fail silently, so the first build has to be checked on both
  hypervisors before Phase 5 can close.
- SDDM still shows its stock greeter theme. A greeter theme generated from
  the crest is a separate item in `docs/BACKLOG.md`; this ADR only covers
  the pre-greeter splash.
