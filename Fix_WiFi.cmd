@echo off
color 0A
echo ==========================================================
echo   COMPLETE Wi-Fi Restoration Script
echo   Run this AS ADMINISTRATOR on your Gaming Windows
echo ==========================================================
echo.
echo This script re-enables ALL services required for Wi-Fi
echo to function, re-enables the network adapter, and resets
echo any network stack changes that broke connectivity.
echo.
pause

echo.
echo ============================================
echo  PHASE 1: Re-enabling ALL Wi-Fi Services
echo ============================================

echo [*] WlanSvc (WLAN AutoConfig - Core Wi-Fi service)...
sc config WlanSvc start= auto
net start WlanSvc

echo [*] Wcmsvc (Windows Connection Manager)...
sc config Wcmsvc start= auto
net start Wcmsvc

echo [*] NlaSvc (Network Location Awareness)...
sc config NlaSvc start= auto
net start NlaSvc

echo [*] nsi (Network Store Interface)...
sc config nsi start= auto
net start nsi

echo [*] Dhcp (DHCP Client)...
sc config Dhcp start= auto
net start Dhcp

echo [*] Dnscache (DNS Client)...
sc config Dnscache start= auto
net start Dnscache

echo [*] RmSvc (Radio Management - controls Wi-Fi toggle)...
sc config RmSvc start= auto
net start RmSvc

echo [*] dot3svc (Wired AutoConfig)...
sc config dot3svc start= auto
net start dot3svc

echo [*] NcdAutoSetup (Network Connected Devices Auto-Setup)...
sc config NcdAutoSetup start= auto
net start NcdAutoSetup

echo [*] netprofm (Network List Service)...
sc config netprofm start= auto
net start netprofm

echo [*] lmhosts (TCP/IP NetBIOS Helper)...
sc config lmhosts start= auto
net start lmhosts

echo [*] EapHost (Extensible Authentication Protocol)...
sc config EapHost start= auto
net start EapHost

echo [*] EventSystem (COM+ Event System - dependency)...
sc config EventSystem start= auto
net start EventSystem

echo.
echo ============================================
echo  PHASE 2: Re-enabling Network Adapter
echo ============================================

echo [*] Re-enabling all network adapters...
powershell -ExecutionPolicy Bypass -Command "Get-NetAdapter -IncludeHidden | Enable-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue"

echo [*] Re-enabling IPv6 binding on all adapters...
powershell -ExecutionPolicy Bypass -Command "Enable-NetAdapterBinding -Name '*' -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue"

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

echo [*] Releasing and renewing IP...
ipconfig /release
ipconfig /renew

echo [*] Re-enabling TCP auto-tuning (was disabled by optimization)...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global ecncapability=default
netsh int tcp set global timestamps=default
netsh int tcp set heuristics default

echo.
echo ==========================================================
echo   DONE! Wi-Fi should now be fully restored.
echo.
echo   >>> RESTART YOUR COMPUTER NOW <<<
echo.
echo   After restart, check if the Wi-Fi icon appears in the
echo   taskbar. If it still doesn't appear, open Device Manager
echo   and check if the Realtek RTL8852BE adapter is enabled.
echo ==========================================================
pause
