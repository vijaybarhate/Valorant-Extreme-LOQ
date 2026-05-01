# Laptop_Valorant_Extreme.ps1
# Specifically tailored for Lenovo LOQ 15IRX9 (i7-13650HX, RTX 3050)
# DO NOT run blindly on other laptops without verifying core counts and services.

# 1. Require Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Lenovo LOQ Valorant Extreme Optimization " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 2. Disable Nahimic Audio Services (Known to cause DPC latency / crashes)
Write-Host "`n[*] Disabling Nahimic Services..." -ForegroundColor Yellow
$nahimicServices = @("NahimicService", "Nahimic_Mirroring", "NahimicBTLink")
foreach ($svc in $nahimicServices) {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    Disabled $svc" -ForegroundColor Green
    }
}

# 3. CPU Affinity for i7-13650HX
# 6 P-Cores (12 threads: 0-11) + 8 E-Cores (8 threads: 12-19)
# We restrict Valorant to threads 0-11. Hex for 12 bits is 0x0FFF (decimal 4095)
Write-Host "`n[*] Setting Valorant IFEO (High Priority & P-Core Affinity)..." -ForegroundColor Yellow
$ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe"
if (!(Test-Path $ifeoPath)) { New-Item -Path $ifeoPath -Force | Out-Null }
$perfOptionsPath = "$ifeoPath\PerfOptions"
if (!(Test-Path $perfOptionsPath)) { New-Item -Path $perfOptionsPath -Force | Out-Null }

# Priority Class 3 = High
Set-ItemProperty -Path $perfOptionsPath -Name "CpuPriorityClass" -Value 3 -Type DWord -Force
# Affinity mask 0xFFF = Threads 0-11
Set-ItemProperty -Path $perfOptionsPath -Name "CpuAffinityMask" -Value 4095 -Type DWord -Force
Write-Host "    Valorant locked to High Priority and P-Cores only (0xFFF)." -ForegroundColor Green

# 4. Leave Lenovo Vantage and Intel IPF Alone
Write-Host "`n[*] Ensuring Lenovo Vantage and Intel IPF Services remain active for thermal control..." -ForegroundColor Yellow
$vitalServices = @("lenovovantageservice", "lenovo.modern.imcontroller", "ipfsvc", "acpivpc")
foreach ($svc in $vitalServices) {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
        Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
        Write-Host "    Preserved $svc" -ForegroundColor Green
    }
}

