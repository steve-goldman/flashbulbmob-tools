#!/bin/bash

BASE=$(dirname $0)

about() {
    cat <<EOF
Outputs FPS for the input video file.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       input video"
    exit
}

INPUT=
VERBOSE=

while getopts "hi:" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
    esac
done

if [[ ! -e $INPUT ]]; then
    echo "must specify valid input file"
    usage
fi

ffmpeg -i $INPUT 2>&1 | grep fp | cut -d' ' -f21
