FROM python:3.6-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends wget ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && wget -q -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody:root bash -c 'whoami && id'

RUN set -ex \
    && wget -q -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v0.14.0/tini-$(dpkg --print-architecture)" \
    && wget -q -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v0.14.0/tini-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
    && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
    && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
    && chmod +x /usr/local/bin/tini \
    && tini -vvv -- bash -c 'true'

COPY conf /usr/share/docker-python3

RUN set -ex \
    && apt-get update -y \
    && apt-get install -q -y --no-install-recommends \
        git gcc make gettext gdal-bin libcurl4-openssl-dev \
        libc6-dev zlib1g-dev musl-dev libpq-dev libexpat1-dev \
        libxml2-dev libxslt1-dev libjansson-dev libpcre3-dev \
        libpng-dev libfreetype6-dev libjpeg-dev libffi-dev \
    && rm -rf /var/cache/apt/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 1000 --user-group app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && gosu app python -m venv /python \
    && gosu app /python/bin/pip install --no-cache-dir --upgrade pip setuptools \
    && gosu app /python/bin/pip install --no-cache-dir --upgrade wheel \
    && UWSGI_PROFILE=/usr/share/docker-python3/uwsgi-profile.ini \
       gosu app /python/bin/pip install --no-cache-dir --upgrade -vv uwsgi


ENV LANG="C.UTF-8" \
    LC_COLLATE=C \
    DEBIAN_FRONTEND=noninteractive \
    TERM="xterm-256color" \
    PATH="/python/bin:${PATH}" \
    XDG_CACHE_HOME="/python/cache" \
    PYTHONENV="/python" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]
WORKDIR /app

CMD ["python"]
