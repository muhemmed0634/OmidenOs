<div align="center">
  <img src="OmidenOS.png" alt="OmidenOS" width="520">
</div>

<p align="center">
  A pacman-based live system for security work, built with <code>mkarchiso</code>.
  <br>
  UEFI 64-bit only &middot; systemd-boot &middot; ext4 &middot; XFCE &middot; i3 &middot; Hyprland &middot; Calamares
</p>

<p align="center">
  <a href="https://github.com/muhemmed0634/OmidenOs/actions/workflows/lint.yml"><img
    src="https://github.com/muhemmed0634/OmidenOs/actions/workflows/lint.yml/badge.svg"
    alt="lint"></a>
  <img src="https://img.shields.io/badge/phase-2%20complete-brightgreen?style=flat-square"
    alt="phase">
  <img src="https://img.shields.io/badge/boot-UEFI%2064--bit%20only-blue?style=flat-square"
    alt="boot">
  <img src="https://img.shields.io/badge/verified-QEMU%20%2B%20VirtualBox-blue?style=flat-square"
    alt="verified">
  <img src="https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat-square"
    alt="license">
</p>

## What this is

OmidenOS boots from a live medium and runs from a compressed, read-only
squashfs with a writable overlay held in RAM. The profile is UEFI-only
by design: there is no BIOS/CSM boot path, no syslinux, no GRUB, and no
32-bit UEFI support anywhere in the tree. The ISO carries a single El
Torito UEFI boot image and nothing else.

The current medium is a working live system: it builds, it boots on two
independent hypervisors, and it drops you into a zsh session as an
unprivileged user. It does not install to disk yet, so it is the second
of eight phases rather than a release.

Each phase has an exit criterion, and a phase closes only when that
criterion is backed by a recorded check. The evidence for the current
state is in `docs/dev/verification.md`.

## Verified builds

| Check | Result |
| --- | --- |
| Build | `mkarchiso` exits 0, ISO 849 MiB, sha256 recorded |
| Boot menu | four entries, 15 s timeout, default selects the standard session |
| QEMU 10 / KVM / OVMF | all four entries reached the live prompt |
| VirtualBox 7.2 (EFI) | automatic `omiden` login, MOTD, shell prompt |
| BIOS negative test | SeaBIOS ends in `No bootable device`, as designed |
| Repository isolation | image `pacman.conf` carries only `[options]`, `[core]`, `[extra]` |

Build under test: `omidenos-2026.11.17-x86_64.iso`,
sha256 `af63c32e9e5138666fd222b1ca6075746bc4b0ecef6ef2f3127813d7f21997aa`.
Full transcript, including the `xorriso` reports and the screenshots
described: `docs/dev/verification.md`.

## At a glance

| Aspect | v1.0 target | Today |
| --- | --- | --- |
| Base | pacman-based, rolling | live profile builds and boots |
| Boot | UEFI 64-bit only, systemd-boot | 4/4 entries verified |
| Live root | squashfs plus RAM overlay | verified |
| Installed root filesystem | ext4 | scope decision, no installer yet |
| Installer | Calamares | not implemented |
| Sessions | XFCE (default), i3, Hyprland | in the tree, not yet built |
| Tool set | curated security tools | not implemented |
| Disk encryption | none, out of v1.0 scope | not applicable |
| Secure Boot | unsupported, ISO unsigned | decision recorded |
| Kernel | own `linux-omiden` package | stock kernel for now |

## Boot menu

| Entry | Behaviour |
| --- | --- |
| `OmidenOS Live` | default; live session, 15 s timeout |
| `OmidenOS Live (copy to RAM)` | loads the image into RAM, the medium can be detached |
| `OmidenOS Live (safe graphics)` | adds `nomodeset` for hardware that misbehaves with the default stack |
| `OmidenOS Live (forensic mode)` | boots, but the parameter is a placeholder: read-only mounting arrives with the Phase 3 hooks |

## Sessions

One display manager (SDDM), three sessions, one console fallback. The
live medium logs straight into XFCE; the others are one click away.

| Session | Stack | Notes |
| --- | --- | --- |
| XFCE | X11 | default, autologin, the session to fall back to |
| i3 | X11 | tiling, `Mod4` bindings, status bar from `i3status` |
| Hyprland | Wayland | tiling, needs OpenGL; enable 3D acceleration in a VM |
| text console | tty2 | `Ctrl+Alt+F2`, no session, no display manager |

Session defaults are written by the project and stay short: a keybinding
set, a bar, a launcher. No borrowed dotfile collections.

## Phases

| Phase | Content | State |
| --- | --- | --- |
| 0 | Discovery, tool resolution, decision records | done |
| 1 | Repository skeleton, lint chain, brand scan | done, licensing decision open |
| 2 | UEFI-only live medium | done, verified 2026-11-17 |
| 3 | Own hook set, `[omidenos]` repository, own kernel | planned |
| 4 | Tool manifest, meta packages | planned |
| 5 | Desktops (XFCE, i3, Hyprland) and identity | in progress |
| 6 | Calamares configuration, install test matrix | planned |
| 7 | Hardening review, SBOM, release pipeline | planned |

Exit criteria per phase: `docs/dev/phase-0-report.md`. Open items:
`docs/BACKLOG.md`.

