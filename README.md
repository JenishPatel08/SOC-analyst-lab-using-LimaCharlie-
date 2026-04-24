# 🛡️ SOC Analyst Home Lab

> A fully functional Security Operations Center (SOC) home lab built with VMware, Sysmon, LimaCharlie EDR, and Sliver C2 — designed to simulate real-world attack and detection scenarios.

![Platform](https://img.shields.io/badge/Platform-VMware-blue?style=flat-square)
![OS](https://img.shields.io/badge/Victim-Windows-0078D6?style=flat-square&logo=windows)
![OS](https://img.shields.io/badge/Attacker-Ubuntu-E95420?style=flat-square&logo=ubuntu)
![EDR](https://img.shields.io/badge/EDR-LimaCharlie-6C47FF?style=flat-square)
![C2](https://img.shields.io/badge/C2-Sliver-red?style=flat-square)
![License](https://img.shields.io/badge/License-Educational%20Use-green?style=flat-square)

---

## 📋 Overview

This lab simulates a real enterprise SOC environment where:

- A **Windows VM** acts as the compromised victim endpoint
- An **Ubuntu VM** acts as the attacker, running a **Sliver C2** server
- **Sysmon** collects detailed telemetry on the Windows host
- **LimaCharlie EDR** ingests logs, provides real-time visibility, and enables threat detection

The goal is to practice the full attack-detect-respond cycle that SOC analysts encounter daily.

---

## 🏗️ Lab Architecture

```
┌─────────────────────────────────────────────────────┐
│                    VMware Host                      │
│                                                     │
│   ┌──────────────────┐    ┌──────────────────────┐  │
│   │   Windows VM     │    │    Ubuntu VM         │  │
│   │   (Victim)       │◄───│    (Attacker)        │  │
│   │                  │    │                      │  │
│   │  • Sysmon        │    │  • Sliver C2 Server  │  │
│   │  • LimaCharlie   │    │  • Python HTTP       │  │
│   │    Agent         │    │    Server            │  │
│   └──────┬───────────┘    └──────────────────────┘  │
│          │                                          │
│          ▼                                          │
│   ┌──────────────────┐                              │
│   │  LimaCharlie     │                              │
│   │  Cloud Portal    │                              │
│   │  (EDR/SIEM)      │                              │
│   └──────────────────┘                              │
└─────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```
soc-analyst-lab/
├── README.md                          # This file
├── docs/
│   ├── 01-vm-setup.md                 # VM installation & config
│   ├── 02-disable-windows-security.md # Removing Windows defenses
│   ├── 03-sysmon-setup.md             # Sysmon installation
│   ├── 04-limacharlie-setup.md        # EDR agent + portal config
│   ├── 05-sliver-c2-setup.md          # Attacker C2 setup
│   ├── 06-attack-and-detect.md        # Running the attack & investigating
│   └── 07-detection-rules.md          # Writing LimaCharlie D&R rules
├── configs/
│   └── sysmon-config.xml              # SwiftOnSecurity Sysmon config (reference)
├── scripts/
│   └── disable-defender.ps1           # PowerShell script to disable Defender
└── screenshots/                       # Lab screenshots (add your own)
```

---

## 🚀 Quick Start

| Step | What You'll Do |
|------|---------------|
| [1. VM Setup](docs/01-vm-setup.md) | Install Windows & Ubuntu VMs in VMware |
| [2. Disable Defenses](docs/02-disable-windows-security.md) | Strip Windows security for lab realism |
| [3. Install Sysmon](docs/03-sysmon-setup.md) | Deploy endpoint telemetry collection |
| [4. Setup LimaCharlie](docs/04-limacharlie-setup.md) | Connect EDR agent & configure log ingestion |
| [5. Setup Sliver C2](docs/05-sliver-c2-setup.md) | Prepare attacker infrastructure |
| [6. Attack & Detect](docs/06-attack-and-detect.md) | Run the attack, investigate in LimaCharlie |
| [7. Detection Rules](docs/07-detection-rules.md) | Write rules to catch the attack automatically |

---

## 🛠️ Tools & Technologies

| Tool | Role | Link |
|------|------|------|
| VMware Workstation | Hypervisor | [vmware.com](https://www.vmware.com) |
| Sysmon | Endpoint telemetry | [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) |
| SwiftOnSecurity Config | Sysmon rule config | [GitHub](https://github.com/SwiftOnSecurity/sysmon-config) |
| LimaCharlie | Cloud EDR / SIEM | [limacharlie.io](https://limacharlie.io) |
| Sliver C2 | Command & Control framework | [GitHub](https://github.com/BishopFox/sliver) |
| MinGW-w64 | Cross-compilation for Windows payloads | [mingw-w64.org](https://www.mingw-w64.org) |

---

## ⚠️ Disclaimer

> This lab is built **strictly for educational and research purposes** in an isolated virtual machine environment.  
> Never use these tools or techniques on systems you do not own or have explicit written permission to test.  
> The author is not responsible for any misuse of the information in this repository.

---

## 📖 Credits

- [Eric Capuano's SOC Lab Blog](https://blog.ecapuano.com) — original inspiration
- [SwiftOnSecurity](https://github.com/SwiftOnSecurity/sysmon-config) — Sysmon config
- [BishopFox](https://github.com/BishopFox/sliver) — Sliver C2 framework
