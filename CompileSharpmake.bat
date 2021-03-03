@echo off
:: Batch arguments:
:: %~1: Project/Solution to build
:: %~2: Target(Normally should be Debug or Release)
:: %~3: Platform(Normally should be "Any CPU" for sln and AnyCPU for a csproj)
:: if none are passed, defaults to building Sharpmake.sln in Debug|AnyCPU

setlocal enabledelayedexpansion

:: Clear previous run status
COLOR

: set batch file directory as current
pushd "%~dp0"

set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist %VSWHERE% (
    echo ERROR: Cannot determine the location of the vswhere command Common Tools folder.
    goto error
)

set VSMSBUILDCMD=
for /f "usebackq delims=" %%i in (`%VSWHERE% -latest -products * -property installationPath`) do (
  if exist "%%i\Common7\Tools\VsMSBuildCmd.bat" (
    set VSMSBUILDCMD="%%i\Common7\Tools\VsMSBuildCmd.bat"
  )
)

if not defined VSMSBUILDCMD (
    echo ERROR: Cannot determine the location of Common Tools folder.
    goto error
)

echo MSBuild batch path: !VSMSBUILDCMD!
call !VSMSBUILDCMD!
if %errorlevel% NEQ 0 goto error

if "%~1" == "" (
    call :BuildSharpmakeDotnet "Sharpmake.sln" "Debug" "Any CPU"
) else (
    call :BuildSharpmakeDotnet %1 %2 %3
)

if %errorlevel% EQU 0 goto success

echo Compilation with dotnet failed, falling back to the old way using MSBuild

if "%~1" == "" (
    call :BuildSharpmakeMSBuild "Sharpmake.sln" "Debug" "Any CPU"
) else (
    call :BuildSharpmakeMSBuild %1 %2 %3
)

if %errorlevel% NEQ 0 goto error

goto success

@REM -----------------------------------------------------------------------
:: Build Sharpmake with dotnet using specified arguments
:BuildSharpmakeDotnet
echo Compiling %~1 in "%~2|%~3"...

set DOTNET_BUILD_CMD=dotnet build "%~1" -nologo -v m -c "%~2"
echo %DOTNET_BUILD_CMD%
%DOTNET_BUILD_CMD%
set ERROR_CODE=%errorlevel%
if %ERROR_CODE% NEQ 0 (
    echo ERROR: Failed to compile %~1 in "%~2|%~3".
    goto end
)
goto success

@REM -----------------------------------------------------------------------
:: Build Sharpmake with MSBuild using specified arguments
:BuildSharpmakeMSBuild
echo Compiling %~1 in "%~2|%~3"...

set MSBUILD_CMD=msbuild -t:build -restore "%~1" /nologo /verbosity:m /p:Configuration="%~2" /p:Platform="%~3"
echo %MSBUILD_CMD%
%MSBUILD_CMD%
set ERROR_CODE=%errorlevel%
if %ERROR_CODE% NEQ 0 (
    echo ERROR: Failed to compile %~1 in "%~2|%~3".
    goto end
)
goto success

@REM -----------------------------------------------------------------------
:success
COLOR 2F
set ERROR_CODE=0
goto end

@REM -----------------------------------------------------------------------
:error
COLOR 4F
set ERROR_CODE=1
goto end

@REM -----------------------------------------------------------------------
:end
:: restore caller current directory
popd
exit /b %ERROR_CODE%
