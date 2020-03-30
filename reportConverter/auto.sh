# $1 absolute commitDir
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

for f in $(find "$SCRIPTPATH" -maxdepth 1 -type f -name "*.sh"); do
    if [ $(basename $0) = $(basename $f) ]; then
        continue;
    fi
    echo `date "+%Y-%m-%d %H:%M:%S"` "RUN -> " $f $1
    bash $f $1
    echo `date "+%Y-%m-%d %H:%M:%S"` "FINISHED -> " $f $1
done

ls "$1"