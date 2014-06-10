#!/bin/bash
# Jan Brucek <jan@brucek.se>, 2014

SCRIPTNAME=`basename $0`

if [[ $# -ne 2 ]]; then
    echo "# $SCRIPTNAME by Jan Brucek <jan@brucek.se>, 2014"
    echo
    echo "Usage: $SCRIPTNAME [video_file] [subtitles_file]"
    echo "- Creates a new video file in a directory that you run the script"
    exit 64
fi

VIDEOFILE=$1
SUBTITLEFILE=$2

if [[ ! -f "$VIDEOFILE" ]]; then
    echo "! Video file does not exist"
    exit 127
fi

if [[ ! -f "$SUBTITLEFILE" ]]; then
    echo "! Subtitles file does not exist"
    exit 127
fi

if [[ -n `which mkvmerge` ]]; then
    VIDEOFILENAME=$(basename "$VIDEOFILE")
    EXTENSION="${VIDEOFILENAME##*.}"
    FILENAME="${VIDEOFILENAME%.*}"
    mkvmerge -o $FILENAME"-subtitled."$EXTENSION $VIDEOFILE --track-name "0:Subtitles" -s 0 -D -A $SUBTITLEFILE
    exit 0
else
    echo "! Could not find mkvtoolnix tools"
    exit 127
fi
