FROM alpine:edge

ENV LANG C.UTF-8

RUN set -ex \
    && $( echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories ) \
    && apk --update add --no-cache \
        gosu@testing tini build-base python3 python3-dev \
        musl-dev linux-headers postgresql-dev zlib-dev \
        ca-certificates gettext libxml2-dev libxslt-dev \
        libpng-dev jpeg-dev freetype-dev libffi-dev \
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
    && gosu app /python/bin/pip install --no-cache-dir pip setuptools \
    && apk add --no-cache --virtual .uwsgi-deps \
        libcap-dev attr-dev curl-dev jansson-dev libcap-dev pcre-dev \
    && gosu app /python/bin/pip install --no-cache-dir uwsgi \
    && apk del .uwsgi-deps


ENV PATH="/python/bin:${PATH}" \
    TERM="xterm-256color" \
    XDG_CACHE_HOME="/python/cache" \
    PYTHONENV="/python" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true \
    PS1="\\u@\\H:\\w \\$ "

COPY docker-entrypoint.sh /sbin/
ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]
WORKDIR /app

CMD ["python"]
