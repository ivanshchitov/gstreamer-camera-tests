# gstreamer-camera-tests

Скрипты для тестирования стриминга потока с камеры с помощью GStreamer.

- [Скрипты для работы с RAW-данными](#скрипты-для-работы-с-raw-данными)
- [Скрипты для работы с данными H264](#скрипты-для-работы-с-данными-h264)
- [Скрипты для работы с JPEG-данными](#скрипты-для-работы-с-jpeg-данными)
- [Скрипты для работы с данными VP9](#скрипты-для-работы-с-данными-vp9)
- [Результаты экспериментов](#результаты-экспериментов)

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

### send-raw-with-rtpbin.sh

Отправляет RAW-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v rtpbin name=rtpbin autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! rtpvrawpay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-raw-with-rtpbin.sh

Принимает RAW-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)RAW,sampling=(string)YCbCr-4:2:2,width=(string)1280,height=(string)720,payload=(int)96,depth=(string)8" \
! .recv_rtp_sink_0 rtpbin ! rtpvrawdepay ! videoconvert ! autovideosink
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
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(string)96" \
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
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(string)96" \
! rtph264depay ! queue ! h264parse ! queue ! avdec_h264 ! queue ! autovideosink
```

### send-h264-with-rtpbin.sh

Отправляет H264-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v rtpbin name=rtpbin autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! x264enc tune=zerolatency threads=1 \
! rtph264pay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-h264-with-rtpbin.sh

Принимает H264-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(string)96" \
! .recv_rtp_sink_0 rtpbin ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```

## Скрипты для работы с JPEG-данными

### send-jpeg.sh

Отправляет JPEG-данные по сети.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! jpegenc quality=50 ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-jpeg.sh

Принимает JPEG-данные по сети.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=(int)26" \
! rtpjpegdepay ! jpegdec ! autovideosink
```

### send-jpeg-with-queue.sh

Отправляет JPEG-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! queue ! jpegenc quality=50 ! rtpjpegpay ! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-jpeg-with-queue.sh

Принимает JPEG-данные по сети, использует плагин `queue`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=(int)26" \
! rtpjpegdepay ! queue ! jpegdec ! queue ! autovideosink
```

### send-jpeg-with-rtpbin.sh

Отправляет JPEG-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v rtpbin name=rtpbin autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,height=720 \
! jpegenc quality=50 ! rtpjpegpay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-jpeg-with-rtpbin.sh

Принимает JPEG-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=(int)26" \
! .recv_rtp_sink_0 rtpbin ! rtpjpegdepay ! jpegdec ! autovideosink
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

### send-vp9-with-rtpbin.sh

Отправляет VP9-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v rtpbin name=rtpbin autovideosrc device=/dev/video0 \
! video/x-raw,width=1280,heigth=720 \
! videoconvert ! vp9enc ! rtpvp9pay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 \
! udpsink host=$IP_ADDRESS port=$PORT
```

### recv-vp9-with-rtpbin.sh

Принимает VP9-данные по сети, использует плагин `rtpbin`.
Команда:

```
gst-launch-1.0 -v udpsrc port=$PORT \
caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)VP9,payload=(int)96" \
! .recv_rtp_sink_0 rtpbin ! rtpvp9depay ! vp9dec ! autovideosink
```

## Результаты экспериментов

Для экспериментов использовались:
* MacBook Pro 2015, Intel Core i5 2.7 GHz.
* Эмулятора Sailfish OS версии 3.3.0.16, было выделено 2 ядра процессора.

Тип сетевого адаптера ВМ: Виртальный адаптер хоста.

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
|  **RAW**  |
| RAW | 190% | 80% | 80% | 20% | Картинка тормозит.<br/>Присутствуют артефакты. |
| RAW + `rtpbin` | 160% | 75% | 45% | 20% | Картинка тормозит.<br/>Присутствуют артефакты.<br/>Через ~5 секунд после запуска прием данных останавливается, хотя `gst-launch` запущен и не выдает ошибок. |
| RAW + `queue` | 150% | 90% | 75% | 20% | Картинка тормозит, но меньше, чем в остальных случаях с RAW.<br/>Присутствуют артефакты. |
|  **H264**  |
| H264 | 150% | 80% | 80% | 20% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 2-3 сек.<br/>Артефактов нет. |
| H264 + `rtpbin` | 160% | 85% | 100% | 20% |
| H264 + `queue` | 150% | 90% | 85% | 20% |
|  **JPEG**  |
| JPEG | 170% | 80% | 95% | 25% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 2-3 сек.<br/>Артефактов нет. |
| JPEG + `rtpbin` | 185% | 85% | 115% | 25% |
| JPEG + `queue` | 185% | 85% | 110% | 25% |
|  **VP9**  |
| VP9 | 15% | 300% | 10% | 5% | Картинка сильно тормозит. Интервал между кадрами ~4 секунды <br/>Артефактов нет.<br/> Особенность: Эмулятор выполняет отображение картинки, только, если прием на эмуляторе запущен раньше отправки на хосте.|
| VP9 + `rtpbin` | 15% | 310% | 10% | 5% | Картинка тормозит сильнее. |
| VP9 + `queue` | 15% | 300% | 10% | 5% |

