#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${DIR}/defaults.sh"

usage() {
    cat <<EOF

Send the RAW video data from camera by the IP-address and port.
This script uses the 'rtpbin' plugin.

Command:
gst-launch-1.0 -v rtpbin name=rtpbin autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! rtpvrawpay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT

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

gst-launch-1.0 -v rtpbin name=rtpbin $VIDEO_SOURCE \
! $RAW_VIDEO_PARAMS \
! videoconvert ! rtpvrawpay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT
