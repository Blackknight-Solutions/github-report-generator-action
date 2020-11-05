# $1 absolute commitDir

[[ -n "$DEBUG" ]] && set -x
echo "Convert Junit"
sourcePath="$1/raw"
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

if [ "$1" = "" ] || [ ! -d $1 ] || [ ! -d $sourcePath ]; then
    (>&2 echo "invalid parameter")
    exit 1;
fi

sourceFile=$(find "$sourcePath" -type f -name junit.xml | awk '{ print length, $0 }' | sort -n | cut -d" " -f2- | head -n 1)

if [ "$sourceFile" = "" ]; then
    echo "junit.xml file not found";
    exit 0;
fi

sourceFile=`realpath "$sourceFile"`
targetPath="$1/junit"
mkdir -p $targetPath

targetFile="$targetPath/index.html"
targetFile=`realpath $targetFile`

xunitViewer="$SCRIPTPATH/../node_modules/xunit-viewer/bin/xunit-viewer"

if [ "$targetFile" = "" ] || [ "$sourcePath" = "" ] || [ "$sourceFile" = "" ]; then
    exit 1;
fi

echo "SourceFile: $sourceFile"
echo "TargetFile: $targetFile"
echo "Convert: "
eval node $xunitViewer --results='$sourceFile' --output='$targetFile'
echo "End convert Junit"

echo "Create badge from Junit file"

targetFile="$targetPath/badge.svg"
numberOfFails=`cat "$sourceFile" | sed -rn 's/[^.]*failures="([0-9]+)".*/\1/p' | sed -n 1p`
numberOfTests=`cat "$sourceFile" | sed -rn 's/^.*tests="([0-9]+)".*/\1/p' | sed -n 1p`

echo "SourceFile: $sourceFile"
echo "TargetFile: $targetFile"
echo "Number of fails: $numberOfFails"
echo "Number of tests: $numberOfTests"

if [ $numberOfFails -gt 0 ]; then
    text="$numberOfFails / $numberOfTests failed"
    color="#e05d44"
else
    text="$numberOfTests successfull"
    color="#4c1"
fi

"$SCRIPTPATH/../badgen.sh" "tests ${2::8}" "$text" "" "$color" > "$targetFile"
echo "End create badge from Junit"
