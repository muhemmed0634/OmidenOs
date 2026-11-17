# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0007: Bootloader × LUKS × filesystem scope simplification

Status: Accepted (owner decision, 2026-11-17) — supersedes the Phase 0
compatibility-matrix plan below

## Context

The Phase 0 draft offered systemd-boot and GRUB as installer choices,
LUKS2 full-disk encryption as an option, and ext4/btrfs/xfs as
filesystem choices. GRUB cannot unlock LUKS2/Argon2id boot devices, so a
GRUB × LUKS combination would need PBKDF2 keyslots or an unencrypted
`/boot`, multiplying installer states and test effort.

## Decision (owner, 2026-11-17)

- systemd-boot is the only bootloader. GRUB is out of scope for v1.0.
- LUKS full-disk encryption is out of scope for v1.0 (no LUKS option in
  the installer, no LUKS test cells).
- ext4 is the default filesystem. The Calamares choice page presents
  ext4 as the preselected default; btrfs/xfs remain possible later
  (BACKLOG) — nothing in v1.0 depends on them.
- The installer no longer needs bootloader or filesystem choice pages
  for these two dimensions; the summary page still shows the fixed
  values.

## Consequences

- ADR-0006 constraints table drops GRUB and LUKS rows; `docs/uefi.md`
  documents systemd-boot only (ESP at `/boot`, `EFI/omidenos`, fallback
  `EFI/BOOT/BOOTX64.EFI`, NVRAM entry `OmidenOS`).
- The Calamares bootloader module configuration is systemd-boot only.
- Pairwise test matrix shrinks: dimensions are now desktop × toolset ×
  swap × shell; N was revised from 12 to 8 full-install tests.
- If GRUB or LUKS support is ever added, the research below applies.

## Phase 0 research kept for the record (verified 2026-11-17)

1. GRUB supports encrypted `/boot` (`GRUB_ENABLE_CRYPTODISK=y`) but
   "GRUB's support for LUKS2 is limited [...] Use LUKS2 with PBKDF2
   (`cryptsetup luksFormat --pbkdf pbkdf2`) for partitions that GRUB
   will need to unlock." (ArchWiki, Dm-crypt/Device encryption;
   GRUB#Encrypted /boot.)
2. systemd-boot cannot unlock LUKS-encrypted volumes; with systemd-boot
   the ESP (`/boot`) stays unencrypted FAT32 by design, and LUKS would
   cover root and swap only (runtime confirmation was scheduled for
   Phase 6; now moot for v1.0).
3. GRUB warns that new filesystem features can make `/boot` unsuitable
   (ArchWiki, GRUB#Supported file systems).
