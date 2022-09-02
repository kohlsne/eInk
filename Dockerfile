ARG BUILD_FROM
FROM $BUILD_FROM


WORKDIR /config/www/pics
# Copy data for add-on
COPY run.sh /

RUN \
  apk add --no-cache \
    imagemagick


CMD [ "/run.sh" ]
