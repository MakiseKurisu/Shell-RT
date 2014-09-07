@echo	off

echo	Please select the targetting platform:
echo	1. I386
echo	2. AMD64
echo	3. ARMNT
choice	/c 123

if %ERRORLEVEL% == 1 call :Environment I386
if %ERRORLEVEL% == 2 call :Environment AMD64
if %ERRORLEVEL% == 3 call :Environment ARMNT
echo.

set	/p filename=Please enter the file name (without the extension name .asm):
if "%filename%" == "" (
	echo Using the default file name.
	echo.
	set filename=%default_filename%
	)

:Compile
%assembler% %filename%.asm
if ERRORLEVEL 1 goto CleanUp

dumpbin /nologo /rawdata:1,128 /out:%filename%.txt %filename%.obj
link /subsystem:windows %filename%.obj
del	%filename%.obj

:CleanUp
pause
goto	Compile

goto	:eof

:Environment
set	path=.\%1\bin;%path%
set	default_filename=%1

if	"%1" == "I386"	(
	set	assembler=ml /nologo /c
	)
if	"%1" == "AMD64"	(
	set	assembler=ml64 /nologo /c
	)
if	"%1" == "ARMNT"	(
	set	assembler=armasm -nologo
	)
goto	:eof