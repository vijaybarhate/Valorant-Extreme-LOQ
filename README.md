# 🎯 Valorant Extreme — Laptop Edition

> Absolute maximum performance Windows tweaks for playing **Valorant** on a dedicated dual-boot gaming partition.
> Tailored for the **Lenovo LOQ 15IRX9** (i7-13650HX + RTX 3050 6GB) but adaptable to other Intel 13th/14th Gen hybrid-core gaming laptops.

![Windows 11](https://img.shields.io/badge/Windows-11-0078D6?logo=windows11&logoColor=white)
![Valorant](https://img.shields.io/badge/Valorant-Competitive-FF4655?logo=riotgames&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?logo=powershell&logoColor=white)

---

## ⚠️ EXTREME WARNING

> **This setup strips Windows of Defender, UAC, Firewall, CPU security mitigations (Spectre/Meltdown), and disables dozens of services.**
> 
> **Use this ONLY on a dedicated dual-boot gaming partition. DO NOT use this OS for web browsing, banking, or downloading random files.**

---

## 🖥️ Target Hardware

| Component | Specification |
|---|---|
| Laptop | Lenovo LOQ 15IRX9 (83DV) |
| CPU | Intel i7-13650HX (6P + 8E cores, 20 threads) |
| GPU | NVIDIA GeForce RTX 3050 6GB Laptop |
| RAM | 24 GB DDR5 |
| Storage | WD SN740 512GB NVMe |
| Display | 1920x1080 @ 144Hz |
| Wi-Fi | Realtek RTL8852BE WiFi 6 |
| OS | Windows 11 Pro (Dual-boot gaming partition) |

---

## 📦 What's Included

| File | Description |
|---|---|
| `Laptop_Valorant_Extreme.ps1` | Custom PowerShell script with **30 deep system tweaks** |
| `Run_All_Valorant_Tweaks.cmd` | Master batch runner — executes the custom script + 17 standard Ultimate scripts |
| `MANUAL_STEPS_VALORANT.txt` | 10-step manual guide for BIOS, NVIDIA Control Panel, Valorant settings, etc. |

---

## 🔧 Prerequisites

This project works **alongside** the [Ultimate](https://github.com/FR33THYFR33THY/Ultimate) Windows optimization repo by FR33THYFR33THY. You need to clone it first.

```powershell
# 1. Clone the Ultimate repo
git clone https://github.com/FR33THYFR33THY/Ultimate.git

# 2. Copy THIS repo's files INTO the Ultimate folder
# Place Laptop_Valorant_Extreme.ps1, Run_All_Valorant_Tweaks.cmd,
# and MANUAL_STEPS_VALORANT.txt into the root of the Ultimate folder
```

---

## 🚀 Usage

1. **Clone Ultimate repo** and place these files inside it
2. Copy the entire folder to your **gaming partition** (USB drive or shared drive)
3. Boot into your **dedicated gaming Windows**
4. Right-click `Run_All_Valorant_Tweaks.cmd` → **Run as Administrator**
5. Wait for all scripts to complete
6. **Reboot**
7. Open `MANUAL_STEPS_VALORANT.txt` and follow the 10 manual steps

---

## 📋 Custom Script Tweaks (30 Total)

### Phase 1: Hardware & Network

| # | Tweak | Impact |
|---|---|---|
| 1 | Disable Nahimic Audio Services | Fixes DPC latency / crashes |
| 2 | Valorant P-Core affinity (0xFFF) | Game runs on 6 fast P-Cores only |
| 3 | Valorant High Priority (IFEO) | CPU prioritizes game threads |
| 4 | Preserve Lenovo Vantage/IPF | Keeps laptop fan control alive |
| 5 | Disable Nagle's Algorithm | Instant packet delivery (lower ping) |
| 6 | MMCSS SystemResponsiveness=0 | 100% CPU time to foreground game |
| 7 | HPET + Dynamic Ticks off | Use CPU internal TSC timer |
| 8 | Visual Effects purge | Remove DWM rendering overhead |
| 9 | MSI Mode for RTX 3050 | Biggest single DPC latency fix |
| 10 | NIC: Interrupt Mod + LSO off | Lower network interrupt latency |
| 11 | BCD: platformtick + tscsync | Better multi-core timer sync |
| 12 | Force dGPU for Valorant | Bypass Intel iGPU completely |
| 13 | Disable Windows Update + BITS | No background downloads mid-game |
| 14 | Fixed 8GB Pagefile | No mid-game resize stutters |
| 15 | DNS → Cloudflare 1.1.1.1 | Faster server lookups |
| 16 | NVIDIA Telemetry off | Remove overlay input lag |

### Phase 2: Kernel & Deep System

| # | Tweak | Impact |
|---|---|---|
| 17 | Kernel paging executive off | Lock kernel + drivers in RAM |
| 18 | Prefetch + SysMain off | Stop background disk prediction |
| 19 | C-State floor (100% clocks) | CPU never sleeps mid-frame |
| 20 | Win32PrioritySeparation 0x28 | Long quanta, max foreground boost |
| 21 | GPU IRQ → P-Core 0 | GPU interrupts on fastest core |
| 22 | Wi-Fi IRQ → P-Core 2 | Network interrupts on dedicated core |
| 23 | TCP stack: autotuning/ECN off | Minimum network stack overhead |
| 24 | NTFS: last-access, 8.3 off | Reduce disk I/O overhead |
| 25 | NVIDIA PowerMizer off | Force max GPU clocks always |
| 26 | Error Reporting + DiagTrack off | Kill diagnostics overhead |
| 27 | Delivery Optimization off | No P2P update sharing |
| 28 | Telemetry registry = 0 | Security-only telemetry level |
| 29 | Windows Search Indexer off | No background disk scanning |
| 30 | Print Spooler off | Not needed for gaming |

---

## 📋 Ultimate Scripts Executed (17 Total)

| Order | Script | Purpose |
|---|---|---|
| 1 | `6 Windows\29 Power Plan.ps1` | Ultimate Performance power plan |
| 2 | `6 Windows\30 Timer Resolution.ps1` | Fix Windows timer to 0.5ms |
| 3 | `8 Advanced\12 Hardware Legacy Flip.ps1` | Optimize fullscreen/borderless |
| 4 | `8 Advanced\2 Firewall.ps1` | Disable Windows Firewall |
| 5 | `8 Advanced\11 Mpo.ps1` | Disable Multi-Plane Overlay |
| 6 | `3 Setup\2 Memory Compression.ps1` | Stop CPU RAM decompression |
| 7 | `6 Windows\19 Gamebar.ps1` | Kill Xbox Game Bar/DVR |
| 8 | `8 Advanced\32 Core Isolation.ps1` | Disable VBS/HVCI |
| 9 | `8 Advanced\10 Priority.ps1` | Foreground process priority |
| 10 | `8 Advanced\1 Defender.ps1` | Remove Windows Defender |
| 11 | `8 Advanced\3 Spectre Meltdown.ps1` | Disable CPU security mitigations |
| 12 | `6 Windows\25 Device Mgr Power.ps1` | Strip HW power savings |
| 13 | `6 Windows\31 UAC.ps1` | Disable UAC |
| 14 | `8 Advanced\17 Services.ps1` | Massive services destruction |
| 15 | `6 Windows\26 NIC Power Savings.ps1` | NIC power management off |
| 16 | `6 Windows\27 IPv4 Only.ps1` | Force IPv4, disable IPv6 |

---

## 📖 Manual Steps (Post-Script)

After running the scripts and rebooting, open `MANUAL_STEPS_VALORANT.txt` for:

1. **BIOS Settings** — Disable VT-x, enable Turbo Boost, disable C-States
2. **Lenovo Vantage** — Set Performance thermal mode (Fn+Q)
3. **NVCleanstall** — Install stripped NVIDIA drivers
4. **NVIDIA Control Panel** — Low Latency Ultra, Max Performance, Shader Cache Unlimited
5. **NVIDIA Profile Inspector** — Force P2 State Off, Pre-Rendered Frames = 1
6. **Valorant In-Game** — NVIDIA Reflex On+Boost, Raw Input Buffer On, all visuals Low
7. **Windows Display** — Confirm 144Hz, HDR Off
8. **Mouse Settings** — 6/11, no acceleration, 1000Hz polling
9. **Physical Setup** — Always plugged in, cooling pad, clean vents
10. **Network** — Use Ethernet if possible, or 5GHz Wi-Fi

---

## 🔄 Adapting for Other Laptops

If you have a different laptop, you'll need to modify:

- **P-Core affinity mask** in tweak #2 — calculate based on your CPU's P-Core/E-Core layout
- **Vital services list** in tweak #4 — change to your manufacturer's thermal services
- **Wi-Fi IRQ grep** in tweak #22 — change the adapter name pattern
- **BIOS steps** in the manual guide — vary by manufacturer

---

## 📝 Credits

- **[Ultimate](https://github.com/FR33THYFR33THY/Ultimate)** by FR33THYFR33THY — The base Windows optimization scripts
- **Custom laptop adaptations** — Tailored for Lenovo LOQ + Valorant by this project

---

## 📄 License

This project is provided as-is for educational purposes. Use at your own risk. The author is not responsible for any hardware damage, system instability, or account bans.
