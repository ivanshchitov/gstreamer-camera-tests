#!/bin/bash
set -e

PORT=3434

fail() {
    echo "FAIL: $@"
    exit 1
}

usage() {
    cat <<EOF

Receive the VP9 video data from the port.
This script uses the 'queue' plugin.
This script can be runned only if the device has installed 'avdec_h264' plugin. 

Command:
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,encoding-name=H264,payload=96" \
! rtph264depay ! queue ! h264parse ! queue ! avdec_h264 ! queue ! autovideosink

Usage:
   $(basename $0) [OPTION]

Options:
   -p    | --port <PORT>    Port to receive video data [$PORT]
   -h    | --help           this help

EOF
    # exit if any argument is given
    [[ -n "$1" ]] && exit 1
}

# handle commandline options
while [[ ${1:-} ]]; do
    case "$1" in
        -p | --port )
            shift
            PORT=$1; shift
            ;;
        -h | --help )
            shift
            usage quit
            ;;
        * )
            usage quit
            ;;
    esac
done

gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,encoding-name=H264,payload=96" \
! rtph264depay ! queue ! h264parse ! queue ! avdec_h264 ! queue ! autovideosink
