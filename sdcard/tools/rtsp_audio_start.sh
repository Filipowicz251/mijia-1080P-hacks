#!/bin/sh
# Wait for the camera clock to be initialized before RTCP sender reports start.
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH
attempt=0
while [ "$(date +%Y)" -lt 2020 ] && [ "$attempt" -lt 30 ]; do
    sleep 2
    attempt=$((attempt + 1))
done
exec /tmp/sd/tools/rtsp_audio "$@" >/dev/null 2>&1
