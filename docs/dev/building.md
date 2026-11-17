# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# Building the live medium

Requirements: a pacman-based host with `archiso` installed, root access
(`mkarchiso` installs packages into the airootfs and creates device
nodes), and enough disk space for the work directory (several GiB).

Build (from the repository root):

    sudo mkarchiso -v -w build/work -o build/out archiso

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
