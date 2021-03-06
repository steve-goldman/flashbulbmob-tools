#!/bin/bash

about() {
    cat <<EOF
Statistics for sequences of ON and OFF frames.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       clustered brightness file"
    exit
}

INPUT=

while getopts "hi:v" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
    esac
done

if [[ ! -e $INPUT ]]; then
    echo "must specify valid input file"
    usage
fi

echo "ON"
cut -d, -f2 $INPUT | uniq -c | sed '1d;$d' | egrep '1\.0' | awk '{print $1}' | st
echo
echo "OFF"
cut -d, -f2 $INPUT | uniq -c | sed '1d;$d' | egrep '0\.0' | awk '{print $1}' | st
