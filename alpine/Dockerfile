FROM alpine:edge

ENV LANG C.UTF-8

RUN set -ex \
    && $( echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories ) \
    && apk --update add --no-cache \
        build-base python3 python3-dev musl-dev linux-headers postgresql-dev \
        gosu@testing wget ca-certificates gettext \
        libxml2-dev libxslt-dev jansson-dev readline-dev ncurses-dev \
        libpng-dev zlib-dev jpeg-dev freetype-dev libffi-dev \
    && adduser -D  -u 1000 app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && ln -s /usr/bin/easy_install-3.6 /usr/bin/easy_install \
    && ln -s /usr/bin/idle3 /usr/bin/idle \
    && ln -s /usr/bin/pydoc3 /usr/bin/pydoc \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/python3-config /usr/bin/python-config \
    && gosu app python -m venv /python \
    && gosu app /python/bin/pip install --no-cache-dir pip setuptools wheel

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
