# 01 — Virtual Machine Setup

## Overview

This lab uses two virtual machines running inside VMware:

| VM | OS | Role |
|----|----|------|
| Victim | Windows 10/11 | Target endpoint with Sysmon + LimaCharlie |
| Attacker | Ubuntu Server | Runs Sliver C2 framework |

---

## Prerequisites

- [VMware Workstation Pro](https://www.vmware.com/products/workstation-pro.html) or VMware Workstation Player (free)
- Windows 10/11 ISO
- Ubuntu Server 22.04 ISO ([download](https://ubuntu.com/download/server))
- At least **16 GB RAM** and **100 GB free disk space** on the host

---

## Windows VM Setup

1. Create a new VM in VMware — choose **Windows 10/11 64-bit**.
2. Allocate at least **4 GB RAM** and **60 GB disk**.
3. Complete the Windows installation normally.
4. After install, take an **initial snapshot** before making any changes.

---

## Ubuntu Server VM Setup

1. Create a new VM — choose **Linux > Ubuntu 64-bit**.
2. Allocate at least **2 GB RAM** and **20 GB disk**.
3. During installation, when prompted for **OpenSSH**, select **Install OpenSSH server** ✅
4. Complete the installation and note the default IP address.

### Verify SSH Access

From the Windows VM (or your host), confirm SSH works:

```bash
ssh <username>@<Ubuntu_VM_IP>
```

---

## Network Configuration

Both VMs should be on the same **NAT** or **Host-Only** network in VMware so they can communicate with each other.

To check:
- VMware Menu → **VM > Settings > Network Adapter**
- Set both VMs to the same network type (recommended: **NAT** for internet + inter-VM access)

---

## ✅ Checkpoint

Before continuing:
- [ ] Windows VM boots successfully
- [ ] Ubuntu VM boots successfully
- [ ] SSH from Windows to Ubuntu works
- [ ] Both VMs can ping each other

---

➡️ Next: [02 — Disable Windows Security](02-disable-windows-security.md)
