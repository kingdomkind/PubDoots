#!/bin/sh
exec /usr/bin/evsieve \
    --input /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd domain=kb grab \
    --input /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse domain=ms grab \
    --hook key:leftctrl key:leftalt toggle=:1 breaks-on=key::1 sequential \
    --hook key:leftctrl key:leftalt key:leftshift toggle=:2 breaks-on=key::1 sequential \
    --toggle @kb @host-kb @guest-kb \
    --toggle @ms @host-ms @guest-ms \
    --output @host-kb create-link=/dev/input/by-id/host-keyboard repeat=enable \
    --output @host-ms create-link=/dev/input/by-id/host-mouse \
    --output @guest-kb create-link=/dev/input/by-id/guest-keyboard repeat=enable \
    --output @guest-ms create-link=/dev/input/by-id/guest-mouse
