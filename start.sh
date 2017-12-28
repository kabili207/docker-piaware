#!/bin/sh

if [ -z "${USER}" ]; then
  echo "USER environment variable not set"
  exit 1
fi

if [ -z "${PASSWORD}" ]; then
  echo "PASSWORD environment variable not set"
  exit 1
fi

if [ -n "${GPSD}" ]; then
    echo "GPSD specified, forwarding port 2947 to ${GPSD}"
    /usr/bin/socat -s TCP-LISTEN:2947,fork TCP:${GPSD}:2947 &
fi

if [ -n "${FEEDID}" ]; then
    /usr/bin/piaware-config feeder-id ${FEEDID}
fi

/usr/bin/piaware-config flightaware-user ${USER}
/usr/bin/piaware-config flightaware-password ${PASSWORD}
mkdir -p /run/piaware

exec /usr/bin/piaware -p /run/piaware/piaware.pid -plainlog -statusfile /run/piaware/status.json $*