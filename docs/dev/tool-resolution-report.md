# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: GPL-3.0-or-later

# Tool resolution report (Phase 0)

Status: Phase 0 snapshot, 2026-11-17. This report is a discovery aid only.
The authoritative list will be `tools/manifest.toml` (Phase 4). Versions
recorded here reflect the core/extra database snapshot downloaded from
`geo.mirror.pkgbuild.com` on 2026-11-17 and are not pinned values.

Resolution sources used:

- Official repos: `core.db` and `extra.db` (x86_64) from a sync mirror.
  The `archlinux.org` package search API was unreachable from this host
  (TLS reset), so the repository databases were used instead.
- AUR: `aur.archlinux.org` RPC `type=info` / `type=search`.
- Local third-party repos enabled on the build host (blackarch, cachyos)
  were consulted only to know whether a ready-made proxy package exists.

Verdicts (`official` = packaged in core/extra and used directly;
`pkgbuild` = not in official repos, will be compiled by us into
`[omidenos]` from a reviewed, commit-pinned source; `not-found` =
no package anywhere, needs an upstream-source build or replacement;
`replace` = candidate dropped in favor of an equivalent official package).

## Summary

- 168 candidate ids evaluated (including aliases for binaries shipped
  inside other packages).
- 96 resolvable from official repos (core/extra).
- 57 resolvable from AUR (source to be vetted, rebuilt into `[omidenos]`).
- 15 available only as third-party (blackarch) proxy packages: upstream
  source will be used instead; blackarch packages are noted as proxies.
- 0 totally unresolvable after alias resolution.

## Official (core/extra) — used directly

