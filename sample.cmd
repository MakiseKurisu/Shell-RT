@echo off & cls

set branching=EB 1C
set code=4D 65 73 73 61 67 65 42 6F 78 41 00 68 00 00 00 00 FF 35 00 00 00 00 FF 15 00 00 00 00 6A 00 6A 00 68 00 00 00 00 6A 00 FF D0 FF 15 00 00 

start /min notepad.exe
for /F "tokens=2" %%b in ('tasklist /FI "IMAGENAME eq notepad.exe" /NH') do set pid=%%b
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;lm m kernel32;.detach;q" ^| findstr "KERNEL32"') do call :Convert %%p
set branching=%branching% %RETURN%
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;x kernel32!loadlibrarya;.detach;q" ^| findstr "KERNEL32!LoadLibraryA"') do call :Convert %%p
set branching=%branching% %RETURN%
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;x kernel32!getprocaddress;.detach;q" ^| findstr "KERNEL32!GetProcAddress"') do call :Convert %%p
set branching=%branching% %RETURN%
for /F %%p IN ('cdb -pvr -p %pid% -c ".symfix;.reload;x kernel32!exitprocess;.detach;q" ^| findstr "KERNEL32!ExitProcess"') do call :Convert %%p
set branching=%branching% %RETURN%

set code=%branching% %code%
cdb -pv -p %pid% -c "u $exentry;e $exentry %code%;u $exentry;r $ip=$exentry;.detach;q"
pause

taskkill /pid %pid% >nul

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