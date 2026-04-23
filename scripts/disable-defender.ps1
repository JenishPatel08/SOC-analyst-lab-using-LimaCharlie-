# disable-defender.ps1
# ⚠️  FOR LAB USE ONLY — Do NOT run on production systems
# Run as Administrator

Write-Host "[*] Disabling Windows Defender and sleep settings..." -ForegroundColor Yellow

# Disable via registry
reg add "hklm\software\policies\microsoft\windows defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

# Prevent sleep/standby
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0

Write-Host "[+] Registry key set to disable AntiSpyware." -ForegroundColor Green
Write-Host "[+] Power settings configured (no sleep/standby)." -ForegroundColor Green
Write-Host ""
Write-Host "[!] Remember to also:" -ForegroundColor Cyan
Write-Host "    1. Disable Tamper Protection in Windows Security UI"
Write-Host "    2. Run gpedit.msc and disable Defender via Group Policy"
Write-Host "    3. Boot into Safe Mode to disable Defender services in the registry"
Write-Host ""
Write-Host "[*] Done. See docs/02-disable-windows-security.md for full steps." -ForegroundColor Yellow
