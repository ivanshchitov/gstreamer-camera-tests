# gstreamer-camera-tests

Скрипты для тестирования стриминга потока с камеры с помощью GStreamer.

## Результаты экспериментов

Для экспериментов использовались:
* MacBook Pro 2015, Intel Core i5 2.7 GHz, 2 физических ядра, 4 логических.
* MacOS 10.13.6 High Sierra.
* VirtualBox 6.0.10.
* Эмулятор Sailfish OS версии 3.3.0.16, было выделено 2 ядра процессора.

### Тип сетевого адаптера ВМ: Виртальный адаптер хоста

#### Эксперименты с выводом изображения (`autovideosink`)

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
|  **RAW**  |
| RAW | 190% | 80% | 80% | 20% | Картинка тормозит.<br/>Присутствуют артефакты. |
| RAW + `rtpbin` | 160% | 75% | 45% | 20% | Картинка тормозит.<br/>Присутствуют артефакты.<br/>Через ~5 секунд после запуска прием данных останавливается, хотя `gst-launch` запущен и не выдает ошибок. |
| RAW + `queue` | 150% | 90% | 75% | 20% | Картинка тормозит, но меньше, чем в остальных случаях с RAW.<br/>Присутствуют артефакты. |
|  **H264**  |
| H264 | 150% | 90% | 80% | 20% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 2-3 сек.<br/>Артефактов нет. |
| H264 + `rtpbin` | 160% | 90% | 100% | 20% |
| H264 + `queue` | 150% | 100% | 85% | 20% |
|  **JPEG**  |
| JPEG | 170% | 80% | 95% | 25% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 2-3 сек.<br/>Артефактов нет. |
| JPEG + `rtpbin` | 185% | 85% | 115% | 25% |
| JPEG + `queue` | 185% | 85% | 110% | 25% |
|  **VP9**  |
| VP9 | 15% | 300% | 10% | 5% | Картинка сильно тормозит. Интервал между кадрами ~4 секунды <br/>Артефактов нет.<br/> Особенность: Эмулятор выполняет отображение картинки, только, если прием на эмуляторе запущен раньше отправки на хосте.|
| VP9 + `rtpbin` | 15% | 310% | 10% | 5% | Картинка тормозит сильнее. |
| VP9 + `queue` | 15% | 300% | 10% | 5% |

#### Эксперименты без вывода изображения (`fakesink`)

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
|  **RAW**  |
| RAW | 150% | 80% | 40% | 0% | 
| RAW + `rtpbin` | 160 | 75% | 65% | 0% | Через ~5 секунд после запуска прием данных останавливается, хотя `gst-launch` запущен и не выдает ошибок. |
| RAW + `queue` | 140% | 80% | 40% | 0% | 
|  **H264**  |
| H264 | 20% | 90% | 10% | 0% | 
| H264 + `rtpbin` | 20% | 90% | 10% | 0% |
| H264 + `queue` | 20% | 100% | 10% | 0% |
|  **JPEG**  |
| JPEG | 25% | 65% | 15% | 0% |
| JPEG + `rtpbin` | 30% | 65% | 15% | 0% |
| JPEG + `queue` | 25% | 65% | 15% | 0% |
|  **VP9**  |
| VP9 | 10% | 270% | 2% | 0% | Особенность: Получение данных запускается, только, если прием на эмуляторе запущен раньше отправки на хосте.|
| VP9 + `rtpbin` | 10% | 270% | 2% | 0% |
| VP9 + `queue` | 10% | 270% | 2% | 0% |

### Эксперименты с JPEG-данными в разных разрешениях

##### С выводом изображения на экран (`autovideosink`)

| Разрешение | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
| 1280x720 | 160% | 75% | 95% | 25% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 2-3 сек.<br/>Артефактов нет.
| 640x480 | 160% | 30% | 70% | 35% | Картинка не тормозит.<br/>Задержек в отображении нет.<br/>Артефактов нет.
| 320x240 | 160% | 10% | 50% | 40% | Картинка не тормозит.<br/>Задержек в отображении нет.<br/>Артефактов нет.

##### Без вывода изображения на экран (`fakesink`)

| Разрешение | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
| 1280x720 | 20% | 60% | 10% | 0% |
| 640x480 | 10% | 25% | 5% | 0% |
| 320x240 | 8% | 10% | 2% | 0% |

#### Эксперименты с передачей потока с камеры на ВМ с Fedora 32

##### С выводом изображения на экран (`autovideosink`)

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `gnome-shell` |
| RAW | 175% | 90% | 70% | 20% | Картинка тормозит.<br/>Присутствуют артефакты. Плюс есть нагрузка на `ksoftirqd` в 20-25%. |
| H264 | 95% | 100% | 65% | 5% | Картинка тормозит. Артефактов нет.
| JPEG | 175% | 90% | 75% | 15% | Картинка не тормозит.<br/>Есть задержка между реальным движением и его отображением на экране в 1-2 сек.<br/>Артефактов нет. |
| VP9 | 20% | 270% | 3% | 3% | Картинка сильно тормозит. Интервал между кадрами ~4 секунды <br/>Артефактов нет.<br/> Особенность: Эмулятор выполняет отображение картинки, только, если прием на эмуляторе запущен раньше отправки на хосте.|

##### Без вывода изображения на экран (`fakesink`)

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `gnome-shell` |
| RAW | 175% | 90% | 40% | 0% | Есть нагрузка на `ksoftirqd` в 10%.
| H264 | 40% | 100% | 20% | 5% |
| JPEG | 25% | 60% | 10% | 0% |
| VP9 | 20% | 270% | 1% | 0% | Особенность: Эмулятор выполняет отображение картинки, только, если прием на эмуляторе запущен раньше отправки на хосте.|

### Тип сетевого адаптера ВМ: NAT

#### Эксперименты без вывода изображения (`fakesink`)

| Данные | Нагрузка на хосте| | Нагрузка на эмуляторе | | Комментрии |
|  :---:  |    :---:        |:---:|           :---:   |:---:|---|
|         | `VirtualBox` | `gst-launch` | `gst-launch` | `lipstick` |
|  **RAW**  |
| RAW | 230% | 70% | 50% | 0% |
| RAW + `rtpbin` | 200% | 75% | 80% | 0% |
| RAW + `queue` | 210% | 80% | 50% | 0% |
|  **H264**  |
| H264 | 20% | 100% | 10% | 0% |
| H264 + `rtpbin` | 30% | 100% | 10% | 0% |
| H264 + `queue` | 20% | 100% | 10% | 0% |
|  **JPEG**  |
| JPEG | 30% | 65% | 15% | 0% |
| JPEG + `rtpbin` | 35% | 65% | 15% | 0% |
| JPEG + `queue` | 35% | 65% | 15% | 0% |
|  **VP9**  |
| VP9 | 10% | 290% | 2% | 0% | Особенность: Получение данных запускается, только, если прием на эмуляторе запущен раньше отправки на хосте.|
| VP9 + `rtpbin` | 10% | 280% | 2% | 0% |
| VP9 + `queue` | 10% | 290% | 2% | 0% |
