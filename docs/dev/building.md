# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# Building the live medium

Requirements: a pacman-based host with `archiso` installed, root access
(`mkarchiso` installs packages into the airootfs and creates device
nodes), and enough disk space for the work directory (several GiB).

Build (from the repository root):

    sudo mkarchiso -v -w build/work -o build/out archiso

Rebuild after a profile change: remove the work directory first.

    sudo rm -rf build/work build/out
    sudo mkarchiso -v -w build/work -o build/out archiso

`mkarchiso` marks every completed step with a file in the work directory
(`base._make_packages`, `base._mkairootfs_squashfs`, `base._build_buildmode_iso`, ...)
and skips any step whose marker exists. Reusing a work directory from a
previous build therefore produces a run that prints the validation lines,
says `Done!`, exits 0 and leaves the old ISO in place. `-r` removes the
work directory at the end of a successful build, which makes the next run
clean at the cost of re-downloading the package cache.

Outputs: `build/out/omidenos-<version>-x86_64.iso` plus the ISO sha256
written by mkarchiso. `build/` is gitignored.

UEFI-only boot test with QEMU + OVMF (no Secure Boot, empty NVRAM):

    qemu-system-x86_64 \
        -machine q35,accel=kvm \
        -m 4G \
        -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
        -drive if=pflash,format=raw,file=/usr/share/edk2/x64/OVMF_VARS.4m.fd \
        -cdrom build/out/omidenos-<version>-x86_64.iso \
        -display none -serial file:build/serial.log

BIOS (SeaBIOS) boot must fail by design: the ISO carries no El Torito
BIOS entry and no MBR boot code. Evidence commands for the "no BIOS
trace" check (xorriso):

    xorriso -indev <iso> -report_el_torito plain
    xorriso -indev <iso> -report_system_area plain

Interim limitations (Phase 2, removed in Phase 3):
- the live media uses the stock `linux` kernel and the stock
  `mkinitcpio-archiso` hooks, so the kernel command line still carries
  the interim parameters listed in branding/upstream-allowlist.toml;
- the forensic-mode menu entry exists but its behavior is only wired to
  the omidenos-initcpio hooks in Phase 3.

## Measuring the live system

Boot cost belongs to a build, so it is measured rather than assumed.
Inside the running live session:

    boot-report

The helper prints `systemd-analyze` totals, the ten slowest units, the
critical chain, memory use, the live root mount and the enabled unit
count. Record one block per build that touches the profile, the
initramfs compression, the package list or the enabled services:

    build: omidenos-YYYY.MM.DD-x86_64.iso, NNN MiB
    boot:  userspace X.XXs, firmware + loader + userspace Y.YYs
    slowest: unit (time), unit (time), ...
    changed: what this build changed

Two knobs have moved boot time so far. The initramfs compression is
`zstd` (airootfs/etc/mkinitcpio.conf.d/archiso.conf): it decompresses
faster than the previous `xz -9e` for a slightly larger archive. The
service set enabled in the airootfs overlay is the other. Squashfs is
still `xz`; it trades boot-read time for image size, and changing it is
its own measurement with the ISO size recorded next to the boot number.
