# OmidenOS

OmidenOS is a security-focused Linux distribution built with
`mkarchiso` on a pacman-based base system. It boots only in 64-bit UEFI
mode, runs as a live system, and installs to disk with Calamares.

Status: early development. The Phase 0 discovery reports and the
current architecture state live under `docs/`.

## What exists today

- `archiso/` — UEFI-only live-medium profile (`profiledef.sh`,
  `packages.x86_64`, `pacman.conf`, `efiboot/`, `airootfs/`).
- `scripts/` — repository checks (`lint-style`, `brand-scan`).
- `branding/` — term configuration for the brand scan and the provided
  logo asset (`source/logo.png`).
- `docs/` — phase reports, decision records, backlog.

## Known limitations

- UEFI-only: 64-bit UEFI firmware is required. BIOS/CSM and 32-bit UEFI
  are not supported and no boot files for them are present in the ISO.
- Secure Boot is not supported; the ISO is not signed.
- The live medium still uses the stock upstream kernel and the stock
  live hooks (see `branding/upstream-allowlist.toml` for the interim
  allowlisted parameters); the own kernel and the renamed hook set are
  scheduled for Phase 3.
- The installer (Calamares) is not part of the profile yet.
- Building the ISO requires root; see `docs/dev/building.md`.

## License

See `LICENSE` (BSD 3-Clause) and `docs/adr/0009-licensing.md`.
