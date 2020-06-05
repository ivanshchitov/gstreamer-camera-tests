#!/bin/bash
set -e

IP_ADDRESS=127.0.0.1
PORT=3434

fail() {
    echo "FAIL: $@"
    exit 1
}

usage() {
    cat <<EOF

Send the motion JPEG video data from camera by the IP-address and port.
This script uses the 'queue' plugin.

Command:
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! queue ! jpegenc quality=50 ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT

Usage:
   $(basename $0) [OPTION]

Options:
   -i    | --ip-address <IP_ADDRESS>   IP-address to send video data [$IP_ADDRESS]
   -p    | --port <PORT>               Port to send video data [$PORT]
   -h    | --help                      this help

EOF
    # exit if any argument is given
    [[ -n "$1" ]] && exit 1
}

# handle commandline options
while [[ ${1:-} ]]; do
    case "$1" in
        -i | --ip-address )
            shift
            IP_ADDRESS=$1; shift
            ;;
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

gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! queue ! jpegenc quality=50 ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT
