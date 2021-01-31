#!/usr/bin/env bash

function success {
	echo Bootstrap succeeded \!
	exit 0
}

function error {
	echo Bootstrap failed \!
	exit 1
}

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SHARPMAKE_MAIN="${1:-"$CURRENT_DIR/Sharpmake.Main.sharpmake.cs"}"

which dotnet > /dev/null
DOTNET_FOUND=$?
if [ $DOTNET_FOUND -ne 0 ]; then
    echo "dotnet not found, see https://dotnet.microsoft.com/download"
    error
fi

echo "Build and run sharpmake..."

SM_CMD_RUN="dotnet run --verbosity m --project Sharpmake.Application/Sharpmake.Application.csproj --configuration Debug /sources\(\'${SHARPMAKE_MAIN}\'\) /verbose"
echo $SM_CMD_RUN
eval $SM_CMD_RUN
if [ $? -ne 0 ]; then
    echo "DotNet run failed, trying to fallback to the old way..."
    $CURRENT_DIR/CompileSharpmake.sh $CURRENT_DIR/Sharpmake.Application/Sharpmake.Application.csproj Debug AnyCPU
    if [ $? -ne 0 ]; then
        error
    fi

    SHARPMAKE_EXECUTABLE=$CURRENT_DIR/tmp/bin/Debug/Sharpmake.Application.exe

    echo "Generating Sharpmake solution..."
    SM_CMD_LEGACY="mono --debug \"${SHARPMAKE_EXECUTABLE}\" /sources\(\'${SHARPMAKE_MAIN}\'\) /verbose"
    echo $SM_CMD_LEGACY
    eval $SM_CMD_LEGACY || error
fi

success
