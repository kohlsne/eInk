ARG BUILD_FROM
FROM $BUILD_FROM


#WORKDIR /config/www/pics
# Copy data for add-on

COPY main.c /
COPY run.sh /

RUN \
  apk add --no-cache \
    imagemagick \
    gcc \
    musl-dev \
    mosquitto-clients 


CMD [ "/run.sh" ]
