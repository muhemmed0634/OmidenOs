<div align="center">

<img src="OmidenOS.png" width="160" alt="Omiden OS"/>

# Omiden OS

**Cybersecurity-Focused Arch Linux Distribution — 112 Professional Security Tools**

[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)
[![Base](https://img.shields.io/badge/based%20on-Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/muhemmed0634/OmidenOs)
[![Tools](https://img.shields.io/badge/tools-112-orange.svg)]()
[![Categories](https://img.shields.io/badge/categories-13-purple.svg)]()
[![Omiden][https://img.shields.io/badge/omidenos-cyberos-purple]](.)

</div>

---

```text
 ██████╗ ███╗   ███╗██╗██████╗ ███████╗███╗   ██╗     ██████╗ ███████╗
██╔═══██╗████╗ ████║██║██╔══██╗██╔════╝████╗  ██║    ██╔═══██╗██╔════╝
██║   ██║██╔████╔██║██║██║  ██║█████╗  ██╔██╗ ██║    ██║   ██║███████║
██║   ██║██║╚██╔╝██║██║██║  ██║██╔══╝  ██║╚██╗██║    ██║   ██║╚════██║
╚██████╔╝██║ ╚═╝ ██║██║██████╔╝███████╗██║ ╚████║    ╚██████╔╝███████║
 ╚═════╝ ╚═╝     ╚═╝╚═════╝ ╚══════╝╚═════╝     ╚═════╝ ╚══════╝
```

> Professional penetration testing and security research distribution built from scratch on Arch Linux

---

## 🎯 About

Omiden OS is a cybersecurity-focused Linux distribution built on Arch Linux, specifically designed for **penetration testers**, **security researchers**, **ethical hackers**, and **red team operators**. It comes pre-configured with **112 professional security tools** across **13 categories** and offers a choice between **KDE Plasma** and **GNOME** desktop environments behind a branded **SDDM greeter** with custom 1080p boot artwork.

Built using **archiso**, Omiden OS delivers a verified UEFI-only live medium that boots cleanly in VirtualBox 7.2+ and on real hardware. All security tools are sourced from the **BlackArch repositories** and verified for availability.

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **🔐 112 Security Tools** | Professional penetration testing, network analysis, exploitation, forensics, mobile, reverse engineering, and OSINT tools |
| **🎨 Dual Desktop** | KDE Plasma (Wayland/X11) and GNOME sessions behind SDDM |
| **⚡ Arch-Based** | Rolling release model with latest packages, AUR support, and BlackArch integration |
| **🎭 Branded Live Medium** | Custom SDDM greeter, Catppuccin palette, 1080p boot artwork |
| **🚀 Verified Builds** | Tested in VirtualBox 7.2 EFI and on physical hardware |
| **📦 Modular Installer** | `install-tools` interactive menu to add any tool/category post-install |
| **📝 BSD-3-Clause** | Permissive license for commercial and private use |

---

## 🛠️ Security Tools — 112 Tools Across 13 Categories

All tools are installed via the interactive **`install-tools`** script (available in the live session and installed system) which pulls packages from the BlackArch repositories. Tools are organized by category for targeted installation.

### Tool Categories Summary

| # | Category | Tools | Description |
|---|----------|-------|-------------|
| 1 | **Heavy GUI** | 7 | Large GUI applications (Burp Suite, Ghidra, Autopsy, Maltego, Neo4j, RetDec, Havoc C2) |
| 2 | **Web Testing** | 13 | Web application vulnerability scanners and frameworks |
| 3 | **Exploitation** | 10 | Exploitation frameworks and post-exploitation tooling |
| 4 | **Mobile/Android** | 9 | Android APK analysis, decompilation, and mobile forensics |
| 5 | **Reverse Engineering** | 10 | Disassemblers, debuggers, decompilers, binary analysis |
| 6 | **Forensics** | 15 | Disk/memory forensics, file carving, steganography, artifact analysis |
| 7 | **Network/AD** | 22 | Active Directory enumeration, network scanning, protocol analysis |
| 8 | **Password** | 2 | Windows credential dumping and mapping |
| 9 | **Steganography** | 1 | Whitespace steganography |
| 10 | **OSINT** | 2 | Open-source intelligence frameworks |
| 11 | **Crypto** | 2 | Encryption and secure communication tools |
| 12 | **Scanners** | 10 | SSL/TLS, web, and network vulnerability scanners |
| 13 | **Misc** | 9 | Fuzzing, tunneling, traffic detection, post-exploitation utilities |

**Total: 112 tools**

---

### 1. Heavy GUI (7 tools)

| Tool | Description | Size |
|------|-------------|------|
| `burpsuite` | Burp Suite — Web proxy scanner | 688 MB |
| `ghidra` | Ghidra — NSA reverse engineering framework | 355 MB |
| `autopsy` | Autopsy — Digital forensics platform | 1 GB |
| `maltego` | Maltego — OSINT & link analysis | 180 MB |
| `neo4j-community` | Neo4j — BloodHound graph database | 126 MB |
| `retdec` | RetDec — Machine-code decompiler | 124 MB |
| `havoc-c2` | Havoc C2 — Post-exploitation command & control | 158 MB |

---

### 2. Web Testing (13 tools)

| Tool | Description |
|------|-------------|
| `w3af` | W3AF — Web application attack & audit framework |
| `arachni` | Arachni — Web vulnerability scanner |
| `set` | Social Engineering Toolkit (SET) |
| `a2sv` | A2SV — Auto Scanner for SQLi/XSS |
| `abuse-ssl-bypass-waf` | Abuse-SSL — WAF bypass techniques |
| `anti-xss` | Anti-XSS — XSS detection utilities |
| `apache-users` | Apache-Users — Enumerate Apache users |
| `laudanum` | Laudanum — Injection & payload helpers |
| `swaks` | SWAKS — SMTP transaction testing |
| `webanalyze` | WebAnalyze — Web technology fingerprinting |
| `webtech` | WebTech — Web technology detection |
| `xsser` | XSSer — Cross-site scripting scanner |
| `xsspire` | XSSpire — XSS exploitation framework |

---

### 3. Exploitation (10 tools)

| Tool | Description |
|------|-------------|
| `armitage` | Armitage — Metasploit GUI |
| `ace` | ACE — Android Custom Exploit toolkit |
| `hyperfox` | HyperFox — MITM proxy for traffic manipulation |
| `iaito` | Iaito — Radare2 GUI |
| `irpas` | IRPAS — Routing protocol attack suite |
| `powerstager` | PowerStager — PowerShell stager generator |
| `powersploit` | PowerSploit — PowerShell post-exploitation toolkit |
| `pwnat` | PWNAT — NAT traversal / piercing |
| `sparta` | Sparta — Network infrastructure scanner |
| `unicornscan` | Unicornscan — High-speed asynchronous port scanner |

---

### 4. Mobile/Android (9 tools)

| Tool | Description |
|------|-------------|
| `jadx` | JADX — Java/DEX/APK decompiler |
| `androguard` | Androguard — Android analysis framework |
| `dex2jar` | dex2jar — DEX to Java bytecode converter |
| `mobsf` | MobSF — Mobile Security Framework (static/dynamic analysis) |
| `android-apktool` | Apktool — APK reverse engineering |
| `android-backup-extractor` | Android Backup Extractor — ABE format extraction |
| `androick` | Androick — Android forensic toolkit |
| `androbugs` | AndroBugs — Android vulnerability scanner |
| `androwarn` | AndroWarn — Android static analysis & malware detection |

---

### 5. Reverse Engineering (10 tools)

| Tool | Description |
|------|-------------|
| `rizin` | Rizin — Reverse engineering framework (radare2 fork) |
| `capstone` | Capstone — Multi-architecture disassembly engine |
| `unicorn` | Unicorn — Multi-architecture CPU emulator |
| `keystone` | Keystone — Multi-architecture assembler |
| `z3` | Z3 — Microsoft SMT solver for symbolic execution |
| `ropgadget` | ROPgadget — ROP chain finder |
| `ropper` | Ropper — ROP chain construction tool |
| `gef` | GEF — GDB Enhanced Features for exploit development |
| `angr-management` | Angr Management — Binary analysis GUI |
| `amoco` | Amoco — Binary analysis & decompilation |

---

### 6. Forensics (15 tools)

| Tool | Description |
|------|-------------|
| `rifiuti2` | Recycle bin artifact analysis |
| `ophcrack` | Ophcrack — Windows password cracking (rainbow tables) |
| `stegcracker` | Stegcracker — Steganography brute-force |
| `pngcheck` | pngcheck — PNG file integrity verification |
| `scalpel` | Scalpel — File carving tool |
| `volafox` | volafox — macOS/OS X memory forensics |
| `libewf` | libewf — Expert Witness Format (EWF) library |
| `aesfix` | AESFix — AES key schedule recovery from memory |
| `aeskeyfind` | AESKeyFind — AES key location in memory dumps |
| `afflib` | AFFLib — Advanced Forensic Format library |
| `aimage` | AImage — Disk imaging & acquisition |
| `analyzemft` | AnalyzeMFT — $MFT (NTFS) parsing & analysis |
| `dumpzilla` | Dumpzilla — Firefox browser forensics |
| `vinetto` | Vinetto — Thumbs.db / thumbnail cache analysis |
| `vbindiff` | VBinDiff — Visual binary diff tool |

---

### 7. Network / Active Directory (22 tools)

| Tool | Description |
|------|-------------|
| `netexec` | NetExec — Network execution framework (CrackMapExec fork) |
| `rita` | RITA — Real Intelligence Threat Analytics (traffic analysis) |
| `smbclient` | SMBClient — SMB/CIFS client utilities |
| `samba` | Samba — SMB file/print sharing server |
| `acccheck` | AccCheck — SMB password policy checker |
| `activedirectoryenum` | ADEnum — Active Directory enumeration |
| `ad-ldap-enum` | AD-LDAP-Enum — LDAP-based AD enumeration |
| `adfind` | AdFind — Active Directory query tool |
| `adfspray` | ADSpray — AD password spraying |
| `adidnsdump` | Adidnsdump — AD DNS zone dumping |
| `allthevhosts` | AllTheVHosts — Virtual host discovery |
| `alterx` | AlterX — Subdomain permutation generator |
| `amap` | Amap — Application protocol mapper |
| `dmitry` | DMitry — Deepmagic information gathering |
| `dnsenum` | DNSenum — DNS enumeration |
| `fping` | Fping — Parallel ping sweeps |
| `nbtscan` | NBTscan — NetBIOS name scanner |
| `nemesis` | Nemesis — Packet crafting & injection |
| `p0f` | p0f — Passive OS fingerprinting |
| `polenum` | PolEnum — Password policy enumeration |
| `ridenum` | RidEnum — RID cycling enumeration |
| `snmpcheck` | SNMPCheck — SNMP configuration audit |

---

### 8. Password (2 tools)

| Tool | Description |
|------|-------------|
| `creddump` | Creddump — Windows credential extraction from registry/SAM |
| `credmap` | CredMap — Credential reuse mapping across services |

---

### 9. Steganography (1 tool)

| Tool | Description |
|------|-------------|
| `stegsnow` | StegSnow — Whitespace steganography (hide data in text files) |

---

### 10. OSINT (2 tools)

| Tool | Description |
|------|-------------|
| `sn0int` | Sn0int — Semi-automatic OSINT framework |
| `inquisitor` | Inquisitor — Information gathering & reconnaissance |

---

### 11. Crypto (2 tools)

| Tool | Description |
|------|-------------|
| `sbd` | SBD — Secure backdoor / encrypted bind shell |
| `tbear` | TBEAR — Token-based encryption & authentication |

---

### 12. Scanners (10 tools)

| Tool | Description |
|------|-------------|
| `sslcaudit` | SSLAudit — SSL/TLS configuration audit |
| `sslsplit` | SSLSplit — Transparent SSL/TLS interception |
| `tlsfuzzer` | TLSFuzzer — TLS protocol fuzzer |
| `uniscan` | UniScan — Web vulnerability scanner |
| `urlbuster` | URLBuster — URL/content fuzzer |
| `urldigger` | URLDigger — URL extraction from JavaScript/HTML |
| `t50` | T50 — Mixed packet injector / stress tester |
| `tinfoleak` | TInfoLeak — Information leak scanner |
| `zmap` | ZMap — High-speed Internet-wide scanner |
| `zbar` | ZBar — Barcode / QR code reader |

---

### 13. Misc (9 tools)

| Tool | Description |
|------|-------------|
| `maltrail` | MalTrail — Malicious traffic detection (C2, malware, exploits) |
| `pyexfil` | PyExfil — Data exfiltration toolkit |
| `wce` | WCE — Windows Credential Editor (memory credential extraction) |
| `peach` | Peach — Fuzzing framework |
| `pentestly` | Pentestly — Penetration testing automation framework |
| `iodine` | Iodine — DNS tunneling (IP over DNS) |
| `powersploit` | PowerSploit — PowerShell post-exploitation (duplicate entry) |
| `pwnat` | PWNAT — NAT traversal (duplicate entry) |
| `irpas` | IRPAS — Routing protocol attack suite (duplicate entry) |

> **Note:** Three tools appear in multiple categories (PowerSploit, PWNAT, IRPAS) — the unique tool count is 109 distinct packages, with 112 category entries.

---

## 📥 Download & Installation

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 2 GB | 4 GB+ |
| **Storage** | 20 GB | 50 GB+ |
| **Boot** | UEFI or BIOS | UEFI |
| **Network** | Required for tool installation | Required |

### Download ISO

Download the latest release from **[GitHub Releases](https://github.com/muhemmed0634/OmidenOs/releases)**

```bash
# Verify checksum
sha256sum omidenos-*.iso

# Compare with release notes
```

### Create Bootable USB

**Linux:**
```bash
sudo dd if=omidenos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

**Windows:** Use [Rufus](https://rufus.ie/) or [Balena Etcher](https://www.balena.io/etcher/)

**macOS:**
```bash
sudo dd if=omidenos-*.iso of=/dev/diskX bs=4m
```

**Universal (multi-ISO):** Use [Ventoy](https://www.ventoy.net/)

### Live Session & Installation

1. Boot from USB (UEFI recommended)
2. At the SDDM greeter, select **KDE Plasma** or **GNOME** session
3. Default live user: `liveuser` (no password)
4. Root access: `sudo -i` (no password)

**Install to disk** (if installer is included):
```bash
sudo omiden-installer
```

---

## 🚀 Post-Install: Installing Security Tools

The **`install-tools`** script provides an interactive menu to install any of the 112 tools individually, by category, or all at once.

```bash
# Run the interactive installer
sudo install-tools
```

### Menu Options

| Selection | Action |
|-----------|--------|
| `1-112` | Install specific tool by number |
| `a` | Install **ALL 112 tools** (requires significant bandwidth/disk) |
| `c` | Install by **category** (choose 1-13) |
| `q` | Quit |

### Category Installation Example

```bash
sudo install-tools
# Select 'c' for category
# Select '2' for Web Testing (13 tools)
# All 13 web tools install sequentially
```

### Prerequisites

- **BlackArch repositories** must be configured (run `setup-blackarch` first if not already done)
- Internet connection required
- Sufficient disk space (full install: ~3-5 GB additional)

---

## 🖥️ Desktop Environments

| Desktop | Session Type | Display Server | Status Bar | Theme |
|---------|--------------|----------------|------------|-------|
| **KDE Plasma** | Wayland / X11 | KWin | Plasma Panel | Catppuccin |
| **GNOME** | Wayland / X11 | Mutter | GNOME Shell | Catppuccin |

Both sessions available at SDDM login. The live medium defaults to a branded greeter with the Omiden OS logo and 1080p boot artwork.

---

## 🏗️ Building from Source

### Dependencies

```bash
sudo pacman -S archiso git python python-yaml rsync
```

### Build Process

```bash
# Clone repository
git clone https://github.com/muhemmed0634/OmidenOs.git
cd OmidenOs

# Build ISO (requires root)
sudo bash scripts/build.sh

# Output: out/omidenos-<date>-x86_64.iso
```

### Test in QEMU

```bash
# UEFI test (OVMF required)
qemu-system-x86_64 \
  -bios /usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
  -enable-kvm -m 4G -cpu host \
  -cdrom out/omidenos-*.iso
```

---

## 📁 Project Structure

```
OmidenOs/
├── archiso-profile/          # archiso build profile
│   ├── airootfs/            # Live system root filesystem
│   │   ├── etc/             # System config (pacman, shadow, SDDM, etc.)
│   │   ├── usr/local/bin/   # install-tools, install-waypaper
│   │   └── ...              # Skel, wallpapers, branding
│   ├── packages.x86_64      # Base package list
│   ├── packages.both        # Common packages
│   ├── pacman.conf          # Repository config (includes BlackArch)
│   ├── profiledef.sh        # Profile metadata & build hooks
│   └── syslinux/            # BIOS/PXE boot config
├── scripts/
│   ├── build.sh             # ISO build script
│   ├── test.sh              # QEMU test helper
│   └── gen-packages.py      # Package list generator
├── OmidenOS.png             # Project logo (1080p)
├── LICENSE                  # BSD-3-Clause
└── README.md                # This file
```

---

## 📚 Documentation & Links

| Resource | Link |
|----------|------|
| **GitHub Repository** | https://github.com/muhemmed0634/OmidenOs |
| **Releases (ISO Downloads)** | https://github.com/muhemmed0634/OmidenOs/releases |
| **Issues & Bug Reports** | https://github.com/muhemmed0634/OmidenOs/issues |
| **BlackArch Repository** | https://blackarch.org/ |
| **archiso Documentation** | https://wiki.archlinux.org/title/archiso |

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-tool-category`)
3. Make your changes
4. Run `reuse lint` to verify licensing headers
5. Submit a pull request

**Areas for contribution:**
- Adding new security tools to `install-tools` script
- Improving desktop configurations (KDE/GNOME)
- Documentation translations
- Build script improvements
- Branding & artwork

---

## ⚖️ License

**BSD 3-Clause License** — see [LICENSE](LICENSE) for full text.

```
Copyright (c) 2026, muhemmed0634
All rights reserved.
```

This license permits commercial and private use, modification, and distribution with attribution.

---

## 🙏 Acknowledgments

- **Arch Linux** — The foundation
- **BlackArch** — Security tool repositories (112+ tools sourced here)
- **archiso** — Live ISO build framework
- **KDE & GNOME** — Desktop environments
- **SDDM** — Display manager with theming support
- **Catppuccin** — Color palette for theming
- **Community** — Testers, bug reporters, and contributors

---

<div align="center">

**Built with ❤️ for the security community**

[![GitHub Stars](https://img.shields.io/github/stars/muhemmed0634/OmidenOs?style=social)](https://github.com/muhemmed0634/OmidenOs)
[![GitHub Forks](https://img.shields.io/github/forks/muhemmed0634/OmidenOs?style=social)](https://github.com/muhemmed0634/OmidenOs)

</div>