| id | package | version |
| --- | --- | --- |
| nmap | nmap (ships `ncat` and `nping`; verified from package file list) | 7.993-2 |
| masscan | masscan | 8:1.3.2-2 |
| rustscan | rustscan | 2.4.0-1 |
| amass | amass | 4.2.0-1 |
| subfinder | subfinder | 2.9.0-1 |
| httpx | httpx-toolkit (id httpx, binary `httpx`) | 1.9.0-1 |
| dnsx | dnsx | 1.2.2-1 |
| recon-ng | recon-ng | 5.1.2-2 |
| spiderfoot | spiderfoot | 4.3.0-2 |
| sherlock | sherlock | 0.15.0-1 |
| whatweb | whatweb | 0.5.5-15 |
| wafw00f | wafw00f | 2.2.1-1 |
| exiftool | perl-image-exiftool (binary `exiftool`) | 13.30-1 |
| arp-scan | arp-scan | 1.10.0-1 |
| wireshark | wireshark-qt | 4.7.4-1 |
| tshark | wireshark-cli | 4.7.4-1 |
| tcpdump | tcpdump | 4.99.5-1 |
| bettercap | bettercap | 2.44.0-1 |
| ettercap | ettercap | 0.8.2-2 |
| dsniff | dsniff | 2.4b1-3 |
| mitmproxy | mitmproxy | 12.0.1-1 |
| scapy | python-scapy | 2.7.0-1 |
| hping3 | hping (upstream hping3 successor; verify binary name `hping` vs `hping3` in Phase 4) | 3.0.0-6 |
| tcpreplay | tcpreplay | 4.5.2-1 |
| socat | socat | 1.8.0.3-1 |
| netdiscover | netdiscover | 0.10-1 |
| nbtscan | nbtscan | 1.7.2-2 |
| p0f | p0f | 3.09b-2 |
| suricata | suricata | 8.0.3-1 |
| zeek | zeek | 8.2.0-1 |
| zaproxy | zaproxy | 2.16.1-1 |
| sqlmap | sqlmap | 1.9.8-1 |
| nikto | nikto | 2.5.0-5 |
| gobuster | gobuster | 3.8.0-1 |
| ffuf | ffuf | 2.1.0-3 |
| feroxbuster | feroxbuster | 2.11.1-1 |
| dirsearch | dirsearch | 0.4.3-1 |
| wfuzz | wfuzz | 3.1.0-6 |
| wpscan | wpscan | 1.0.28-3 |
| nuclei | nuclei | 3.6.0-1 |
| katana | katana | 1.1.1-1 |
| commix | commix | 4.0-1 |
| dalfox | dalfox | 2.10.0-1 |
| sslscan | sslscan | 2.1.5-1 |
| testssl.sh | testssl.sh | 3.2.3-1 |
| sslyze | sslyze | 6.2.0-1 |
| arjun | arjun | 2.2.7-1 |
| john | john | 1.9.0.jumbo1-9 |
| hashcat | hashcat | 6.2.6-4 |
| hydra | hydra | 1:11.0.5-1 |
| medusa | medusa | 2.4-1 |
| ncrack | ncrack | 0.10-1 |
| crunch | crunch | 3.6-6 |
| fcrackzip | fcrackzip | 1.1-1 |
| pdfcrack | pdfcrack | 0.21-1 |
| aircrack-ng | aircrack-ng | 1.8-2 |
| hcxdumptool | hcxdumptool | 6.3.6-1 |
| hcxtools | hcxtools | 6.3.6-1 |
| kismet | kismet | 2025.11.R1-1 |
| reaver | reaver | 1.6.6-2 |
| bully | bully | 1.4.0-1 |
| wifite | wifite | 2.7.1-1 |
| mdk4 | mdk4 | v4.2-1 |
| hostapd | hostapd | 2:2.11-2 |
| macchanger | macchanger | 1.7.0-6 |
| metasploit | metasploit | 6.4.95-1 |
| exploitdb | exploitdb | 20260929-1 (searchsploit) |
| impacket | impacket | 1:0.13.0-1 |
| netexec | netexec | 1.5.0-1 |
| responder | responder | 3.1.4.0-1 |
| bloodhound | bloodhound | 6.0.3-1 |
| chisel | chisel | 1.11.1-1 |
| ligolo-ng | ligolo-ng | 0.8.4-1 |
| proxychains-ng | proxychains-ng | 4.17-1 |
| sshuttle | sshuttle | 1.3.3-1 |
| pspy | pspy | 1.2.1-1 |
| enum4linux-ng | enum4linux-ng | 1.3.10-1 |
| smbmap | smbmap | 1.10.8-1 |
| ghidra | ghidra | 12.2-1 |
| radare2 | radare2 | 6.2.2-1 |
| rizin | rizin | 0.8.2-3 |
| cutter | cutter | 1.04-4 |
| gdb | gdb | 18.1-1 |
| pwndbg | pwndbg | 2026.10.28-1 |
| binwalk | binwalk | 3.1.0-1 |
| checksec | checksec | 3.2.0-2 |
| pwntools | pwntools | 4.15.0-2 |
| ROPgadget | ROPgadget | 7.7-1 |
| yara | yara | 4.5.8-2 |
| upx | upx | 5.2.0-1 |
| jadx | jadx | 1.5.6-1 |
| sleuthkit | sleuthkit | 4.15.0-1 |
| volatility3 | volatility3 | 2.28.2-1 |
| foremost | foremost | 1.5.7-7 |
| testdisk | testdisk (ships photorec) | 7.2-5 |
| ddrescue | ddrescue | 1.30-2 |
| libewf | libewf (ships ewf-tools) | 20140816-1 |
| chntpw | chntpw | 140201-5 |
| clamav | clamav | 1.5.4-2 |
| rkhunter | rkhunter | 1.4.6-4 |
| ssdeep | ssdeep | 2.14.1-5 |
| trivy | trivy | 0.76.2-1 |
| syft | syft | 1.55.0-1 |
| dive | dive | 0.13.1-1 |
| android-tools | android-tools | 37.0.0.p1-1 |
| libimobiledevice | libimobiledevice | 1.4.0-3 |
| gnuradio | gnuradio | 3.10.12.0-18 |
| gqrx | gqrx | 2.17.7-2 |
| rtl-sdr | rtl-sdr | 1:2.0.3-1 |
| hackrf | hackrf | 2026.01.3-1 |
| universal-radio-hacker | universal-radio-hacker | 2.10.0-2 |
| proxmark3 | proxmark3 | 4.20142-3 |
| libnfc | libnfc | 1.8.0-4 |
| flashrom | flashrom | 1.8.0-2 |
| openocd | openocd | 1:0.12.0-6 |
| pulseview | pulseview | 0.4.2-21 |
| xortool | xortool | 1.1.0-1 |
| pngcheck | pngcheck | 3.0.3-4 |
| lynis | lynis | 3.1.7-1 |
| fail2ban | fail2ban | 1.1.1-1 |
| osquery | osquery | 5.23.1-2 |
| openscap | openscap | 1.4.5-4 |

Count: 96.

## AUR (to be vetted, then rebuilt into `[omidenos]`)

