@echo off & cls

set path=.\I386\out;%path%
set branching=EB 27
set code=55 73 65 72 33 32 2E 64 6C 6C 00 4D 65 73 73 61 67 65 42 6F 78 41 00 45 78 69 74 50 72 6F 63 65 73 73 00 E8 00 00 00 00 59 81 E9 28 00 00 00 51 E8 00 00 00 00 59 81 E9 3D 00 00 00 FF 11 E8 00 00 00 00 59 81 E9 38 00 00 00 51 50 E8 00 00 00 00 59 81 E9 55 00 00 00 FF 11 6A 00 6A 00 E8 00 00 00 00 59 81 E9 58 00 00 00 51 6A 00 FF D0 E8 00 00 00 00 59 81 E9 5D 00 00 00 51 E8 00 00 00 00 59 81 E9 8D 00 00 00 FF 31 E8 00 00 00 00 59 81 E9 93 00 00 00 FF 11 6A 00 FF D0 

start /min notepad.exe
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
cdb -pv -p %pid% -c "u $exentry;e $exentry %code%;u $exentry;r $ip=$exentry;.detach;q"
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