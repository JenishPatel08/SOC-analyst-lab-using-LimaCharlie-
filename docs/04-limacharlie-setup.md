# 04 — LimaCharlie Setup

## What is LimaCharlie?

[LimaCharlie](https://limacharlie.io) is a cloud-based Security Operations Platform that provides:

- **EDR agent** — lightweight sensor deployed on endpoints
- **Real-time telemetry** — processes, network, file system, timeline
- **Artifact collection** — ingests Sysmon/Windows Event Logs
- **Detection & Response (D&R) rules** — write YAML rules to detect and auto-respond to threats
- **VirusTotal integration** — hash lookups built in

The free tier is sufficient for this lab.

---

## Part 1 — Create Your Organization

1. Sign up at [app.limacharlie.io](https://app.limacharlie.io)
2. Click **Create Organization** and fill in:
   - **Name:** `<your-lab-name>` (e.g., `soc-home-lab`)
   - **Data Residency:** Your nearest region
   - **Template:** `EDR`
3. Click **Create**

---

## Part 2 — Deploy the Windows Sensor

### Get the Install Command

1. In your org, go to **Sensors > Add Sensor**
2. Select **Windows**
3. Choose **x86-64 (.exe)**
4. Copy the **4-part installation argument** shown on screen — it looks like:
   ```
   -i <installation_key> -o <org_id> ...
   ```

### Download the Sensor on the Windows VM

Open a browser on the **Windows VM** and navigate to:
```
https://downloads.limacharlie.io/sensor/windows/64
```
This downloads the sensor `.exe` directly.

### Install the Sensor

Open **Command Prompt as Administrator**, navigate to your Downloads folder, and run:

```cmd
cd C:\Users\<username>\Downloads
<sensor_filename>.exe <paste the 4-part argument here>
```

### Verify in Portal

Within a minute, your Windows VM should appear in **Sensors** in the LimaCharlie portal with a green status indicator.

---

## Part 3 — Configure Sysmon Log Ingestion

We need to tell LimaCharlie to collect Sysmon logs as artifacts.

1. In the portal, go to **Artifact Collection**
2. Click **Add Artifact Collection Rule**
3. Fill in:

| Field | Value |
|-------|-------|
| Name | `windows-sysmon-logs` |
| Platform | `Windows` |
| Path Pattern | `wel://Microsoft-Windows-Sysmon/Operational:*` |
| Retention Period | `10` (days) |

4. Click **Save**

---

## Part 4 — Explore the Portal

Once your sensor is live, explore these sections:

### Sensors > [Your Sensor]

| Tab | What You'll See |
|-----|----------------|
| **Overview** | Hostname, OS, sensor version, IP |
| **Processes** | Live process tree with hashes |
| **Network** | Active connections with remote IPs |
| **File System** | Browse the endpoint file system |
| **Timeline** | Chronological event log from Sysmon |
| **Console** | Run remote commands |

### VirusTotal Hash Lookup

In the **Processes** or **File System** view:
1. Click a file hash
2. Click the blue **VirusTotal** button
3. Review detections

> **Note:** Custom-built C2 payloads (like our Sliver implant) will likely show 0 detections on VirusTotal. A clean VT result does **not** mean a file is safe — always look at behavioral indicators.

---

## ✅ Checkpoint

- [ ] LimaCharlie organization created
- [ ] Windows sensor shows as **Online** in the portal
- [ ] Sysmon artifact collection rule saved
- [ ] You can browse the Process list and Network connections for the Windows VM

> 💡 **Take a VM snapshot now.** This is your clean baseline with Sysmon + LimaCharlie fully configured.

---

➡️ Next: [05 — Sliver C2 Setup](05-sliver-c2-setup.md)
