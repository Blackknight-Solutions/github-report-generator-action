# $1 absolute commitDir

[[ -n "$DEBUG" ]] && set -x
echo "Convert node-lcov"
sourcePath="$1/raw"
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
targetPath="$1/node-lcov"

if [ "$1" = "" ] || [ ! -d $1 ] || [ ! -d $sourcePath ]; then
    (>&2 echo "invalid parameter")
    exit 1;
fi

sourceFile=$(find "$sourcePath" -type f -name node-lcov.zip | awk '{ print length, $0 }' | sort -n | cut -d" " -f2- | head -n 1)

if [ "$sourcePath" = "" ] || [ "$sourceFile" = "" ]; then
    sourceDirectory=$(find "$sourcePath" -type d -name "lcov-report" | awk '{ print length, $0 }' | sort -n | cut -d" " -f2- | head -n 1)
    if [ "$sourcePath" = "" ] || [ "$sourceDirectory" = "" ]; then
        echo "node-lcov.zip file or lcov-report directory not found";
        exit 0;
    fi
    cp -r "$sourceDirectory" "$targetPath"
else
    sourceFile=`realpath "$sourceFile"`
    
    mkdir -p $targetPath
    
    echo "SourceFile: $sourceFile"
    echo "TargetPath: $targetPath"
    
    echo "Extract zip"
    unzip "$sourceFile" -d "$targetPath"
    echo "Extract end"
fi


echo "Create coverage badge"
indexFile="$targetPath/index.html"

if [ -d $indexFile ]; then
    coverage="ERROR";
else
    coverage=`cat "$indexFile" | sed -rn 's/<span class="strong">([0-9]+\.?[0-9]+)% <\/span>/\1/p' | sed -n 1p | sed -r 's/^ +//'`
fi

decimalCoverage=`echo "$coverage" | sed -rn 's/([0-9]+)[\.[0-9]*]?/\1/p'`

if [ "$coverage" = "ERROR" ] || [ $decimalCoverage -lt 75 ]
then
    color='#e05d44'
elif [ $decimalCoverage -lt 90 ]
then
    color='#dfb317'
else
    color='#4c1'
fi


"$SCRIPTPATH/../badgen.sh" "coverage ${2::8}" "$coverage %" "" "$color" > "$targetPath/badge.svg"
echo "Created coverage badge"
echo "End node-lcov"
