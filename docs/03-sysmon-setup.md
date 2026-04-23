# 03 — Sysmon Setup

## What is Sysmon?

[System Monitor (Sysmon)](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) is a free Microsoft Sysinternals tool that logs detailed endpoint telemetry to the Windows Event Log — things that standard Windows logging misses entirely:

- Process creation with full command lines and hashes
- Network connections (source/dest IP, port, process)
- File creation events
- Registry modifications
- Driver/DLL loads
- And much more

We use the **[SwiftOnSecurity Sysmon config](https://github.com/SwiftOnSecurity/sysmon-config)** — a community-maintained, production-grade ruleset that filters noise and surfaces meaningful events.

---

## Installation

Run all commands in **PowerShell (Administrator)**.

### Step 1 — Download Sysmon

```powershell
Invoke-WebRequest -Uri https://download.sysinternals.com/files/Sysmon.zip -OutFile C:\Windows\Temp\Sysmon.zip
```

### Step 2 — Extract

```powershell
Expand-Archive -LiteralPath C:\Windows\Temp\Sysmon.zip -DestinationPath C:\Windows\Temp\Sysmon
```

### Step 3 — Download SwiftOnSecurity Config

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -OutFile C:\Windows\Temp\Sysmon\sysmonconfig.xml
```

### Step 4 — Install Sysmon with Config

```powershell
C:\Windows\Temp\Sysmon\Sysmon64.exe -accepteula -i C:\Windows\Temp\Sysmon\sysmonconfig.xml
```

---

## Verify Installation

```powershell
# Check service is running
Get-Service Sysmon64

# View the most recent 10 events
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 10
```

Expected output from `Get-Service`:

```
Status   Name               DisplayName
------   ----               -----------
Running  Sysmon64           System Monitor
```

---

## What Events to Watch For

| Event ID | Description |
|----------|-------------|
| 1 | Process creation |
| 3 | Network connection |
| 7 | Image (DLL) loaded |
| 8 | CreateRemoteThread |
| 10 | Process access (credential dumping) |
| 11 | File created |
| 12/13 | Registry events |
| 22 | DNS query |

These event IDs will show up in LimaCharlie once the agent is connected.

---

## ✅ Checkpoint

- [ ] `Get-Service Sysmon64` shows **Running**
- [ ] `Get-WinEvent` returns events without errors
- [ ] Sysmon events visible in **Event Viewer** under `Applications and Services Logs > Microsoft > Windows > Sysmon > Operational`

---

➡️ Next: [04 — LimaCharlie Setup](04-limacharlie-setup.md)
