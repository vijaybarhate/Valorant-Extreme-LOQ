@echo off
color 0A
echo ==========================================================
echo   Wi-Fi Fixer (Re-Enables WLAN AutoConfig Service)
echo ==========================================================
echo.
echo Make sure you are running this AS ADMINISTRATOR.
echo.
pause

echo.
echo [*] Re-enabling WlanSvc (Wi-Fi Service)...
powershell -ExecutionPolicy Bypass -Command "Set-Service -Name WlanSvc -StartupType Automatic; Start-Service -Name WlanSvc"

echo.
echo [*] Re-enabling Network Adapter Power (if it was disabled)...
powershell -ExecutionPolicy Bypass -Command "Enable-NetAdapterBinding -Name '*' -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue"

echo.
echo ==========================================================
echo   Wi-Fi has been restored! Check your network icon.
echo ==========================================================
pause