## Build the live medium

Requirements: a pacman-based host with `archiso` installed, root access,
and room for the work directory. Notes and version details in
`docs/dev/building.md`.

```
sudo mkarchiso -v -w build/work -o build/out archiso
```

Output: `build/out/omidenos-<version>-x86_64.iso` and the matching
sha256 file. `build/` is gitignored. There is no downloadable ISO yet:
the two existing release tags (`0.1v`, `v1_alpha`) predate this tree and
carry no assets, so a local build is the only way to run it.

## Boot it

QEMU with OVMF, no Secure Boot, fresh NVRAM variables:

```
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd build/OVMF_VARS.fd
qemu-system-x86_64 \
    -machine q35,accel=kvm \
    -m 4G \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
    -drive if=pflash,format=raw,file=build/OVMF_VARS.fd \
    -cdrom build/out/omidenos-<version>-x86_64.iso \
    -serial file:build/serial.log
```

The same ISO works in VirtualBox with EFI enabled (Settings, System,
Motherboard, Enable EFI). Without EFI the firmware finds nothing to boot:
that is the design, not a defect.

To confirm the BIOS path is genuinely absent:

```
xorriso -indev build/out/omidenos-<version>-x86_64.iso -report_el_torito plain
xorriso -indev build/out/omidenos-<version>-x86_64.iso -report_system_area plain
```

Expect one El Torito image on platform `UEFI` and a protective `0xee`
MBR partition with no bootstrap code.

## Checks

```
make lint        # style checks, brand scan, unit tests, optional linters
make brand-scan  # brand scan in strict mode
make tests       # unit tests only
```

`make lint` uses `shellcheck`, `shfmt`, `ruff`, `mypy` and `reuse` when
they are present and names the ones it skipped, so a green local run is
weaker than a green CI run. CI runs the same chain in an `archlinux`
container on every push and pull request; its badge above reflects the
newest run.

## What does not work yet

- No installer. Calamares is not part of the profile, so there is no
  path from the live medium to a disk.
- The graphical stack is in the tree but no ISO has been built with it
  yet, so no session has been verified. Hyprland needs OpenGL: in a
  virtual machine, enable 3D acceleration or the session will not start.
- No tool set. The medium ships a shell, `nano`, `tmux` and the rescue
  basics, not the security tool selection.
- Forensic mode is inert. The entry boots, the parameter is ignored by
  the stock hooks until Phase 3.
- Upstream names still leak into a few surfaces: the stock kernel's
  version suffix in `uname -r`, the initramfs banner, and the live
  kernel parameters. The own kernel and the renamed hooks remove them.
- The live session runs a passwordless sudo user and a root account with
  an empty password. Both exist only on the medium and are never carried
  into an installed system, which does not exist yet.
- Secure Boot is unsupported and the ISO is unsigned.

## Repository layout

| Path | Contents |
| --- | --- |
| `archiso/` | live-medium profile: `profiledef.sh`, `packages.x86_64`, `pacman.conf`, `efiboot/`, `airootfs/` |
| `branding/` | brand-scan term configuration, upstream allowlist, logo source |
| `docs/adr/` | decision records, one per design question |
| `docs/dev/` | phase reports, verification evidence, build notes |
| `scripts/` | `lint-style`, `brand-scan` (Python 3, standard library only) |
| `tests/` | unit tests for the scanners |
| `Makefile` | `lint`, `brand-scan`, `tests` |

The repository enforces its own rules: no work-item markers in tracked
files, no emoji, no marketing vocabulary. Open items belong in
`docs/BACKLOG.md`, not in code comments.

Two mechanisms in the profile are deliberately blunt and documented as
such: `airootfs/root/customize_airootfs.sh` rewrites the identity files
after package installation, because `filesystem` owns those paths, and
`systemd-firstboot` is masked so the live session is not covered by a
setup prompt. Both are recorded in `docs/dev/verification.md`.

## Decisions and planning

- `docs/adr/` holds the reasoning behind the shape of this system:
  kernel packaging, live hooks, identity files, installer, display
  manager, bootloader and encryption scope, brand scan, licensing.
- `docs/ROADMAP.md` holds the phase sequence, the exit criterion of each
  phase, the critical path and the recommended scope cuts.
- `docs/BACKLOG.md` holds everything still open, including the one
  unresolved licensing question.
- The brand scan keeps third-party distribution names off user-visible
  surfaces, which is why this file says "pacman-based" instead of naming
  the upstream.

## Brand assets

<table>
  <tr>
    <td align="center"><img src="OmidenOS.png" alt="OmidenOS crest" width="300"></td>
    <td align="center"><img src="Omiden.png" alt="OMIDEN OS wordmark" width="230"></td>
  </tr>
  <tr>
    <td align="center">Cat crest with crescent and star, current mark</td>
    <td align="center">Wordmark, earlier mark</td>
  </tr>
</table>

Source assets live in `branding/source/`. A vector version of the crest
is still outstanding; until it arrives the raster file is the reference
for derived artwork.

## License

Project code: BSD 3-Clause (`LICENSE`). Brand assets: CC-BY-SA-4.0
(`LICENSES/`, `REUSE.toml`). The choice is documented in
`docs/adr/0009-licensing.md` and is the last open item of Phase 1.
