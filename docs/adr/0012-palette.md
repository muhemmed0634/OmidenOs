# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0012: Palette derived from the project crest

Status: Accepted (2026-11-18). Implements section 5b of `docs/ROADMAP.md`.

## Context

Phase 5 needs one set of colours for every surface the project draws itself:
the Plymouth splash (ADR-0011), the SDDM greeter, the XFCE panel and window
titles, and the wallpaper's own background. Before this record, each surface
carried literals: the Plymouth dot was `#8B5CF6` because it was cropped out
of the crest, the splash script assumed a black window, and the wallpaper
was the owner's raster with its own gradient.

Two problems come with per-file literals. The surfaces drift apart after the
first edit, and there is no single place where a wrong colour is wrong.

## Decision

`branding/palette.toml` is the source of truth. It holds one background
(`ink`), one accent (`accent`), and the surface/text pairs that sit on them.
Values were sampled from `branding/source/logo.png`: the crest purples fall
in `#7860d0..#a088e8`, and `accent = #8B5CF6` is the sample that the
Plymouth progress dot in the tree already carries, so the boot screen does
not need to change colour.

Mapping, per surface:

| Surface | File | Colours |
| --- | --- | --- |
| Boot splash | `usr/share/plymouth/themes/omidenos/` | black window (the artwork fades to black), `accent` dot |
| Greeter | `usr/share/sddm/themes/omidenos/` | `ink` backdrop scrim, `surface` card, `accent` border and button |
| Panel | `customize_airootfs.sh` (`xfce4-panel` channel) | `ink` at 94% opacity, `foreground` text |
| Window titles | `customize_airootfs.sh` (`xfwm4` channel) | `Materia-dark` decoration from `materia-gtk-theme` |
| Wallpaper | `usr/share/backgrounds/omidenos/wallpaper.png` | owner artwork, dark enough for `foreground` |

Rules that follow from the mapping:

- One accent in the whole system. A second accent needs a new record, not a
  local literal.
- Text on `accent` is `ink`, never `foreground`; the contrast pair is fixed
  in the file rather than computed per surface.
- Widgets and window decorations come from `materia-gtk-theme`, icons from
  `papirus-icon-theme`, both packages on the medium. They are neutral dark
  surfaces: the accent stays on what the project draws itself (panel, card,
  splash, wallpaper). A palette-derived GTK theme remains a v1.1 item, because
  it would multiply the screens the brand scan has to inspect.

## Alternatives

- Hardcode colours per file: rejected, this is the state the record
  replaces.
- Generate a GTK theme from the palette in v1.0: rejected for scope. It needs
  a theme engine package and its own screen checks in Phase 5c, and it would be
  the only reason to ship a generated widget theme. Shipping `Materia-dark`
  gives the same "not stock" impression without owning a theme build.
- Derive the accent from the wordmark instead of the crest: rejected. The
  wordmark carries white and the same violet, so the crest is the more
  specific sample and it is also what the splash draws.

## Consequences

- A palette change is one edit in `branding/palette.toml` plus a rebuild;
  the greeter reads its values from `theme.conf`, which repeats them because
  SDDM has no TOML reader. The duplication is two files deep and checked by
  `scripts/brand-scan`'s screens mode only visually, so it is listed in
  `docs/BACKLOG.md`.
- The greeter backdrop (`usr/share/backgrounds/omidenos/greeter.png`) is not
  hand-drawn: `scripts/compose-artwork.py` (mode `greeter`) puts the
  wallpaper's crest in the left two thirds and darkens the right third for
  the card. The wallpaper stays the only artwork, and a replacement backdrop
  needs no QML change, only the same 1920×1080 frame.
- The theme packages are a new brand-scan surface: their stock names are
  visible in Settings dialogs only, which is why `screens` mode must ignore the
  theme picker rather than flag it.
- The light variant does not exist. Every surface assumes a dark backdrop,
  which matches the artwork and keeps one screen set to verify.
- The panel and window-title colours are written into the live user's
  xfconf channels by `customize_airootfs.sh`; they are not a theme package,
  so a future second session inherits nothing automatically.
