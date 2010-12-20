@REM ==================================================
@REM
@REM                  CleanProjectDir
@REM
@REM   This script recursively cleans the project's
@REM   directory from misc unnecessary files that
@REM   should never be committed to CVS.
@REM
@REM   © 2010 by Xcentric
@REM ==================================================

@echo Press any key to start cleaning in the project's directory!
@pause > NUL
@echo off

REM Deleting unnecessary files:
del /F /S /Q *.bak
del /F /S /Q *.dcu
del /F /S /Q *.ddp
del /F /S /Q *.pdb
del /F /S /Q *.~pas
del /F /S /Q *.~dfm
del /F /S /Q *.~ddp
del /F /S /Q *.~dpr
del /F /S /Q *.local
del /F /S /Q *.tvsconfig
del /F /S /Q *.identcache

REM Delete or not history files?
@echo Do you want to delete all history files from "__history" folders? [Y/N]
set /P Choice=
set Yes=Y
if /I %Choice% == %Yes% (
  del /F /S /Q *.~*~
  start rmhist.exe
)