# 5. Disable Nagle's Algorithm for Network Adapters
Write-Host "`n[*] Disabling Nagle's Algorithm (TcpAckFrequency & TCPNoDelay)..." -ForegroundColor Yellow
$adapters = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
foreach ($adapter in $adapters) {
    Set-ItemProperty -Path $adapter.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $adapter.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $adapter.PSPath -Name 'TcpDelAckTicks' -Value 0 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "    Nagle's Algorithm disabled for all interfaces." -ForegroundColor Green

# 6. MMCSS & System Responsiveness Overhaul
Write-Host "`n[*] Prioritizing Network and Gaming via MMCSS..." -ForegroundColor Yellow
$mmcssPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $mmcssPath -Name 'NetworkThrottlingIndex' -Value 0xFFFFFFFF -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $mmcssPath -Name 'SystemResponsiveness' -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    Network throttling disabled & System responsiveness set to 0." -ForegroundColor Green

# 7. Disable HPET, Dynamic Ticks & Hibernation
Write-Host "`n[*] Disabling HPET, Dynamic Ticks, and Hibernation..." -ForegroundColor Yellow
& bcdedit /deletevalue useplatformclock *>$null
& bcdedit /set disabledynamictick yes *>$null
& powercfg -h off *>$null
Write-Host "    HPET, Dynamic Ticks, and Hibernation disabled." -ForegroundColor Green

# 8. Disable Visual Effects (Performance Mode)
Write-Host "`n[*] Stripping Visual Effects (Adjust for best performance)..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    Visual effects set to best performance." -ForegroundColor Green

# 9. MSI Mode for RTX 3050 (Latency fix)
Write-Host "`n[*] Enabling MSI Mode for NVIDIA GPU..." -ForegroundColor Yellow
$gpuPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI"
Get-ChildItem $gpuPath -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.GetValue("DriverDesc") -like "*NVIDIA*" } |
ForEach-Object {
    $msiPath = "$($_.PSPath)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
    if (!(Test-Path $msiPath)) { New-Item $msiPath -Force | Out-Null }
    Set-ItemProperty $msiPath -Name "MSISupported" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty $msiPath -Name "MessageNumberLimit" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "    MSI Mode enabled for NVIDIA GPU." -ForegroundColor Green

# 10. NIC Advanced Settings (Interrupt Moderation + LSO off)
Write-Host "`n[*] Applying Advanced NIC Settings..." -ForegroundColor Yellow
$nic = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Up" -and ($_.Name -like "*Wi*" -or $_.Name -like "*Eth*")} | Select-Object -First 1
if ($nic) {
    Set-NetAdapterAdvancedProperty -Name $nic.Name -DisplayName "Interrupt Moderation" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $nic.Name -DisplayName "Large Send Offload v2 (IPv4)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $nic.Name -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $nic.Name -DisplayName "Flow Control" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Write-Host "    NIC settings applied to $($nic.Name)." -ForegroundColor Green
} else {
    Write-Host "    No active NIC found to configure." -ForegroundColor Red
}

# 11. Additional BCD Tweaks
Write-Host "`n[*] Applying additional BCD tweaks (useplatformtick & tscsyncpolicy)..." -ForegroundColor Yellow
& bcdedit /set useplatformtick yes *>$null
& bcdedit /set tscsyncpolicy enhanced *>$null
Write-Host "    BCD tweaks applied." -ForegroundColor Green

# 12. Force Valorant to RTX 3050
Write-Host "`n[*] Forcing Valorant to use dGPU (RTX 3050)..." -ForegroundColor Yellow
$gpuPrefPath = "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
if (!(Test-Path $gpuPrefPath)) { New-Item $gpuPrefPath -Force | Out-Null }
Set-ItemProperty $gpuPrefPath -Name "VALORANT-Win64-Shipping.exe" -Value "GpuPreference=2;" -Type String -ErrorAction SilentlyContinue
Write-Host "    GPU preference set." -ForegroundColor Green

# 13. Disable Windows Update & BITS on gaming partition
Write-Host "`n[*] Disabling Windows Update & BITS..." -ForegroundColor Yellow
$updateServices = @("wuauserv", "WaaSMedicSvc", "BITS")
foreach ($svc in $updateServices) {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
Write-Host "    Update services disabled." -ForegroundColor Green

# 14. Fixed Pagefile
Write-Host "`n[*] Setting fixed 8GB Pagefile..." -ForegroundColor Yellow
$cs = Get-WmiObject Win32_ComputerSystem
$cs.AutomaticManagedPagefile = $false
$cs.Put() | Out-Null
$pf = Get-WmiObject Win32_PageFileSetting
if ($pf) { $pf.Delete() }
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name="C:\pagefile.sys"; InitialSize=8192; MaximumSize=8192} | Out-Null
Write-Host "    Pagefile fixed to 8192MB." -ForegroundColor Green

# 15. Set DNS to Cloudflare (1.1.1.1)
Write-Host "`n[*] Setting DNS to Cloudflare (1.1.1.1)..." -ForegroundColor Yellow
if ($nic) {
    Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses ("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue
    Write-Host "    DNS set to 1.1.1.1 for $($nic.Name)." -ForegroundColor Green
}

# 16. Disable NVIDIA Telemetry & Overlay Services
Write-Host "`n[*] Disabling NVIDIA Telemetry & Overlay hooks..." -ForegroundColor Yellow
$nvServices = @("NvTelemetryContainer", "nvspcaps64")
foreach ($svc in $nvServices) {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
Write-Host "    NVIDIA Telemetry services disabled." -ForegroundColor Green

# =====================================================================
# PHASE 2: KERNEL & DEEP SYSTEM TWEAKS
# =====================================================================

# 17. Disable Kernel Paging of Executive & Driver Pool
Write-Host "`n[*] Forcing kernel + drivers to stay in physical RAM..." -ForegroundColor Yellow
$memMgmtPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $memMgmtPath -Name "DisablePagingExecutive" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $memMgmtPath -Name "LargeSystemCache" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    Kernel paging disabled. Drivers locked in RAM." -ForegroundColor Green

# 18. Disable Prefetch / Superfetch (SysMain)
Write-Host "`n[*] Disabling Prefetch & SysMain..." -ForegroundColor Yellow
$prefetchPath = "$memMgmtPath\PrefetchParameters"
if (!(Test-Path $prefetchPath)) { New-Item -Path $prefetchPath -Force | Out-Null }
Set-ItemProperty -Path $prefetchPath -Name "EnablePrefetcher" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $prefetchPath -Name "EnableSuperfetch" -Value 0 -Type DWord -ErrorAction SilentlyContinue
if (Get-Service "SysMain" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "    Prefetch & SysMain fully disabled." -ForegroundColor Green

# 19. CPU C-State Floor (Force 100% clock on all P-Cores)
Write-Host "`n[*] Disabling CPU C-States at OS level (force max clocks)..." -ForegroundColor Yellow
& powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1 *>$null
& powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 *>$null
& powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 *>$null
& powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 *>$null
& powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 *>$null
& powercfg -setactive SCHEME_CURRENT *>$null
Write-Host "    CPU locked to 100%. C-States disabled at OS level." -ForegroundColor Green

# 20. Win32PrioritySeparation Override (Long quanta, max foreground boost)
Write-Host "`n[*] Overriding Win32PrioritySeparation to 0x28 (long quanta)..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 0x28 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    Scheduler set to long quanta with max foreground boost." -ForegroundColor Green

# 21. GPU IRQ Affinity to P-Core 0
Write-Host "`n[*] Pinning GPU IRQ to P-Core 0..." -ForegroundColor Yellow
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI" -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.GetValue("DriverDesc") -like "*NVIDIA*" } |
ForEach-Object {
    $affinityPath = "$($_.PSPath)\Device Parameters\Interrupt Management\Affinity Policy"
    if (!(Test-Path $affinityPath)) { New-Item $affinityPath -Force | Out-Null }
    # DevicePolicy 4 = IrqPolicySpecifiedProcessors, AssignmentSetOverride = 0x01 (Core 0)
    Set-ItemProperty $affinityPath -Name "DevicePolicy" -Value 4 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty $affinityPath -Name "AssignmentSetOverride" -Value ([byte[]](0x01)) -Type Binary -ErrorAction SilentlyContinue
}
Write-Host "    GPU IRQ pinned to P-Core 0." -ForegroundColor Green

# 22. Wi-Fi IRQ Affinity to P-Core 2
Write-Host "`n[*] Pinning Wi-Fi IRQ to P-Core 2..." -ForegroundColor Yellow
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI" -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.GetValue("DriverDesc") -like "*Realtek*WiFi*" -or $_.GetValue("DriverDesc") -like "*RTL8852*" } |
ForEach-Object {
    $affinityPath = "$($_.PSPath)\Device Parameters\Interrupt Management\Affinity Policy"
    if (!(Test-Path $affinityPath)) { New-Item $affinityPath -Force | Out-Null }
    # Core 2 = Thread 4-5, bitmask 0x04
    Set-ItemProperty $affinityPath -Name "DevicePolicy" -Value 4 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty $affinityPath -Name "AssignmentSetOverride" -Value ([byte[]](0x04)) -Type Binary -ErrorAction SilentlyContinue
}
Write-Host "    Wi-Fi IRQ pinned to P-Core 2." -ForegroundColor Green

# 23. TCP/IP Stack Deep Optimization
Write-Host "`n[*] Applying deep TCP/IP stack tweaks..." -ForegroundColor Yellow
& netsh int tcp set global autotuninglevel=disabled *>$null
& netsh int tcp set global congestionprovider=ctcp *>$null
& netsh int tcp set global ecncapability=disabled *>$null
& netsh int tcp set global timestamps=disabled *>$null
& netsh int tcp set heuristics disabled *>$null
& netsh int ip set global taskoffload=disabled *>$null
Write-Host "    TCP auto-tuning, ECN, timestamps, and heuristics disabled." -ForegroundColor Green

# 24. NTFS / Filesystem Tweaks
Write-Host "`n[*] Optimizing NTFS filesystem behavior..." -ForegroundColor Yellow
& fsutil behavior set disablelastaccess 1 *>$null
& fsutil behavior set disable8dot3 1 *>$null
& fsutil behavior set memoryusage 2 *>$null
Write-Host "    NTFS last-access, 8.3 names disabled. Memory usage optimized." -ForegroundColor Green

# 25. NVIDIA PowerMizer Disable (Force max GPU clocks)
Write-Host "`n[*] Disabling NVIDIA PowerMizer (force max GPU clocks)..." -ForegroundColor Yellow
$nvPolicyPath = "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies"
if (!(Test-Path $nvPolicyPath)) { New-Item $nvPolicyPath -Force | Out-Null }
Set-ItemProperty $nvPolicyPath -Name "PowerMizerEnable" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty $nvPolicyPath -Name "PowerMizerLevel" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty $nvPolicyPath -Name "PowerMizerLevelAC" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    NVIDIA PowerMizer disabled. GPU locked to max performance." -ForegroundColor Green

# 26. Disable Windows Error Reporting & Diagnostic Services
Write-Host "`n[*] Disabling Error Reporting & Diagnostics..." -ForegroundColor Yellow
$diagServices = @("WerSvc", "DiagTrack", "dmwappushservice", "diagnosticshub.standardcollector.service", "DPS")
foreach ($svc in $diagServices) {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
Write-Host "    Error reporting & diagnostic tracking killed." -ForegroundColor Green

# 27. Disable Delivery Optimization (Peer-to-peer update sharing)
Write-Host "`n[*] Disabling Delivery Optimization..." -ForegroundColor Yellow
if (Get-Service "DoSvc" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DoSvc" -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "    Delivery Optimization disabled." -ForegroundColor Green

# 28. Disable Connected User Experiences & Telemetry
Write-Host "`n[*] Killing all telemetry registry keys..." -ForegroundColor Yellow
$telemetryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (!(Test-Path $telemetryPath)) { New-Item $telemetryPath -Force | Out-Null }
Set-ItemProperty $telemetryPath -Name "AllowTelemetry" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty $telemetryPath -Name "AllowDeviceNameInTelemetry" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "    Telemetry set to 0 (Security only)." -ForegroundColor Green

# 29. Disable Windows Search Indexer
Write-Host "`n[*] Disabling Windows Search Indexer..." -ForegroundColor Yellow
if (Get-Service "WSearch" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "    Search Indexer disabled." -ForegroundColor Green

# 30. Disable Print Spooler (Not needed for gaming)
Write-Host "`n[*] Disabling Print Spooler..." -ForegroundColor Yellow
if (Get-Service "Spooler" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "Spooler" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "Spooler" -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "    Print Spooler disabled." -ForegroundColor Green

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host " ALL OPTIMIZATIONS APPLIED!               " -ForegroundColor Cyan
Write-Host " Reboot is REQUIRED for changes to apply. " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Start-Sleep -Seconds 3
