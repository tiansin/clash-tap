@echo off
setlocal

set DEVICE_NAME=clash-tap

set PATH=%PATH%;%SystemRoot%\system32;%SystemRoot%\system32\wbem;%SystemRoot%\system32\WindowsPowerShell/v1.0

taskkill /f /im clash.exe /t
taskkill /f /im tun2socks.exe /t

netsh interface ip delete route 0.0.0.0/0 %DEVICE_NAME%
netsh interface ipv6 delete route ::/0 %DEVICE_NAME%
for /f "skip=3 tokens=4" %%a in ('netsh interface show interface') do (
  netsh interface ip set dnsservers %%a dhcp validate=no
  netsh interface ipv6 set dnsservers %%a dhcp validate=no
)
ipconfig /flushdns
