#!/usr/bin/env python3
# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
"""Compose the boot splash and the greeter backdrop from the wallpaper.

Both surfaces are derived from `branding/source/logo.png`'s wallpaper so the
project draws nothing but the owner's artwork. Keeping the derivation in the
tree means the two images can be rebuilt after the wallpaper changes instead
of being edited by hand.

Modes:

  splash   1920x1080, the wallpaper filling the frame with every edge faded
           to pure black, which is the background the Plymouth theme paints.
           Plymouth never scales an image up (ADR-0011), so the splash is
           authored at a resolution that covers a 1080p panel natively.

  greeter  1920x1080, the crest and the wordmark as the left two thirds of
           the frame and the right third left dark for the login card. Only
           the artwork's right edge is faded, so the crop leaves no seam
           above or below it. SDDM's theme points at this file.

Usage: compose-artwork.py <mode> <wallpaper.png> <out.png>
"""

from __future__ import annotations

import sys

from PIL import Image, ImageEnhance, ImageFilter

FRAME = (1920, 1080)
SPLASH_FADE = 220
GREETER_CROP = (300, 0, 1560, 1080)
GREETER_FADE = 260


def splash(wallpaper: Image.Image) -> Image.Image:
    art = wallpaper.resize(FRAME, Image.Resampling.LANCZOS)
    mask = Image.new("L", FRAME, 255)
    pixels = mask.load()
    assert pixels is not None
    for x in range(FRAME[0]):
        for y in range(FRAME[1]):
            edge = min(x, y, FRAME[0] - 1 - x, FRAME[1] - 1 - y)
            if edge < SPLASH_FADE:
                pixels[x, y] = int(255 * edge / SPLASH_FADE)
    black = Image.new("RGB", FRAME, (0, 0, 0))
    return Image.composite(art, black, mask)


def right_fade(size: tuple[int, int]) -> Image.Image:
    mask = Image.new("L", size, 255)
    pixels = mask.load()
    assert pixels is not None
    width, height = size
    for x in range(max(0, width - GREETER_FADE), width):
        value = int(255 * (width - 1 - x) / GREETER_FADE)
        for y in range(height):
            pixels[x, y] = value
    return mask.filter(ImageFilter.GaussianBlur(GREETER_FADE / 6))


def greeter(wallpaper: Image.Image) -> Image.Image:
    # Field: the same artwork, enlarged to fill the frame, blurred and
    # darkened, so the space behind the card belongs to the artwork instead
    # of being flat black.
    field = wallpaper.resize(FRAME, Image.Resampling.LANCZOS)
    field = field.filter(ImageFilter.GaussianBlur(40))
    field = ImageEnhance.Brightness(field).enhance(0.42)

    shade = Image.new("L", FRAME, 0)
    shade_pixels = shade.load()
    assert shade_pixels is not None
    for x in range(FRAME[0]):
        factor = 1.0 - 0.6 * min(1.0, x / (FRAME[0] * 0.62))
        for y in range(FRAME[1]):
            shade_pixels[x, y] = int(255 * factor)
    ink = Image.new("RGB", FRAME, (6, 2, 15))
    field = Image.composite(field, ink, shade)

    art = wallpaper.crop(GREETER_CROP)
    field.paste(art, (0, 0), right_fade(art.size))
    return field


def main() -> int:
    if len(sys.argv) != 4 or sys.argv[1] not in ("splash", "greeter"):
        print(__doc__)
        return 2

    mode, source, target = sys.argv[1], sys.argv[2], sys.argv[3]
    wallpaper = Image.open(source).convert("RGB")
    result = splash(wallpaper) if mode == "splash" else greeter(wallpaper)
    result.save(target, optimize=True)
    print(f"{mode}: wrote {target} {result.size[0]}x{result.size[1]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())