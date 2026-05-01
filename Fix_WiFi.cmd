@echo off
color 0A
echo ==========================================================
echo   COMPLETE Wi-Fi Restoration Script (Registry Level)
echo   Run this AS ADMINISTRATOR on your Gaming Windows
echo ==========================================================
echo.
echo The 17 Services.ps1 script disabled Wi-Fi at the REGISTRY
echo level using ControlSet001. This script fixes it the same
echo way — by writing directly to the registry.
echo.
echo You MUST RESTART after running this script.
echo.
pause

echo.
echo ============================================
echo  PHASE 1: Registry-Level Service Restore
echo ============================================

echo [*] WlanSvc (WLAN AutoConfig - THE core Wi-Fi service)...
reg add "HKLM\SYSTEM\ControlSet001\Services\WlanSvc" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d 2 /f

echo [*] NlaSvc (Network Location Awareness)...
reg add "HKLM\SYSTEM\ControlSet001\Services\NlaSvc" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d 2 /f

echo [*] Wcmsvc (Windows Connection Manager)...
reg add "HKLM\SYSTEM\ControlSet001\Services\Wcmsvc" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d 2 /f

echo [*] nsi (Network Store Interface)...
reg add "HKLM\SYSTEM\ControlSet001\Services\nsi" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nsi" /v "Start" /t REG_DWORD /d 2 /f

echo [*] Dhcp (DHCP Client)...
reg add "HKLM\SYSTEM\ControlSet001\Services\Dhcp" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "Start" /t REG_DWORD /d 2 /f

echo [*] Dnscache (DNS Client)...
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "Start" /t REG_DWORD /d 2 /f

echo [*] EapHost (Extensible Authentication Protocol)...
reg add "HKLM\SYSTEM\ControlSet001\Services\EapHost" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EapHost" /v "Start" /t REG_DWORD /d 2 /f

echo [*] RmSvc (Radio Management - Wi-Fi toggle visibility)...
reg add "HKLM\SYSTEM\ControlSet001\Services\RmSvc" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RmSvc" /v "Start" /t REG_DWORD /d 2 /f

echo [*] EventLog (Windows Event Log - dependency)...
reg add "HKLM\SYSTEM\ControlSet001\Services\EventLog" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d 2 /f

echo [*] EventSystem (COM+ Event System - dependency)...
reg add "HKLM\SYSTEM\ControlSet001\Services\EventSystem" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d 2 /f

echo [*] lmhosts (TCP/IP NetBIOS Helper)...
reg add "HKLM\SYSTEM\ControlSet001\Services\lmhosts" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d 2 /f

echo [*] netprofm (Network List Service)...
reg add "HKLM\SYSTEM\ControlSet001\Services\netprofm" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t REG_DWORD /d 3 /f

echo [*] NcdAutoSetup (Network Connected Devices)...
reg add "HKLM\SYSTEM\ControlSet001\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d 2 /f

echo [*] dot3svc (Wired AutoConfig)...
reg add "HKLM\SYSTEM\ControlSet001\Services\dot3svc" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dot3svc" /v "Start" /t REG_DWORD /d 3 /f

echo [*] Netman (Network Connections)...
reg add "HKLM\SYSTEM\ControlSet001\Services\Netman" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d 3 /f

echo [*] WinHttpAutoProxySvc (Web Proxy Auto-Discovery)...
reg add "HKLM\SYSTEM\ControlSet001\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d 3 /f

echo [*] iphlpsvc (IP Helper)...
reg add "HKLM\SYSTEM\ControlSet001\Services\iphlpsvc" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d 2 /f

echo [*] NcbService (Network Connection Broker)...
reg add "HKLM\SYSTEM\ControlSet001\Services\NcbService" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d 3 /f

echo [*] wlpasvc (Local Profile Assistant)...
reg add "HKLM\SYSTEM\ControlSet001\Services\wlpasvc" /v "Start" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlpasvc" /v "Start" /t REG_DWORD /d 3 /f

echo.
echo ============================================
echo  PHASE 2: Re-enabling Network Adapter
echo ============================================

echo [*] Re-enabling all network adapters...
powershell -ExecutionPolicy Bypass -Command "Get-NetAdapter -IncludeHidden | Enable-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue"

echo.
echo ============================================
echo  PHASE 3: Resetting Network Stack
echo ============================================

echo [*] Resetting TCP/IP stack...
netsh int ip reset

echo [*] Resetting Winsock catalog...
netsh winsock reset

echo [*] Flushing DNS cache...
ipconfig /flushdns

echo.
echo ==========================================================
echo.
echo   DONE! Now you MUST RESTART your computer.
echo.
echo   The registry changes only take effect after reboot.
echo   After restarting, Wi-Fi icon and connections should
echo   be fully restored.
echo.
echo ==========================================================
pause
