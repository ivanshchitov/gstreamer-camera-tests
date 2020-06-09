# This file is meant to be used by other scripts to reduce duplication in constants

IP_ADDRESS=127.0.0.1
PORT=3434
VIDEO_SOURCE=autovideosrc device=/dev/video0
RAW_VIDEO_PARAMS=video/x-raw,width=1280,heigth=720
RAW_CAPS=application/x-rtp,media=(string)video,encoding-name=(string)RAW,sampling=(string)YCbCr-4:2:2,width=(string)1280,height=(string)720,payload=(int)96

# Put overrides into default_override.sh file

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [[ -f "${DIR}/defaults_override.sh" ]]; then
    . "${DIR}/defaults_override.sh"
fi
