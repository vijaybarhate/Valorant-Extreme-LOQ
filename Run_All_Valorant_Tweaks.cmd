@echo off
color 0C
echo ==========================================================
echo   ABSOLUTE EXTREME VALORANT SETUP (GAMING WINDOWS ONLY)
echo ==========================================================
echo.
echo WARNING: This will strip Windows of Defender, UAC, and security
echo mitigations to maximize framerates. Do NOT use this OS for
echo general web browsing or downloading random files.
echo.
echo Make sure you are running this AS ADMINISTRATOR.
echo.
pause

echo.
echo [*] Running Custom Extreme Laptop Tweaks (P-Cores, Nagle, HPET, MMCSS, Visuals)...
powershell -ExecutionPolicy Bypass -File "Laptop_Valorant_Extreme.ps1"

echo.
echo [*] Applying Ultimate Power Plan...
powershell -ExecutionPolicy Bypass -File "6 Windows\29 Power Plan.ps1"

echo.
echo [*] Applying Timer Resolution Fix...
powershell -ExecutionPolicy Bypass -File "6 Windows\30 Timer Resolution.ps1"

echo.
echo [*] Applying Hardware Legacy Flip...
powershell -ExecutionPolicy Bypass -File "8 Advanced\12 Hardware Legacy Flip.ps1"

echo.
echo [*] Disabling Windows Firewall...
powershell -ExecutionPolicy Bypass -File "8 Advanced\2 Firewall.ps1"

echo.
echo [*] Disabling Multi-Plane Overlay (MPO)...
powershell -ExecutionPolicy Bypass -File "8 Advanced\11 Mpo.ps1"

echo.
echo [*] Disabling Memory Compression...
powershell -ExecutionPolicy Bypass -File "3 Setup\2 Memory Compression.ps1"

echo.
echo [*] Killing Gamebar / Game DVR Hooks...
powershell -ExecutionPolicy Bypass -File "6 Windows\19 Gamebar.ps1"

echo.
echo [*] Disabling Core Isolation / VBS / HVCI...
powershell -ExecutionPolicy Bypass -File "8 Advanced\32 Core Isolation.ps1"

echo.
echo [*] Adjusting Process Priority Separations...
powershell -ExecutionPolicy Bypass -File "8 Advanced\10 Priority.ps1"

echo.
echo [*] Removing Windows Defender...
powershell -ExecutionPolicy Bypass -File "8 Advanced\1 Defender.ps1"

echo.
echo [*] Disabling Spectre / Meltdown CPU Mitigations...
powershell -ExecutionPolicy Bypass -File "8 Advanced\3 Spectre Meltdown.ps1"

echo.
echo [*] Disabling Device Manager Power Savings...
powershell -ExecutionPolicy Bypass -File "6 Windows\25 Device Manager Power Savings & Wake.ps1"

echo.
echo [*] Disabling User Account Control (UAC)...
powershell -ExecutionPolicy Bypass -File "6 Windows\31 UAC.ps1"

echo.
echo [*] DESTROYING unnecessary Windows Services (massive cleanup)...
powershell -ExecutionPolicy Bypass -File "8 Advanced\17 Services.ps1"

echo.
echo [*] Disabling Network Adapter Power Savings...
powershell -ExecutionPolicy Bypass -File "6 Windows\26 Network Adapter Power Savings & Wake.ps1"

echo.
echo [*] Forcing IPv4 Only (lower latency, no IPv6 overhead)...
powershell -ExecutionPolicy Bypass -File "6 Windows\27 Network IPv4 Only.ps1"

echo.
echo ==========================================================
echo   ALL EXTREME TWEAKS APPLIED SUCCESSFULLY! 
echo   PLEASE RESTART YOUR GAMING COMPUTER NOW.
echo ==========================================================
pause
