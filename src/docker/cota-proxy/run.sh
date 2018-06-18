#!/bin/bash
export DNS_RESOLVER=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
envsubst '${WEBSOCKET_HOST},${WEBSOCKET_PORT},${UI_HOST},${UI_PORT},${DNS_RESOLVER}' < /etc/nginx/default.conf.template > /etc/nginx/conf.d/default.conf \
    && exec nginx -g 'daemon off;'