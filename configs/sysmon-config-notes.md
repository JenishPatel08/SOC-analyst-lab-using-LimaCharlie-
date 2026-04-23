# Sysmon Configuration

This lab uses the **SwiftOnSecurity** Sysmon configuration, which is a community-maintained,
production-quality ruleset for Sysmon.

## Source

- **Repository:** https://github.com/SwiftOnSecurity/sysmon-config
- **Config file:** `sysmonconfig-export.xml`

## How to Download

```powershell
Invoke-WebRequest `
  -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml `
  -OutFile C:\Windows\Temp\Sysmon\sysmonconfig.xml
```

## Why This Config?

The default Sysmon installation with no config generates massive amounts of noise.
SwiftOnSecurity's config includes:

- Tuned exclusions to reduce false positives from known-good software
- Coverage for all major Sysmon event types
- Community-maintained updates as new attack techniques emerge

## Customizing

If you want to tailor the config further for your lab:

1. Fork the SwiftOnSecurity repo
2. Edit the XML rules to add your own include/exclude filters
3. Reload with: `Sysmon64.exe -c <your_config.xml>`

## Alternative Configs

| Config | Description |
|--------|-------------|
| [SwiftOnSecurity](https://github.com/SwiftOnSecurity/sysmon-config) | Most widely used, good baseline |
| [olafhartong/sysmon-modular](https://github.com/olafhartong/sysmon-modular) | Modular, MITRE ATT&CK mapped |
| [ion-storm](https://github.com/ion-storm/sysmon-config) | High-fidelity, more verbose |
