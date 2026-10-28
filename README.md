<div align="center">

<img src="Omiden.png" width="180" alt="OmidenOs"/>

# OmidenOs

**Arch Linux + BlackArch tabanlı güvenlik ve günlük kullanım dağıtımı**

[![Stars](https://img.shields.io/github/stars/muhemmed0634/OmidenOs?style=flat-square&color=e94560)](https://github.com/muhemmed0634/OmidenOs/stargazers)
[![Forks](https://img.shields.io/github/forks/muhemmed0634/OmidenOs?style=flat-square&color=89b4fa)](https://github.com/muhemmed0634/OmidenOs/network)
[![License](https://img.shields.io/badge/license-GPL--3.0-a6e3a1?style=flat-square)](LICENSE)
[![Arch](https://img.shields.io/badge/base-Arch%20Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![BlackArch](https://img.shields.io/badge/tools-BlackArch-cc0000?style=flat-square)](https://blackarch.org)

</div>

---

```
  ██████╗ ███╗   ███╗██╗██████╗ ███████╗███╗   ██╗  ██████╗ ███████╗
 ██╔═══██╗████╗ ████║██║██╔══██╗██╔════╝████╗  ██║ ██╔═══██╗██╔════╝
 ██║   ██║██╔████╔██║██║██║  ██║█████╗  ██╔██╗ ██║ ██║   ██║███████╗
 ██║   ██║██║╚██╔╝██║██║██║  ██║██╔══╝  ██║╚██╗██║ ██║   ██║╚════██║
 ╚██████╔╝██║ ╚═╝ ██║██║██████╔╝███████╗██║ ╚████║ ╚██████╔╝███████║
  ╚═════╝ ╚═╝     ╚═╝╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝  ╚═════╝ ╚══════╝
```

---

## Hakkında

OmidenOs, [ArchISO](https://wiki.archlinux.org/title/Archiso) kullanılarak sıfırdan inşa edilmiş özel bir Linux dağıtımıdır. Arch Linux'un rolling-release modelini ve BlackArch'ın 100+ güvenlik aracını bir araya getiren, hem günlük kullanım hem de güvenlik araştırmaları için tasarlanmış minimalist bir sistemdir.

- **Live ortam** olarak USB'den çalıştırılabilir
- **Diske kurulabilir** — `archinstall` yerine özel bir kurulum sihirbazı
- **Openbox** pencere yöneticisi, hafif ve hızlı
- **Fastfetch** ile ASCII logolu sistem bilgisi ekranı

---

## Özellikler

| | |
|---|---|
| **Base** | Arch Linux (rolling release) |
| **Güvenlik** | BlackArch repo + 100+ araç |
| **Masaüstü** | Openbox + Tint2 + Rofi |
| **Terminal** | Alacritty |
| **Shell** | Zsh (autosuggestions, syntax-hl) |
| **Tema** | Arc-Dark + Papirus-Dark |
| **Klavye** | US (English) |
| **Ses** | PipeWire |
| **Ağ** | NetworkManager + iwd |
| **Boot** | BIOS + UEFI |

---

## Güvenlik Araçları

<details>
<summary><b>Reconnaissance</b></summary>

`nmap` · `masscan` · `amass` · `subfinder` · `httpx` · `dnsx` · `ffuf` · `gobuster` · `nikto` · `nuclei` · `whatweb` · `wafw00f` · `theharvester` · `recon-ng` · `shodan` · `dnsrecon`

</details>

<details>
<summary><b>Web Application Testing</b></summary>

`sqlmap` · `burpsuite` · `zaproxy` · `xsstrike` · `dalfox` · `commix` · `wfuzz` · `arjun` · `jwt-tool` · `ssrfmap` · `ghauri`

</details>

<details>
<summary><b>Network & Traffic</b></summary>

`wireshark` · `bettercap` · `ettercap` · `responder` · `mitmproxy` · `tcpdump` · `scapy` · `hping3` · `yersinia` · `sslstrip` · `macchanger`

</details>

<details>
<summary><b>Password Attacks</b></summary>

`hashcat` · `john` · `hydra` · `medusa` · `kerbrute` · `mimikatz` · `pypykatz` · `certipy` · `evil-winrm`

</details>

<details>
<summary><b>Exploitation</b></summary>

`metasploit` · `searchsploit` · `exploitdb` · `routersploit` · `beef-xss` · `empire` · `sliver` · `havoc`

</details>

<details>
<summary><b>Post Exploitation</b></summary>

`bloodhound` · `crackmapexec` · `smbmap` · `enum4linux` · `ldapdomaindump` · `ldeep` · `adidnsdump`

</details>

<details>
<summary><b>Reverse Engineering</b></summary>

`radare2` · `ghidra` · `gdb-peda` · `pwndbg` · `binwalk` · `pwntools` · `checksec` · `yara` · `retdec` · `angr`

</details>

<details>
<summary><b>Forensics</b></summary>

`autopsy` · `volatility3` · `sleuthkit` · `bulk-extractor` · `exiftool` · `steghide` · `zsteg` · `foremost` · `oletools`

</details>

<details>
<summary><b>Wireless</b></summary>

`aircrack-ng` · `airgeddon` · `wifite` · `kismet` · `reaver` · `pixiewps` · `bully`

</details>

<details>
<summary><b>OSINT</b></summary>

`maltego` · `spiderfoot` · `sherlock` · `holehe` · `maigret` · `phoneinfoga` · `twint`

</details>

<details>
<summary><b>Cloud & Containers</b></summary>

`docker` · `kubectl` · `trivy` · `kube-hunter` · `pacu` · `prowler` · `cloudsplaining`

</details>

---

## Kurulum

### Gereksinimler

- Arch Linux tabanlı bir sistem
- `archiso` paketi kurulu
- Root yetkisi
- ~15 GB boş disk
- İnternet bağlantısı

### ISO Oluştur

```bash
git clone https://github.com/muhemmed0634/OmidenOs.git
cd OmidenOs
sudo pacman -S archiso
sudo ./scripts/build.sh
```

### USB'ye Yaz

```bash
# Script ile
sudo ./scripts/flash-usb.sh

# Manuel
sudo dd if=out/omidenos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Diske Kur

Live ortamda terminal açıp çalıştır:

```bash
install-omiden
```

Kurulum sihirbazı:
- UEFI / BIOS otomatik algılar
- Disk seçimi + bölümlendirme (ext4 / btrfs / xfs)
- Kullanıcı, şifre, hostname, timezone
- Openbox masaüstü (isteğe bağlı)
- BlackArch repo (isteğe bağlı)
- GRUB kurulumu

> `archinstall` kullanılmaz. Kurulum scripti tamamen özgün ve bağımsızdır.

---

## BlackArch Reposunu Sonradan Ekle

```bash
setup-blackarch
```

## Proje Yapısı

```
OmidenOs/
├── archiso-profile/
│   ├── profiledef.sh            # ISO meta ve izinler
│   ├── packages.x86_64          # Paket listesi (Arch + BlackArch)
│   ├── pacman.conf              # Arch + BlackArch repo
│   └── airootfs/
│       ├── etc/                 # hostname, locale, keyboard (us), X11
│       ├── root/
│       │   └── .config/
│       │       ├── fastfetch/   # config.jsonc + ASCII logo (omiden.txt)
│       │       ├── openbox/     # rc.xml, menu.xml, autostart
│       │       ├── alacritty/   # Terminal config
│       │       ├── rofi/        # Launcher + özel tema
│       │       ├── tint2/       # Panel config
│       │       └── dunst/       # Bildirim config
│       └── usr/local/bin/
│           ├── install-omiden   # Özel kurulum sihirbazı
│           ├── omiden-welcome   # Live hoş geldin ekranı
│           └── setup-blackarch  # BlackArch repo kurulum scripti
├── scripts/
│   ├── build.sh                 # ISO derle
│   └── flash-usb.sh             # USB'ye yaz
├── Omiden.png
└── README.md
```

---

## Katkı

PR ve issue'lar açıktır. Fork'layıp değişiklik yapabilirsin.

```bash
git clone https://github.com/muhemmed0634/OmidenOs.git
```

---

## Lisans

[GPL-3.0](LICENSE) © [muhemmed0634](https://github.com/muhemmed0634)

---

<div align="center">

*Arch Linux'un gücü. BlackArch'ın araçları. OmidenOs'un tarzı.*

</div>
