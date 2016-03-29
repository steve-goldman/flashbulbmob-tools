#!/bin/bash

about() {
    cat <<EOF
Splits a video file into one image file per frame.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       input video"
    echo "  -o       output directory"
    echo "  -v       verbose"
    exit
}

INPUT=
OUTPUT=
VERBOSE=

while getopts "hi:o:v" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
        o) OUTPUT=$OPTARG ;;
        v) VERBOSE=1 ;;
    esac
done

if [[ ! -e $INPUT ]]; then
    echo "must specify valid input file"
    usage
fi

if [[ ! -d $OUTPUT ]]; then
    echo "must specify output directory"
    usage
fi

LOGLEVEL="-loglevel panic"
if [[ $VERBOSE ]]; then
    LOGLEVEL=""
fi

CMD="ffmpeg $LOGLEVEL -i $INPUT $OUTPUT/image-%07d.png"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD
