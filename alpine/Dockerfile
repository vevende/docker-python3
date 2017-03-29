FROM alpine:edge

ENV LANG C.UTF-8

RUN set -ex \
    && $( echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories ) \
    && apk --update add --no-cache \
        build-base python3 python3-dev musl-dev postgresql-dev \
        gosu@testing wget ca-certificates gettext git \
        libxml2-dev libxslt-dev jansson-dev readline-dev ncurses-dev \
        libpng-dev zlib-dev jpeg-dev freetype-dev libffi-dev \
    && adduser -D  -u 1000 app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && gosu app python -m venv /python \
    && gosu app /python/bin/pip install --no-cache-dir pip setuptools wheel
    && cd /usr/local/bin \
    && { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
    && ln -s idle3 idle \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config

ENV PATH="/python/bin:${PATH}" \
    DEBIAN_FRONTEND=noninteractive \
    XDG_CACHE_HOME="/python/cache" \
    PYTHONENV="/python" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
WORKDIR /app

CMD ["python"]
