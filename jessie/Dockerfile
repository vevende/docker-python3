FROM python:3.6-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends wget ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN set -ex \
    && apt-get update -y \
    && apt-get install -q -y --no-install-recommends \
        git gcc make gettext uwsgi uwsgi-plugin-python3 gdal-bin \
        libc6-dev zlib1g-dev musl-dev \
        libpq-dev libxml2-dev libxslt1-dev \
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
    && gosu app /python/bin/pip install --no-cache-dir pip setuptools wheel

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
