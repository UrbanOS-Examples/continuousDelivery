FROM nginx:1.15

ENV WEBSOCKET_HOST localhost
ENV WEBSOCKET_PORT 4000
ENV UI_HOST localhost
ENV UI_PORT 8080

COPY default.conf.template /etc/nginx/default.conf.template
COPY run.sh /run.sh
CMD [ "/run.sh"]