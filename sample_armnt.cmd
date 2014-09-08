@echo off

pushd	"%~dp0"
set ARM_ADDR_OFFSET=-1
set path=.\ARMNT\out;%path%
set branching=18 E0 00 00
set code=55 73 65 72 33 32 2E 64 6C 6C 00 4D 65 73 73 61 67 65 42 6F 78 41 00 45 78 69 74 50 72 6F 63 65 73 73 00 00 0B 48 FF F7 E8 EF 00 46 0A 49 FF F7 E6 EF 04 46 4F F0 00 00 01 46 07 4A 03 46 A0 47 06 48 00 68 06 49 FF F7 DA EF 01 46 4F F0 00 00 88 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 

start /min /d "%~dp0" notepad.exe
for /F "tokens=2" %%b in ('tasklist /FI "IMAGENAME eq notepad.exe" /NH') do set pid=%%b

::cdb -pvr -p %pid% -c ".symfix;.reload;lm m kernel32;.detach;q"
::pause
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;lm m kernel32;.detach;q" ^| findstr "KERNEL32"') do call :Convert %%p
set branching=%branching% %RETURN%

::cdb -pvr -p %pid% -c ".symfix;.reload;x kernel32!loadlibrarya;.detach;q"
::pause
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;x kernel32!loadlibrarya;.detach;q" ^| findstr "KERNEL32!LoadLibraryA"') do call :Convert %%p
set branching=%branching% %RETURN%

::cdb -pvr -p %pid% -c ".symfix;.reload;x kernelbase!getprocaddress;.detach;q"
::pause
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;x kernelbase!getprocaddress;.detach;q" ^| findstr "KERNELBASE!GetProcAddress"') do call :Convert %%p
set branching=%branching% %RETURN%

set code=%branching% %code%
cdb -pv -p %pid% -c "u $exentry;e $exentry%ARM_ADDR_OFFSET% %code%;u $exentry;r $ip=$exentry;.detach;q"
pause

taskkill /pid %pid% >nul 2>nul

goto :eof

:Convert
set temp=%1
set temp2=
:LittleEndian
if not "%temp:~2,1%" == "" (
	set temp2=%temp:~0,2% %temp2%
	set temp=%temp:~2%
	goto LittleEndian
	) else (
	set temp=%temp:~0,2% %temp2%
	)
set RETURN=%temp%
goto :eof