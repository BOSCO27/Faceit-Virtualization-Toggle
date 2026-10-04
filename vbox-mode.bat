@echo off
REM ============================================================
REM  VBOX MODE  -  Turns OFF the Windows hypervisor / VBS
REM  Use this when you want to run VirtualBox at full speed.
REM  Anti-cheat (FACEIT, Vanguard, etc.) will NOT work after this.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

title VirtualBox Mode - Disabling VBS
echo.
echo  ============================================
echo    SWITCHING TO VIRTUALBOX MODE
echo  ============================================
echo.

echo  [1/4] Disabling Virtualization-Based Security...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v RequirePlatformSecurityFeatures /t REG_DWORD /d 0 /f >nul

echo  [2/4] Disabling Memory Integrity (HVCI)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f >nul

echo  [3/4] Disabling Credential Guard...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 0 /f >nul

echo  [4/4] Setting hypervisor launch type to OFF...
bcdedit /set hypervisorlaunchtype off >nul

echo.
echo  Done. VirtualBox will run at full speed after a restart.
echo  Anti-cheat protected games will NOT launch in this mode.
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
    echo  Remember to restart before starting VirtualBox.
    echo.
    pause
)
