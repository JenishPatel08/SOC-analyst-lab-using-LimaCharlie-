# 05 — Sliver C2 Setup (Attacker Infrastructure)

## What is Sliver?

[Sliver](https://github.com/BishopFox/sliver) is an open-source Command & Control (C2) framework developed by BishopFox, widely used in red team operations and security research. It supports multiple communication protocols (HTTP/S, DNS, mTLS, WireGuard) and generates cross-platform implants.

In this lab, Sliver runs on the **Ubuntu attacker VM** and communicates over HTTP with the implant running on the Windows victim VM.

---

## Part 1 — Configure a Static IP on Ubuntu

A static IP prevents the C2 listener address from changing between reboots.

### Find Your Current IP and Gateway

```bash
ip a                    # Note your current IP (e.g., 192.168.217.232)
ping _gateway -c 1      # Note the gateway IP
```

### Edit the Netplan Config

```bash
# Find your config file name
ls /etc/netplan/

# Edit it (filename may vary: 00-installer-config.yaml or 50-cloud-init.yaml)
sudo nano /etc/netplan/00-installer-config.yaml
```

Example static config:

```yaml
network:
  version: 2
  ethernets:
    ens33:                          # Replace with your interface name
      dhcp4: no
      addresses:
        - 192.168.217.232/24        # Your chosen static IP
      gateway4: 192.168.217.2       # Your gateway IP
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

### Apply the Config

```bash
sudo netplan try    # Test — auto-reverts after 120s if you don't confirm
sudo netplan apply  # Apply permanently

ping 8.8.8.8        # Verify internet connectivity
```

---

## Part 2 — SSH into Ubuntu from Windows VM

From the **Windows VM**, open Command Prompt or PowerShell:

```cmd
ssh <username>@<Ubuntu_VM_IP>
```

Type `yes` when prompted about the host fingerprint, then enter your password.

Working via SSH gives you a convenient terminal session without switching between VM windows.

---

## Part 3 — Install Sliver C2 Server

Run these commands on the Ubuntu VM (via SSH or direct terminal):

### Download Sliver Binary

```bash
wget https://github.com/BishopFox/sliver/releases/download/v1.5.34/sliver-server_linux \
  -O /usr/local/bin/sliver-server
```

### Make It Executable

```bash
chmod +x /usr/local/bin/sliver-server
```

### Install MinGW-w64 (for Windows payload compilation)

```bash
apt install -y mingw-w64
```

### Launch Sliver

```bash
sliver-server
```

On first launch, Sliver generates its certificates and configurations. You'll see the Sliver banner and be dropped into the Sliver shell (`sliver >`).

---

## ✅ Checkpoint

- [ ] Ubuntu has a static IP address
- [ ] SSH from Windows VM to Ubuntu works
- [ ] `sliver-server` launches without errors
- [ ] Sliver interactive shell appears (`sliver >` prompt)

---

➡️ Next: [06 — Attack & Detect](06-attack-and-detect.md)
