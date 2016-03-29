#!/bin/bash

BASE=$(dirname $0)

about() {
    cat <<EOF
Analyzes a video of a torch repeater and output statistics about the 
distributions of the length of sequences of ON and OFF frames.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       input video"
    echo "  -d       do not clean up image files"
    echo "  -v       verbose"
    exit
}

INPUT=
VERBOSE=
DO_NOT_CLEAN_UP=

while getopts "hi:dv" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
        d) DO_NOT_CLEAN_UP=1 ;;
        v) VERBOSE=1 ;;
    esac
done

if [[ ! -e $INPUT ]]; then
    echo "must specify valid input file"
    usage
fi

# temporary directory for video files
VIDEO_DIR=$(mktemp -d ./XXXXX)
if [[ $VERBOSE ]]; then
    echo "created temporary directory for video's image files: $VIDEO_DIR"
fi

# split the video
CMD="$BASE/split_video.sh -i $INPUT -o $VIDEO_DIR"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD

# compute the brightnesses
CMD="$BASE/brightness.sh -i $VIDEO_DIR"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD > brightnesses.csv

# cleanup
if [[ $DO_NOT_CLEAN_UP == "" ]]; then
    CMD="rm -rf $VIDEO_DIR"
    if [[ $VERBOSE ]]; then
        echo "running... $CMD"
    fi
    $CMD
fi

# clusterify
CMD="$BASE/cluster.sh -i brightnesses.csv -o clusters.csv"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD

# make the graph
CMD="$BASE/graph.sh -i clusters.csv -o graph.png"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD

# summarize
CMD="$BASE/summarize.sh -i clusters.csv"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD
