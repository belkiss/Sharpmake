#!/usr/bin/env bash
# Script arguments:
# %1: Main sharpmake file
# $2: Target(Normally should be Debug or Release)
# if arguments are omitted, defaults to Sharpmake.Main.sharpmake.cs and Debug

function success {
	echo Bootstrap succeeded \!
	exit 0
}

function error {
	echo Bootstrap failed \!
	exit 1
}

# fail immediately if anything goes wrong
set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SHARPMAKE_MAIN="${1:-"$CURRENT_DIR/Sharpmake.Main.sharpmake.cs"}"

which dotnet > /dev/null
DOTNET_FOUND=$?
if [ $DOTNET_FOUND -ne 0 ]; then
    echo "dotnet not found, see https://dotnet.microsoft.com/download"
    error
fi

SHARPMAKE_OPTIM=${2:-"debug"}

echo "Build and run sharpmake in $SHARPMAKE_OPTIM..."

SM_CMD_RUN="dotnet run --verbosity m --project Sharpmake.Application/Sharpmake.Application.csproj --configuration $SHARPMAKE_OPTIM /sources\(\'${SHARPMAKE_MAIN}\'\) /verbose"
echo $SM_CMD_RUN
eval $SM_CMD_RUN
if [ $? -ne 0 ]; then
    echo "DotNet run failed, trying to fallback to the old way..."
    $CURRENT_DIR/CompileSharpmake.sh $CURRENT_DIR/Sharpmake.Application/Sharpmake.Application.csproj $SHARPMAKE_OPTIM AnyCPU
    if [ $? -ne 0 ]; then
        error
    fi

    SHARPMAKE_EXECUTABLE=$CURRENT_DIR/tmp/bin/$SHARPMAKE_OPTIM/Sharpmake.Application.exe

    which mono > /dev/null
    MONO_FOUND=$?
    if [ $MONO_FOUND -ne 0 ]; then
        echo "Mono not found"
        error
    fi

    echo "Generating Sharpmake solution..."
    SM_CMD_LEGACY="mono --debug \"${SHARPMAKE_EXECUTABLE}\" \"/sources('${SHARPMAKE_MAIN}') /verbose\""
    echo $SM_CMD_LEGACY
    eval $SM_CMD_LEGACY || error
fi

success
