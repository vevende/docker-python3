FROM python:3.6-slim

ENV LANG=C.UTF-8 \
    LC_COLLATE=C \
    GOSU_VERSION=1.7

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget \
    && rm -rf /var/lib/apt/* \
    && rm -rf /var/cache/ \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN set -ex \
    && apt-get update -y \
    && apt-get install -y apt-utils \
    && apt-get install -y \
        openssl wget ca-certificates
        iputils-ping gettext gdal-bin \
    && apt-get install -q -y --no-install-recommends \
        build-essential python3-dev libc6-dev zlib1g-dev musl-dev \
        libpq-dev libxml2-dev libxslt1-dev \
        libpng-dev libfreetype6-dev libjpeg-dev libffi-dev \
        libjansson-dev libpcre3 libpcre3-dev libssl-dev \
    && apt-get purge -y apt-utils wget \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /usr/share/{man,doc}/ \
    && rm -rf /var/cache/* \
    && rm -rf /var/log/* \
    && rm -rf /tmp/*

RUN set -x \
    && useradd --uid 1000 --user-group app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && gosu app python -m venv /python

WORKDIR /app

ENV PATH=/python/bin:${PATH} \
    XDG_CACHE_HOME=/python/cache \
    PYTHONENV=/python \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

RUN set -ex && gosu app pip install --no-cache-dir pip setuptools wheel

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

ONBUILD COPY requirements.txt /requirements.txt
ONBUILD RUN set -x && gosu app pip install --no-cache-dir -r /requirements.txt

CMD ["python"]
