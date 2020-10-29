# $1 absolute output directory
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

[[ -n "$DEBUG" ]] && set -x || true
set -e
echo "Files in report raw directory"
ls -R "$1/raw"
echo " "

for f in $(find "$SCRIPTPATH" -maxdepth 1 -type f -name "*.sh"); do
    if [ $(basename $0) = $(basename $f) ]; then
        continue;
    fi
    echo `date "+%Y-%m-%d %H:%M:%S"` "RUN -> $f $1"
    echo " "
    bash "$f" "$1"
    echo " "
    echo `date "+%Y-%m-%d %H:%M:%S"` "FINISHED -> $f $1"
    echo " "
done

echo "Files in report output directory"
ls "$1"
echo " "