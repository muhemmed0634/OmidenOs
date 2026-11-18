# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# Live-medium verification evidence (Phase 2)

Date: 2026-11-17. ISO: `omidenos-2026.11.17-x86_64.iso` (849 MiB).
SHA256: `af63c32e9e5138666fd222b1ca6075746bc4b0ecef6ef2f3127813d7f21997aa`.
Build: `sudo mkarchiso -v -w build/work -o build/out archiso` (exit 0).

## No BIOS boot path

`xorriso -indev build/out/omidenos-2026.11.17-x86_64.iso -report_el_torito plain`:

    El Torito catalog  : 90  1
    El Torito cat path : /EFI/boot.cat
    El Torito boot img :   1  UEFI  y   none  0x0000  0x00      0      402681
    El Torito img blks :   1  31744

One boot image, platform **`UEFI`**; no `x86bios`/"PC" entry and no
floppy/hard-disk emulation entry.

`xorriso -indev <iso> -report_system_area plain` (excerpt):

    System area options: 0x00000201
    System area summary: MBR protective-msdos-label cyl-align-off GPT
    MBR partition      :   1   0x00  0xee            1      1738363
    GPT partition name :   2  Appended2
    GPT type GUID      :   2  28732ac11ff8d211ba4b00a0c93ec93b

The only MBR partition is the protective `0xee` GPT marker; there is no
BIOS bootstrap code. The EFI System Partition is present in the GPT.

## UEFI boot (QEMU 10 / KVM / OVMF, 4 GiB, no Secure Boot)

Command (see `docs/dev/building.md`) with a fresh OVMF_VARS copy.
The serial firmware log shows systemd-boot offering exactly these
entries, then auto-selecting the default after its 15 s timeout:

    OmidenOS Live
    OmidenOS Live (copy to RAM)
    OmidenOS Live (safe graphics)
    OmidenOS Live (forensic mode)
    Reboot Into Firmware Interface

## VirtualBox 7.2.22 (headless) verification

A separate VM (`omidenos-verify`, registered under
`/tmp/opencode/vbox/`) was created with **EFI enabled**, ICH9 chipset,
4 GiB RAM, VMSVGA, Intel AHCI DVD controller holding the ISO. The
existing `omiden-os-arch` VM was left untouched.

- Menu screenshot after ~14 s: all four OmidenOS entries and
  `Reboot Into Firmware Interface`, with the 15 s countdown.
- Live screenshot after ~80 s: automatic `omiden` login, Turkish MOTD,
  `omiden@omidenos ~ $` prompt — same result as QEMU/OVMF.
- The VM is left powered off; start it with
  `VBoxManage startvm omidenos-verify` (add `--type headless` for
  headless use). VirtualBox must be set to **EFI** (System →
  Motherboard → Enable EFI) because the ISO has no BIOS boot path;
  Secure Boot is not supported by this ISO in any case.

## Defects found and fixed during verification

1. First boot showed an upstream-branded interactive setup prompt
   (`Initial Setup` / timezone question) on tty1 instead of the live
   session. Cause: mkarchiso writes `uninitialized` to `/etc/machine-id`
   after the customize step, which makes `ConditionFirstBoot=yes`.
   Fix: mask `systemd-firstboot.service` in the airootfs overlay.
2. `/usr/lib/os-release` (rendered by `/etc/issue`, `hostnamectl`, etc.)
   carried the upstream distribution name and URLs. Fix: the
   post-package `customize_airootfs.sh` writes an OmidenOS identity file;
   it cannot be placed in the airootfs overlay because `filesystem`
   owns that path and pacman rejects the pre-existing file.

Both fixes were re-verified by rebuilding the ISO and booting it again.
The final live screen shows `OmidenOS 7.3.4-arch1-2 (tty1)`,
`omidenos login: omiden (automatic login)`, the Turkish MOTD and the
`omiden@omidenos ~ $` prompt. The kernel release suffix (`-arch1-2`) is
the stock upstream kernel version and disappears in Phase 3 with
`linux-omiden` (ADR-0002).

## All four entries booted

Each entry was selected from the menu by keyboard and reached the live
prompt after ~75 s (fresh OVMF variables per run):

| Entry | Result |
| --- | --- |
| `OmidenOS Live` (default) | live prompt reached |
| `OmidenOS Live (copy to RAM)` | live prompt reached |
| `OmidenOS Live (safe graphics)` | live prompt reached |
| `OmidenOS Live (forensic mode)` | live prompt reached; parameter is still a placeholder (Phase 3 activates it) |

## BIOS negative test

