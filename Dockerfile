FROM python:3.6-slim

RUN set -x \
    && apt-get update -y \
    && apt-get install -q -y --no-install-recommends \
        build-essential gettext gdal-bin wget ca-certificates \
        python3-dev libc6-dev zlib1g-dev musl-dev \
        libpq-dev libxml2-dev libxslt1-dev \
        libpng-dev libfreetype6-dev libjpeg-dev libffi-dev \
        libjansson-dev libpcre3 libpcre3-dev libssl-dev \
    && wget -O /sbin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && chmod +x /sbin/gosu \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /usr/share/{man,doc}/ \
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

ENV LANG=C.UTF-8 \
    LC_COLLATE=C \
    PATH=/python/bin:${PATH} \
    XDG_CACHE_HOME=/python/cache \
    PYTHONENV=/python \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

RUN gosu app pip install --no-cache-dir pip setuptools wheel

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

ONBUILD COPY requirements.txt /requirements.txt
ONBUILD RUN set -x \
    && gosu app pip install --no-cache-dir -r /requirements.txt

CMD ["python"]
