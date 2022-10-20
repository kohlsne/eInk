FROM alpine
COPY main.c /main.c
COPY run.sh /run.sh
#WORKDIR /ssd/config/Eink
RUN \
  chmod +x /run.sh &&\
  apk add --no-cache \
    bash \
    vim \
    imagemagick \
    gcc \
    musl-dev \
    mosquitto-clients 

CMD [ "./run.sh" ]
