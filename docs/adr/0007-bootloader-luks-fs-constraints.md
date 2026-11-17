# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# ADR-0007: Bootloader × LUKS × filesystem compatibility constraints

Status: Draft (Phase 0) — constraints verified against ArchWiki; runtime
tests scheduled for Phase 6

## Context

Section 5 offers systemd-boot (default) and GRUB, both UEFI-only, plus
ext4/btrfs/xfs and optional LUKS2 full-disk encryption. Not every
combination can work; unsupported combinations must be prevented in the
UI or warned about.

## Researched constraints (sources)

1. GRUB supports encrypted `/boot` (`GRUB_ENABLE_CRYPTODISK=y`), but
   "GRUB's support for LUKS2 is limited [...] Use LUKS2 with PBKDF2
   (`cryptsetup luksFormat --pbkdf pbkdf2`) for partitions that GRUB
   will need to unlock." (ArchWiki, Dm-crypt/Device encryption, warning
   box; GRUB page, Encrypted /boot section.)
   Consequence: GRUB + LUKS2 requires either a PBKDF2 keyslot for the
   boot device or an unencrypted `/boot` partition. With Argon2id
   (cryptsetup default since 2.4.0) GRUB cannot unlock the boot device.
2. systemd-boot cannot unlock LUKS-encrypted volumes and has no
   passphrase entry. Consequence: with systemd-boot, `/boot` is the ESP
   (unencrypted, FAT32) by design; LUKS2 covers root and swap only.
   (Source: systemd-boot upstream documentation; runtime confirmation
   pending in Phase 6.)
3. GRUB bundles its own filesystem drivers, but "File systems can get
   new features not yet supported by GRUB, making them unsuitable for
   /boot unless disabling incompatible features." (ArchWiki, GRUB page,
   Supported file systems warning.) Consequence: whatever the chosen
   filesystem, `/boot` for GRUB is created on a separately created
   partition using conservative filesystem options, or the ESP layout
   is used.
4. btrfs + systemd-boot: supported; subvolume layout is applied by the
   Calamares partition module's built-in btrfs presets.
5. ext4 with `metadata_csum_seed`/`large_folio` type features can break
   older GRUB builds; runtime check in Phase 6 decides whether ext4
   `/boot` under GRUB needs explicit `mkfs` option constraints
   (cryptsetup/mkfs defaults recorded at test time, not assumed).

## Resulting UI constraints (to be enforced in Phase 6)

| bootloader | LUKS2 full disk | filesystems |
| --- | --- | --- |
| systemd-boot | allowed (root+swap encrypted; ESP unencrypted) | ext4, btrfs, xfs |
| GRUB | allowed only with PBKDF2 keyslot or separate unencrypted /boot | ext4, btrfs, xfs (runtime test pending) |

Combinations that fail a Phase 6 runtime test are removed from the
choice matrix or shown with a hard warning before install, per section 5.

## Alternatives

- Restrict v1 to systemd-boot only: rejected; GRUB is required as a
  user choice, and the constraint is manageable.
- LUKS1 boot partition for GRUB: rejected; degrades the crypto design,
  LUKS2+PBKDF2 achieves the same compatibility.

## Consequences

- The pairwise test matrix (Phase 6) includes at least:
  systemd-boot × ext4, systemd-boot × LUKS2 × ext4, GRUB × ext4,
  GRUB × LUKS2 × ext4 (PBKDF2 boot), GRUB × btrfs, systemd-boot × btrfs,
  systemd-boot × xfs, GRUB × LUKS2 with Argon2id (expected failure,
  documents the UI warning path).