The same ISO booted without OVMF (SeaBIOS) does not boot: the firmware
reports `Boot failed: Could not read from CDROM (code 0009)`, iPXE finds
no network device, and ends with **`No bootable device.`**

## Repository isolation (S1)

`grep '^\[' <work>/x86_64/airootfs/etc/pacman.conf` returns only
`[options]`, `[core]`, `[extra]`; `/etc/pacman.d/` contains only the
upstream `mirrorlist`. No build-host repository (cachyos, blackarch,
chaotic, ...) is present in the image.
## Phase 5 theme layout review (not boot evidence)

Date: 2026-11-18. No ISO has been built with the desktop layer, so this
section records what was checked without one and nothing more. It does not
close Phase 5.

Checks run on the build host:

    /usr/lib/qt6/bin/qmllint archiso/airootfs/usr/share/sddm/themes/omidenos/Main.qml
    python3 scripts/compose-artwork.py greeter \
        archiso/airootfs/usr/share/backgrounds/omidenos/wallpaper.png \
        archiso/airootfs/usr/share/backgrounds/omidenos/greeter.png
    python3 scripts/compose-artwork.py splash \
        archiso/airootfs/usr/share/backgrounds/omidenos/wallpaper.png \
        archiso/airootfs/usr/share/plymouth/themes/omidenos/splash.png
    QT_QPA_PLATFORM=offscreen qmlscene scripts/preview-greeter.qml

Results:

- `qmllint` reports no syntax or type error, only `unqualified access`
  warnings for the five context objects SDDM injects (`config`, `sddm`,
  `userModel`, `sessionModel`, `keyboard`), which do not exist outside the
  greeter.
- `greeter.png` and `splash.png` regenerate from the wallpaper at 1920x1080;
  the splash keeps the artwork filling the frame with all four edges faded to
  black.
- `build/greeter-preview.png` (1920x1080, untracked) shows the crest in the
  left two thirds, the clock at the top left, and the login card on the right
  third with the project icon, the title, username and password fields, the
  Sign in button and the Reboot / Power off links.

Not covered by these checks: SDDM's real context objects, the autologin skip
that keeps the card off screen on the live medium, font metrics and scaling
under Xorg, and Plymouth drawing the splash. All of those need the built
medium and belong to the first Phase 5 build, not to this section.

## Phase 5 first build (2026-11-18)

ISO: `omidenos-2026.11.18-x86_64.iso` (1.18 GiB, built 13:34 with the XFCE,
Plymouth and greeter layer in the tree). Booted in VirtualBox 7.2, EFI
firmware, 6 GiB RAM, 4 vCPU, VMSVGA, headless with
`controlvm screenshotpng` as the witness.

Works:

- systemd-boot menu, then the project splash: the crest, the wordmark and the
  three pulsing accent dots are on screen on the quiet entry
  (frames captured at ~30 s and ~50 s differ only in dot opacity, which is
  the animation working).
- SDDM autologin into XFCE: panel with the `OmidenOS` whisker button and the
  project icon, the dark panel colour from ADR-0012, clock, network and
  mixer plugins, desktop icons, and the session's own logout dialog with
  Log Out / Restart / Shut Down.

Defects found on the first boot:

1. The desktop did not get the project wallpaper: xfdesktop paints its own
   default image (the stock mouse artwork). Cause: the per-monitor backdrop
   property does not exist until xfdesktop creates it, which happens after
   the `omidenos-session` autostart entry has run, so the script wrote a
   path nothing reads. Fix: the script now re-applies to every backdrop path
   for up to 10 s, stops once a non-`monitor0` backdrop appears, then runs
   `xfdesktop --reload` and applies once more.
2. Logging out left tty1 black: no greeter card was painted, and
   Ctrl+Alt+F2 did not bring the console back (the VT stayed in graphics
   mode). Not diagnosed yet: the greeter theme passes `qmllint` and renders
   in a bare QML host, `sddm-greeter-qt6`, the `SddmComponents` module, the
   `sddm` user, `/var/lib/sddm` and the modesetting driver are all present
   in the assembled root, so the failure is either the theme under the real
   greeter or X restarting. The next build is checked from tty2, which stays
   usable while the greeter is up, and `DisplayServer=x11` is now pinned in
   `etc/sddm.conf.d/theme.conf` so a Wayland attempt cannot be the cause.

Screenshot files are not committed: they live in the agent workspace
(`~/.hermes/cache/scratch/omiden/`). Nothing else in this section is
evidence for a closed phase; Phase 5 remains open.

## Wallpaper root cause (2026-11-18, live session of the first build)

The first build's desktop kept xfdesktop's stock image. The cause was found
in the running live session, not guessed:

    DBG[xfdesktop-backdrop-renderer.c:644] xfdesktop_backdrop_renderer(): loading image /usr/share/backgrounds/xfce/xfce-x.svg

