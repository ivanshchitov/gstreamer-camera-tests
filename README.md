# gstreamer-camera-tests

Скрипты для тестирования стриминга потока с камеры с помощью GStreamer.

## Скрипты для работы с RAW-данными

### send-raw.sh

Отправляет RAW-данные по сети.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! rtpvrawpay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-raw.sh

Принимает RAW-данные по сети.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,encoding-name=(string)RAW,sampling=(string)YCbCr-4:2:2,width=(string)1280,height=(string)720,payload=(int)96" \
! rtpvrawdepay ! videoconvert ! autovideosink
```

### send-raw-with-queue.sh

Отправляет RAW-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! queue ! rtpvrawpay ! queue ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-raw-with-queue.sh

Принимает RAW-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,encoding-name=(string)RAW,sampling=(string)YCbCr-4:2:2,width=(string)1280,height=(string)720,payload=(int)96" \
! rtpvrawdepay ! queue ! videoconvert ! queue ! autovideosink
```

## Скрипты для работы с данными H264

### send-h264.sh

Отправляет H264-данные по сети.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! x264enc tune=zerolatency threads=1 \
! rtph264pay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-h264.sh

Принимает H264-данные по сети.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,encoding-name=H264,payload=96" \
! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```

### send-h264-with-queue.sh

Отправляет H264-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! x264enc tune=zerolatency threads=1 \
! queue ! rtph264pay ! queue ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-h264-with-queue.sh

Принимает H264-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,encoding-name=H264,payload=96" \
! rtph264depay ! queue ! h264parse ! queue ! avdec_h264 ! queue ! autovideosink
```

## Скрипты для работы с JPEG-данными

### send-jpeg.sh

Отправляет JPEG-данные по сети.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! jpegenc ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-jpeg.sh

Принимает JPEG-данные по сети.
Команда:

```
gst-launch-1.0 -v udpsrc port=3434 \
caps="application/x-rtp,encoding-name=JPEG,payload=26" \
! rtpjpegdepay ! jpegdec ! autovideosink
```

### send-jpeg-with-queue.sh

Отправляет JPEG-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! queue ! jpegenc ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-jpeg-with-queue.sh

Принимает JPEG-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,encoding-name=JPEG,payload=26" \
! rtpjpegdepay ! queue ! jpegdec ! queue ! autovideosink
```

## Скрипты для работы с данными VP9

### send-vp9.sh

Отправляет VP9-данные по сети.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! vp9enc ! rtpvp9pay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-vp9.sh

Принимает VP9-данные по сети.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,encoding-name=(string)VP9,payload=(int)96" \
! rtpvp9depay ! vp9dec ! autovideosink
```

### send-vp9-with-queue.sh

Отправляет VP9-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! queue ! vp9enc ! queue \
! rtpvp9pay ! queue ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-vp9-with-queue.sh

Принимает VP9-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,encoding-name=(string)VP9,payload=(int)96" \
! rtpvp9depay ! queue ! vp9dec ! queue ! autovideosink
```
