# 02 — Disable Windows Security

> ⚠️ **Lab VM only.** These steps intentionally weaken the Windows VM to simulate an unprotected endpoint. Never do this on a real machine.

---

## Why Disable Defenses?

In this lab, we want to simulate a realistic but unprotected endpoint — one where an attacker can deploy a C2 implant without AV/EDR interference. We then rely on **Sysmon** and **LimaCharlie** as our detection layer instead of built-in Windows defenses.

---

## Step 1 — Disable Tamper Protection

1. Open **Windows Security** (`Settings > Windows Security > Virus & Threat Protection`)
2. Click **Manage Settings** under *Virus & threat protection settings*
3. Toggle **Tamper Protection** to **Off**
4. Disable all remaining options on the page

---

## Step 2 — Disable Defender via Group Policy

Open **Run** (`Win + R`) and type:
```
gpedit.msc
```

Navigate to:
```
Computer Configuration
  └── Administrative Templates
        └── Windows Components
              └── Microsoft Defender Antivirus
```

Double-click **"Turn off Microsoft Defender Antivirus"** → Set to **Enabled** → Apply.

---

## Step 3 — Disable via Registry (Command Line)

Open **Command Prompt as Administrator** and run:

```cmd
REG ADD "hklm\software\policies\microsoft\windows defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
```

---

## Step 4 — Prevent Sleep & Standby

This keeps the VM active during extended lab sessions:

```cmd
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0
```

---

## Step 5 — Disable Defender Services via Safe Mode

Defender services need to be disabled at the registry level, which requires Safe Mode.

### 5a — Boot into Safe Mode

1. Open **Run** → type `msconfig`
2. Go to the **Boot** tab → check **Safe boot** → select **Minimal**
3. Click **OK** → **Restart**

### 5b — Disable Services in Registry

After booting into Safe Mode, open **Registry Editor** (`regedit`) and navigate to:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\
```

For **each** of the following service keys, find the `Start` DWORD value and change it from `3` → `4`:

| Service Key | Description |
|-------------|-------------|
| `Sense` | Windows Defender Advanced Threat Protection |
| `WdBoot` | Windows Defender Boot |
| `WinDefend` | Windows Defender Antivirus Service |
| `WdNisDrv` | Windows Defender Network Inspection |
| `WdNisSvc` | Windows Defender Network Inspection Service |
| `WdFilter` | Windows Defender Mini-Filter Driver |

### 5c — Return to Normal Mode

1. Open `msconfig` again
2. Go to **Boot** tab → uncheck **Safe boot**
3. Restart

---

## ✅ Checkpoint

After rebooting:
- [ ] Windows Security shows Defender as off/unavailable
- [ ] No real-time protection warnings are blocking execution
- [ ] VM does not sleep during the lab

---

➡️ Next: [03 — Sysmon Setup](03-sysmon-setup.md)
