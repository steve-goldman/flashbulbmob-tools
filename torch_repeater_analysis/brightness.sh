#!/bin/bash

about() {
    cat <<EOF
Computes the average brightness of an image file or a directory of image files.

EOF
    usage
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h       help"
    echo "  -i       input image or directory of images"
    echo "  -v       verbose"
    exit
}

INPUT=
VERBOSE=

while getopts "hi:v" OPT; do
    case $OPT in
        h) about ;;
        i) INPUT=$OPTARG ;;
        v) VERBOSE=true ;;
    esac
done

if [[ ! -e $INPUT ]]; then
    echo "must specify valid input file"
    usage
fi

image_brightness() {
    CMD="convert $1 -colorspace Gray -format %[fx:image.mean] info:"
    if [[ $VERBOSE ]]; then
        echo "running... $CMD"
    fi
    echo $($CMD)
}

if [[ -d $INPUT ]]; then
    for FILE in $(ls $INPUT); do
        image_brightness "$INPUT/$FILE"
    done
else
    image_brightness $INPUT
fi
 
