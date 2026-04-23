# 07 — Writing Detection & Response Rules in LimaCharlie

## What are D&R Rules?

LimaCharlie's **Detection & Response (D&R)** rules let you define:
- **Detection** — a condition that matches an event in your telemetry
- **Response** — an automated action when a match is found (alert, isolate, kill process, etc.)

Rules are written in YAML. They're evaluated against every event that flows through LimaCharlie in real time.

---

## Rule Structure

```yaml
# detect block — what to look for
detect:
  op: and
  rules:
    - op: is
      path: routing/event_type
      value: NEW_PROCESS
    - op: contains
      path: event/FILE_PATH
      value: \Downloads\

# respond block — what to do when detected
respond:
  - action: report
    name: Suspicious Process from Downloads
```

---

## Example Rules for This Lab

### 1. Detect Sliver C2 Beacon (Unsigned Outbound HTTP)

Detects an outbound connection from an unsigned binary:

```yaml
detect:
  op: and
  rules:
    - op: is
      path: routing/event_type
      value: NETWORK_CONNECTIONS
    - op: is
      path: event/NETWORK_ACTIVITY
      value: OUTBOUND
    - op: is
      path: event/DESTINATION_PORT
      value: '80'
    - op: is
      path: event/CODE_SIGNATURE/TRUSTED
      value: 'false'

respond:
  - action: report
    name: Unsigned Outbound HTTP Connection
  - action: add tag
    tag: c2-suspect
    ttl: 3600
```

---

### 2. Detect Process Spawned from Downloads

Legitimate software doesn't usually execute from a user's Downloads folder:

```yaml
detect:
  op: and
  rules:
    - op: is
      path: routing/event_type
      value: NEW_PROCESS
    - op: contains
      path: event/FILE_PATH
      value: \Users\
    - op: contains
      path: event/FILE_PATH
      value: \Downloads\

respond:
  - action: report
    name: Process Executed from Downloads Folder
```

---

### 3. Detect Credential Dumping (LSASS Access)

Sliver's `getprivs` and other post-exploitation commands may touch LSASS:

```yaml
detect:
  op: and
  rules:
    - op: is
      path: routing/event_type
      value: SENSITIVE_PROCESS_ACCESS
    - op: ends with
      path: event/TARGET/FILE_PATH
      value: lsass.exe
    - op: is
      path: event/CODE_SIGNATURE/TRUSTED
      value: 'false'

respond:
  - action: report
    name: Unsigned Process Accessed LSASS
  - action: isolate network
```

---

## Adding Rules in the Portal

1. In LimaCharlie, go to **Automation > D&R Rules**
2. Click **New Rule**
3. Paste your YAML into the **Detect** and **Respond** fields
4. Click **Save**
5. Test by triggering the relevant activity on the Windows VM

---

## Viewing Alerts

When a rule fires:
1. Go to **Detections** in the portal
2. You'll see each alert with the event that triggered it, the sensor, and timestamp
3. Click into an alert to see the full raw event JSON

---

## Response Actions Reference

| Action | Description |
|--------|-------------|
| `report` | Create an alert (always include this) |
| `add tag` | Tag the sensor for tracking |
| `isolate network` | Cut off the sensor from the network |
| `kill process` | Terminate the offending process |
| `deny tree` | Kill the process and all children |

---

## ✅ Checkpoint

- [ ] At least one D&R rule created
- [ ] Rule fires and appears in the **Detections** view
- [ ] You understand the detect/respond YAML structure

---

## 🎓 What to Do Next

- Write more rules based on the [MITRE ATT&CK framework](https://attack.mitre.org) TTPs
- Explore LimaCharlie's [Sigma rule import](https://docs.limacharlie.io/docs/sigma-rules) to import community detection rules
- Try more Sliver post-exploitation modules and detect each one
- Experiment with automated responses like network isolation

---

## Resources

- [LimaCharlie D&R Rules Docs](https://docs.limacharlie.io/docs/detection-and-response)
- [MITRE ATT&CK Matrix](https://attack.mitre.org)
- [Sigma Rules Community](https://github.com/SigmaHQ/sigma)
- [Sliver Documentation](https://github.com/BishopFox/sliver/wiki)
