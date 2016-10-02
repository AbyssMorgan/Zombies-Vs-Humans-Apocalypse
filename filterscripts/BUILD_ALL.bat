@ECHO OFF
SET i=0
SET c=0
COLOR 9F
ECHO Starting sequence...

CD .
FOR /F "tokens=*" %%G IN ('DIR /B /A "*.pwn"') DO (
	ECHO Building %%G
	..\pawno\pawncc.exe %%G  -(+ -;+ -r
	CALL :MOV "%%G"
	CALL :AAA
)
ECHO Sequence completed!
ECHO Compiled %c%/%i% script
TITLE Compiled %c%/%i% script
pause
GOTO :eof

:AAA
SET /A i=%i%+1
GOTO :eof

:BBB
SET /A c=%c%+1
GOTO :eof

:MOV
IF EXIST "%~n1.amx" CALL :BBB
IF EXIST "%~n1.xml" DEL /Q /A "%~n1.xml"
GOTO :eof