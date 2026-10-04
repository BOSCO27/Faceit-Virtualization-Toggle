@echo off
REM ============================================================
REM  CHECK MODE  -  Reports whether the hypervisor is running.
REM  Safe to run any time. Changes nothing.
REM ============================================================

title Virtualization Mode Check
echo.
echo  ============================================
echo    CURRENT VIRTUALIZATION STATE
echo  ============================================
echo.

powershell -NoProfile -Command ^
  "$hv = (Get-ComputerInfo -Property HyperVisorPresent).HyperVisorPresent;" ^
  "$dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction SilentlyContinue;" ^
  "$vbs = if ($dg) { $dg.VirtualizationBasedSecurityStatus } else { 'unknown' };" ^
  "Write-Host ('  Hypervisor present : ' + $hv);" ^
  "Write-Host ('  VBS status         : ' + $vbs + '   (0 = off, 2 = running)');" ^
  "Write-Host '';" ^
  "if ($hv -eq $false) {" ^
  "  Write-Host '  MODE: VIRTUALBOX' -ForegroundColor Green;" ^
  "  Write-Host '  VirtualBox runs at full speed. Anti-cheat games will not launch.'" ^
  "} else {" ^
  "  Write-Host '  MODE: GAMING' -ForegroundColor Cyan;" ^
  "  Write-Host '  Anti-cheat games work. VirtualBox will be very slow.'" ^
  "}"

echo.
echo  ============================================
echo.
pause
