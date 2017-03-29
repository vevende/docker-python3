FROM python:3-alpine

RUN set -ex \
    && sed -i -e 's/v3\.\d/edge/g' /etc/apk/repositories \
    && $( echo "testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories ) \
    && apk --update add --no-cache \
        build-base python-dev musl-dev postgresql-dev \
        gosu@testing wget ca-certificates gettext git \
        libxml2-dev libxslt-dev jansson-dev readline-dev ncurses-dev \
        libpng-dev zlib-dev jpeg-dev freetype-dev libffi-dev \
    && useradd -u 1000 app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && gosu app python -m venv /python \
    && gosu app /python/bin/pip install --no-cache-dir pip setuptools wheel

ENV PATH=/python/bin:${PATH} \
    DEBIAN_FRONTEND=noninteractive \
    XDG_CACHE_HOME=/python/cache \
    PYTHONENV=/python \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
WORKDIR /app

CMD ["python"]
