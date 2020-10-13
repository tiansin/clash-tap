@echo off
setlocal

set DEVICE_NAME=clash-tap

set PATH=%PATH%;%SystemRoot%\system32;%SystemRoot%\system32\wbem;%SystemRoot%\system32\WindowsPowerShell/v1.0

call clash.vbs
call tun2socks.vbs

netsh interface ip add route 0.0.0.0/0 %DEVICE_NAME% 10.0.0.1 metric=0 store=active
netsh interface ipv6 add route ::/0 %DEVICE_NAME% fdfe:dcba:9876::1 metric=0 store=active
for /f "skip=3 tokens=4" %%a in ('netsh interface show interface') do (
  netsh interface ip set dnsservers %%a static 10.0.0.2 validate=no
  netsh interface ipv6 set dnsservers %%a static fdfe:dcba:9876::2 validate=no
)
ipconfig /flushdns
