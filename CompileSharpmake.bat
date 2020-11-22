@echo off
:: Batch arguments:
:: %~1: Project/Solution to build
:: %~2: Target(Normally should be Debug or Release)
:: %~3: Platform(Normally should be "Any CPU" for sln and AnyCPU for a csproj)
:: if none are passed, defaults to building Sharpmake.sln in Debug|AnyCPU

setlocal enabledelayedexpansion
: set batch file directory as current
pushd "%~dp0"

if "%~1" == "" (
    call :BuildSharpmake "Sharpmake.sln" "Debug" "Any CPU"
) else (
    call :BuildSharpmake %1 %2 %3
)
goto end

:: Build Sharpmake using specified arguments
:BuildSharpmake
echo Compiling %~1 in "%~2|%~3"...

set BUILD_CMD=dotnet build "%~1" -v m -nologo -c "%~2" /p:Platform="%~3"
echo %BUILD_CMD%
%BUILD_CMD%
if %errorlevel% NEQ 0 (
    echo ERROR: Failed to compile %~1 in "%~2|%~3".
    exit /b 1
)
exit /b 0

:: End of batch file
:end
popd
