#!/bin/bash

BASE=$(dirname $0)

about() {
    cat <<EOF
Produces a graph of brightness and cluster.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       clustered brightness file"
    echo "  -o       output file"
    exit
}

PLOT_FILE=$BASE/brightness.gnuplot.template

INPUT=
OUTPUT=

while getopts "hi:o:v" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
        o) OUTPUT=$OPTARG ;;
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

sed s/%INPUT%/$INPUT/g $PLOT_FILE | sed s/%OUTPUT%/$OUTPUT/g | gnuplot