xfdesktop ignored `/backdrop/screen0/monitor0/workspace0/last-image` (which
held the project wallpaper, readable, correct type) and painted its own
default. In `xfdesktop-backdrop-manager.c` the property prefix is built as

    /backdrop/screen%d/monitor%s/workspace%d

with `%s` from `monitor_get_identifier()`, which returns
`xfw_monitor_get_connector()` - the connector name (`Virtual-1`, `eDP-1`,
`HDMI-A-1`), never `monitor0`. Older builds did read `monitor0`, which is why
the overlay files were written that way.

Fix in `usr/local/bin/omidenos-session`: read the connected connectors from
`/sys/class/drm/*/status`, write `last-image`, `image-path` and `image-style`
for `/backdrop/screen0/monitor<connector>/workspace0..3`, keep `monitor0` as
the last-resort fallback for older builds, then `xfdesktop --reload`. The
lookup is covered by `tests/test_session_monitors.py` (fixture DRM tree,
connected/disconnected/unknown, empty root, shebang check) and the script is
clean under `shellcheck` and `shfmt -d`.

This is a static and unit-level check only; the visual result needs a boot of
a rebuilt medium.

## Phase 5 second build (2026-11-18, 16:43) - all three checks pass

ISO: `omidenos-2026.11.18-x86_64.iso` (1.18 GiB). Booted in VirtualBox 7.2 with
EFI firmware, 6 GiB RAM, 4 vCPU, VMSVGA, headless; `controlvm screenshotpng`
is the witness for every line below.

Assembled root, before booting:

- `usr/bin/sddm-greeter` is a symlink to `sddm-greeter-qt6`.
- `usr/local/bin/omidenos-session` carries the `/sys/class/drm` connector
  lookup described in the section above.

1. Boot splash. The crest, the "OmidenOS" wordmark and the three accent dots
   are on screen during boot, dots pulsing (two frames captured at different
   times differ only in dot opacity). The 1920x1080 artwork is scaled down on
   this 1280x800 VM, which is the intended behaviour of the Plymouth script.
2. Desktop wallpaper. The session comes up with the project wallpaper -
   crest and wordmark across the whole screen, dark violet panel with the
   whisker button, clock and desktop icons. The stock xfdesktop image is gone,
   which is what the connector-key fix was for.
3. Greeter. `Ctrl+Alt+Del` then Log Out leaves the session and SDDM paints
   the theme: crest and wordmark on the left, time and date at the top left,
   and the card on the right with the project icon, "OmidenOS", the username
   field pre-filled `omiden`, an empty password field, the "Sign in" button
   and the Reboot / Power off links. No black screen, no Qt error.

That closes the two defects recorded for the first build (stock wallpaper,
black tty1 after logout) and the boot-splash item from ADR-0011.

Screenshots are not committed: they live in the agent workspace
(`~/.hermes/cache/scratch/omiden/v2-splash2.png`, `v2-late.png`,
`v2-greeter2.png`). Reproducing them needs only a boot of the ISO above.

## Phase 5 third build (2026-11-18, 17:13) - desktop polish

ISO: `omidenos-2026.11.18-x86_64.iso`, 1.22 GiB (40 MiB larger than the
identity build: `papirus-icon-theme` and `materia-gtk-theme`). Booted the same
way as the runs above.

Checks that passed:

- Panel: whisker menu with the project logo left, the docklike taskbar with
  its accent indicator next to it, notification area, mixer and clock on the
  right. No plugin-loading dialog - the 17:04 build had one, because the
  clipman plugin registers as `xfce4-clipman-plugin`, not `clipman`; the id is
  fixed and `tests/test_xfconf_channels.py` now fails if a configured plugin id
  has no metadata file in the image.
- Widgets and window decorations: `Materia-dark` (GTK menus and the titlebar of
  an opened terminal), icons `Papirus-Dark` on the desktop and in the menu.
- Desktop: wallpaper crest and only the trash and removable-media icons.
- Shortcuts: `Ctrl+Alt+T` opened a terminal, which proves the
  `xfce4-keyboard-shortcuts` channel is applied.

Open on this build:

- `<Super>space` did not open the whisker menu in the VM, while the same file's
  `Ctrl+Alt+T` binding worked, so the accelerator itself is consumed by the
  session rather than the file being ignored. An `<Alt>F1` binding is the safe
  fallback and is queued in `docs/BACKLOG.md`.
- The panel was left without a session-menu screenshot; the plugin is the
  stock `actions` plugin, which needs no configuration to be correct.
