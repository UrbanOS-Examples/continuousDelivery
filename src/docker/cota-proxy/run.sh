#!/bin/bash
envsubst '${WEBSOCKET_HOST},${WEBSOCKET_PORT},${UI_HOST},${UI_PORT}' < /etc/nginx/default.conf.template > /etc/nginx/conf.d/default.conf \
    && exec nginx -g 'daemon off;'