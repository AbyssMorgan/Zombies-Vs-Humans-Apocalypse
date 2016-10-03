@ECHO OFF
COLOR 9F
TITLE PawnCompiler
ECHO.
..\pawno\pawncc.exe "%CD%\zombie2.pwn" -i"..\pawno\include" -(+ -;+
ECHO.
ECHO Compilation end
ECHO.
PAUSE > nul