#!/bin/bash

about() {
    cat <<EOF
Transforms a single column of data into two clusters, based on centroids.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       input file"
    echo "  -o       output file"
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

if [[ $OUTPUT == "" ]]; then
    echo "must specify output file"
    usage
fi

CMD="mlpack_kmeans -c 2 -i $INPUT -o $OUTPUT"
if [[ $VERBOSE ]]; then
    echo "running... $CMD"
fi
$CMD
