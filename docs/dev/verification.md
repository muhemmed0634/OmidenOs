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