@echo off
REM ============================================================
REM  GAMING MODE  -  Turns ON the Windows hypervisor / VBS
REM  Use this when you want to play games with kernel anti-cheat
REM  (FACEIT, Vanguard, Javelin, BattlEye).
REM  VirtualBox will run ~10x slower after this.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

title Gaming Mode - Enabling VBS
echo.
echo  ============================================
echo    SWITCHING TO GAMING MODE
echo  ============================================
echo.

echo  [1/4] Enabling Virtualization-Based Security...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v RequirePlatformSecurityFeatures /t REG_DWORD /d 1 /f >nul

echo  [2/4] Enabling Memory Integrity (HVCI)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 1 /f >nul

echo  [3/4] Restoring hibernation / Fast Startup...
powercfg /h on >nul 2>&1

echo  [4/4] Setting hypervisor launch type to AUTO...
bcdedit /set hypervisorlaunchtype auto >nul

echo.
echo  Done. Anti-cheat protected games will work after a restart.
echo  VirtualBox will be very slow in this mode.
echo.
echo  ============================================
echo    A FULL RESTART IS REQUIRED
echo  ============================================
echo.
set /p reboot="  Restart now? (Y/N): "
if /i "%reboot%"=="Y" (
    echo.
    echo  Restarting in 5 seconds...
    shutdown /r /t 5
) else (
    echo.
    echo  Remember to restart before launching your game.
    echo.
    pause
)
