ARG BUILD_FROM
FROM $BUILD_FROM

ARG WEEWX_UID=421
ARG WEEWX_VERSION=5.1.0
ARG WEEWX_HOME="/home/weewx"
ARG WEEWX_ARCHIVE="weewx-${WEEWX_VERSION}.tgz"

RUN adduser --system syslog
RUN adduser --system sysllog

WORKDIR /tmp

COPY logger.patch /tmp/

RUN addgroup --system --gid ${WEEWX_UID} weewx \
  && adduser --system --uid ${WEEWX_UID} --ingroup weewx weewx

RUN apk add patch

RUN wget -O "${WEEWX_ARCHIVE}" "https://weewx.com/downloads/released_versions/${WEEWX_ARCHIVE}"
RUN mkdir -p /tmp/weewx-src
RUN tar xvz --directory /tmp/weewx-src --strip-components=1 --file "${WEEWX_ARCHIVE}"

WORKDIR "/tmp/weewx-src"

RUN patch ./src/weeutil/logger.py < /tmp/logger.patch
# RUN rm ./bin/six.py

RUN pip install . 
RUN pip install paho-mqtt

COPY rootfs /