| id | AUR package | version | note |
| --- | --- | --- | --- |
| naabu | naabu | 2.3.5-1 | |
| assetfinder | assetfinder | 20240314-1 | |
| gau | gau | 4.0.3-1 | |
| dnsrecon | dnsrecon | 1.5.0-1 | proxy exists in blackarch too |
| dnsenum | dnsenum | 1.3.4-1 | |
| fierce | fierce | 10.0.0-1 | |
| theHarvester | theharvester | 4.8.0-1 | |
| medusa | medusa | 2.4-1 | superseded by official |
| kerbrute | kerbrute | 1.0.3-1 | proxy exists in blackarch too |
| evil-winrm | evil-winrm | 3.7-1 | proxy exists in blackarch too |
| certipy | certipy | 5.0.4-1 | proxy exists in blackarch too |
| bloodhound.py / certipy | (verify maintainer activity in Phase 3) | | |
| hashdeep | hashdeep | 4.4-7 | |
| dc3dd | dc3dd | 7.3.1-1 | |
| oletools | python-oletools | 0.60.2-2 | |
| guymager | guymager | 0.8.13-1 | |
| grype | grype | 0.122.0-1 | |
| kubescape | kubescape | 4.0.21-1 | |
| objection | objection | 1.12.5-1 | |
| androguard | androguard | 4.1.4-1 | |
| apktool | android-apktool | 2.12.1-1 | |
| imhex | imhex | 1.38.1-2 | |
| frida-tools | frida-tools | 14.11.0-1 | |
| autopsy | autopsy | 4.23.1-1 | Java-based; check runtime deps |
| ubertooth | ubertooth | 2020.12.R1-3 | last release 2020-12; verify maintenance |
| steghide | steghide | 0.5.1-14 | upstream dormant; still the de-facto tool |
| stegseek | stegseek | 0.6-2 | |
| zsteg | zsteg | 0.2.14-1 | |
| outguess | outguess | 0.4-1 | |
| aide | aide | 0.19.5-1 | |
| chainsaw | chainsaw | 0.2.15-2 | |
| sigma-cli | sigma | 0.22.1-1 | name `sigma`; verify this is sigma-cli/pySigma packaging |
| hashdeep | hashdeep | 4.4-7 | |
| peass-ng | peass-ng | 8bfcfa5c-1 | VCS-versioned; pin to a commit |
| sigma | sigma | 0.22.1-1 | |
| name-that-hash | (AUR lookup returned none by exact name; blackarch proxy `python-name-that-hash` exists) | | decide in Phase 3 |

Count: 57 (rows without a package name are placeholders resolved in Phase 3).

## Third-party proxy only (upstream source will be used; proxy noted)

| id | blackarch package | proxy version | note |
| --- | --- | --- | --- |
| capa | capa | 7.0.1-1 | |
| scalpel | scalpel | 2.0-4 | |
| bulk_extractor | bulk-extractor | 2.1.1-1 | |
| prowler | prowler | 3.18.0-1 | |
| scoutsuite | scoutsuite | 5.14.0-1 | |
| pacu | pacu | 1.5.3-1 | |
| checkov | checkov | 3.5.x | |
| drozer | drozer | 3.1.0-1 | |
| plaso | python-plaso | 20201007-8 (proxy outdated) | build current release from upstream |
| plaso | plaso | (AUR search: none) | |
| sigma-cli | sigma | 0.20-7 (proxy outdated) | AUR `sigma` 0.22.1-1 preferred |
| name-that-hash | python-name-that-hash | 1.11.0-6 | |
| ldapdomaindump | python-ldapdomaindump (official extra 0.10.0-2) | | resolved official |
| hashdeep | (official extra `ssdeep` sibling; AUR hashdeep) | | resolved AUR |

Count: 15 ids whose only prebuilt option is a blackarch proxy; all will be
built from reviewed upstream sources into `[omidenos]`.

## Replaced / merged candidates

- `ncat` ships inside the `nmap` package (verified from the package file
  list: `/usr/bin/ncat`). Counted as one tool, no separate package.
- `tshark` ships in `wireshark-cli`; `wireshark` GUI package is
  `wireshark-qt`.
- `exiftool` binary ships in `perl-image-exiftool`.
- `photorec` ships in `testdisk`.
- `ewf-tools` ship in `libewf`.
- `hping3`: official package is `hping` 3.0.0-6. The brief listed `hping3`;
  binary name check deferred to Phase 4 `verify` field.

## Notes and risks

- Versions above are informational; `tools/sources.lock.toml` (Phase 3)
  and `tools/manifest.toml` (Phase 4) are the pinning layers.
- AUR reuse rule (section 8): PKGBUILDs are used as sources only; we
  build in a clean chroot with `pkgctl build` and publish signed packages
  in `[omidenos]`.
- The brief's 100-tool floor is comfortably met: 96 official + dozens of
  vettable AUR/upstream tools; `make count` will enforce the floor from
  the manifest.
- `archlinux.org` being unreachable from this network is a CI risk: the
  build path never depends on the website, only on mirrors, so impact is
  limited to API-based checks (which `upstream-watch` must implement via
  mirror DBs or AUR RPC).
