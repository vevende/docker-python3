FROM python:3.7-slim

ENV LANG="C.UTF-8" \
    LC_COLLATE=C \
    TERM="xterm-256color" \
    DEBIAN_FRONTEND=noninteractive \
    GOSU_VERSION=1.10 \
    TINY_VERSION=0.18.0 \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

RUN set -ex; \
    \
    fetchDeps='ca-certificates dirmngr gnupg wget'; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# Sometimes keyservers are not available, we will try several until one works.
    keyservers=" \
        ha.pool.sks-keyservers.net \
        hkp://p80.pool.sks-keyservers.net:80 \
        keyserver.ubuntu.com \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu \
    "; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    for server in ${keyservers}; do \
       gpg --keyserver "${server}" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
    done; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    \
# verify that the binary works
    gosu nobody true; \
    apt-get purge -y --auto-remove $fetchDeps; \
    rm -rf /var/cache/apt/*; \
    rm -rf /usr/share/man/*; \
    rm -rf /usr/share/doc/*; \
    rm -rf /var/lib/apt/lists/*;

RUN set -ex; \
    fetchDeps='ca-certificates dirmngr gnupg wget'; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    wget -q -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v$TINY_VERSION/tini-$(dpkg --print-architecture)"; \
    wget -q -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v$TINY_VERSION/tini-$(dpkg --print-architecture).asc"; \
    \
# Sometimes keyservers are not available, we will try several until one works.
    keyservers=" \
        ha.pool.sks-keyservers.net \
        hkp://p80.pool.sks-keyservers.net:80 \
        keyserver.ubuntu.com \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu \
    "; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    for server in ${keyservers}; do \
       gpg --keyserver "${server}" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || : ; \
    done; \
    gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini; \
    rm -r "$GNUPGHOME" /usr/local/bin/tini.asc; \
    \
    chmod +x /usr/local/bin/tini; \
# verify that the binary works
    tini -vvv -- bash -c 'true'; \
    apt-get purge -y --auto-remove $fetchDeps; \
    rm -rf /var/cache/apt/*; \
    rm -rf /usr/share/man/*; \
    rm -rf /usr/share/doc/*; \
    rm -rf /var/lib/apt/lists/*;

# Install system libraries
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git gcc make gettext tzdata ca-certificates \
        locales gdal-bin libmemcached-dev \
        musl-dev \
        zlib1g-dev \
        libc6-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libjansson-dev \
        libpcre3-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libffi-dev; \
    rm -rf /var/cache/apt/*; \
    rm -rf /usr/share/man/*; \
    rm -rf /usr/share/doc/*; \
    rm -rf /var/lib/apt/lists/*;

# Setup non-root user
RUN set -ex \
    && addgroup --gid 1000 app \
    && adduser --uid 1000 \
        --gid 1000 \
        --no-create-home \
        --disabled-password --quiet app

# Setup non-root user
RUN set -ex \
    && gosu app ls -al \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown -R app /app \
    && chown -R app /python \
    && gosu app python -m venv /python \
    && gosu app /python/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

ENV PATH="/python/bin:${PATH}" \
    XDG_CACHE_HOME="/python/cache" \
    PYTHONENV="/python"

COPY docker-entrypoint.sh /sbin/

ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]

WORKDIR /app

CMD ["python"]
