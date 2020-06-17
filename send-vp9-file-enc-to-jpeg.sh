#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${DIR}/defaults.sh"

usage() {
    cat <<EOF

Send the VP9 encoded video data from file by the IP-address and port.

Command:
gst-launch-1.0 -v filesrc location=$VIDEO_FILE \
! typefind ! matroskademux ! jpegenc quality=50 ! rtpjpegpay \
! udpsink host=$IP_ADDRESS port=$PORT

Usage:
   $(basename $0) [OPTION]

Options:
   -f    | --file <VIDEO_FILE>         Video file H264 encoded to send data [$VIDEO_FILE]
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
        -f | --file )
            shift
            VIDEO_FILE=$1; shift
            ;;
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

gst-launch-1.0 -v filesrc location=$VIDEO_FILE \
! typefind ! matroskademux ! vp9dec ! jpegenc quality=50 ! rtpjpegpay \
! udpsink host=$IP_ADDRESS port=$PORT
