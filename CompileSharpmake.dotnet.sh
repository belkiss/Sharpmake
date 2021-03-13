#!/usr/bin/env bash
# Script arguments:
# $1: Project/Solution to build
# $2: Target(Normally should be Debug or Release)
# $3: Platform(Normally should be "Any CPU" for sln and AnyCPU for a csproj)
# if none are passed, defaults to building Sharpmake.sln in Debug|Any CPU

function BuildSharpmake {
    solutionPath=$1
    configuration=$2
    platform=$3
    echo Compiling $solutionPath in "${configuration}|${platform}"...

    BUILD_CMD="dotnet build \"$solutionPath\" -v m -nologo -c \"$configuration\""

    echo $BUILD_CMD
    eval $BUILD_CMD
    if [ $? -ne 0 ]; then
        echo ERROR: Failed to compile $solutionPath in "${configuration}|${platform}".
        exit 1
    fi
}

# fail immediately if anything goes wrong
set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

which dotnet > /dev/null
DOTNET_FOUND=$?
if [ $DOTNET_FOUND -ne 0 ]; then
    echo "dotnet not found, see https://dotnet.microsoft.com/download"
    exit $DOTNET_FOUND
fi

SOLUTION_PATH=${1:-"Sharpmake.sln"}
CONFIGURATION=${2:-"Debug"}
PLATFORM=${3:-"Any CPU"}

BuildSharpmake "$SOLUTION_PATH" "$CONFIGURATION" "$PLATFORM"
