#!/bin/bash
# Jan Brucek <jan@brucek.cz>, 2012

SCRIPTNAME=`basename $0`

if [[ $# -ne 1 ]]; then
    echo "# $SCRIPTNAME by Jan Brucek <jan@brucek.cz>, 2012"
    echo
    echo "Usage: $SCRIPTNAME [file_to_process]"
    echo "- Creates subtitle files in the same directory as the movie is in."
    echo "- Does not overwrite existing files."
    exit 64
fi

FILE=$1

if [[ ! -f "$FILE" ]]; then
    echo "! File does not exist"
    exit 127
fi

if [[ -n `which mkvextract` ]] && [[ -n `which mkvmerge` ]]; then
    SUBSFILE=`echo $1 | sed -E s/\.[A-Za-z0-9]{3}$//`
    SUBSTRACKS=`mkvmerge -i "$FILE" | grep "S_TEXT" | cut -d " " -f 3 | sed s/\://`
    echo $SUBSTRACKS | while read -r TRACKNO; do
        if [[ -n $TRACKNO ]]; then
            COUNTER=1
            TMPFILE=`mktemp -t $SCRIPTNAME`
            DSTFILE="$SUBSFILE.$TRACKNO.srt"
            while [[ -f "$DSTFILE" ]]; do
                DSTFILE="$SUBSFILE.$TRACKNO.$COUNTER.srt"
                COUNTER=$(($COUNTER+1))
            done
            mkvextract tracks "$FILE" -c UTF-8 $TRACKNO:"$DSTFILE"
        fi
    done
    exit 0
else
    echo "! Could not find mkvtoolnix tools"
    exit 127
fi
