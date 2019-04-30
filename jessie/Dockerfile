FROM python:3.7.3-slim

ENV LC_COLLATE=C \
    TERM="xterm-256color" \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

RUN set -eux; \
    \
    export GOSU_VERSION=1.10; \
    export TINI_VERSION=0.18.0; \
    fetchDeps='ca-certificates wget dirmngr gnupg cabextract xfonts-utils'; \
    savedAptMark="$(apt-mark showmanual)"; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
# Sometimes keyservers are not available, we will try several until one works.
    keyservers=" \
        ha.pool.sks-keyservers.net \
        hkp://p80.pool.sks-keyservers.net:80 \
        keyserver.ubuntu.com \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu \
    "; \
    \
    echo deb http://deb.debian.org/debian jessie main contrib non-free > /etc/apt/source.list ; \
    echo deb http://deb.debian.org/debian jessie-updates main contrib non-free >> /etc/apt/source.list ; \
    echo deb http://security.debian.org jessie/updates main >> /etc/apt/source.list ; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    \
# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    for server in ${keyservers}; do \
       gpg --no-tty --batch --keyserver "${server}" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
    done; \
    gpg  --no-tty --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    gpgconf --kill all; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    gosu nobody true; \
    \
# grab tini for signal processing and zombie killing
# https://github.com/krallin/tini/releases
    wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch"; \
    wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    for server in ${keyservers}; do \
        gpg --no-tty --batch --keyserver "${server}" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || : ; \
    done; \
    gpg --no-tty --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini; \
    gpgconf --kill all; \
    rm -r "$GNUPGHOME" /usr/local/bin/tini.asc; \
    chmod +x /usr/local/bin/tini; \
    tini -vvv -- bash -c 'true'; \
    \
# Install MS Fonts, needed to generate useful PDF's
    wget -q -O ttf-mscorefonts-installer_3.7_all.deb http://http.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb; \
    dpkg -i ttf-mscorefonts-installer_3.7_all.deb; \
    rm -rf ttf-mscorefonts-installer_3.7_all.deb; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# Install system libraries
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
# Common tools for development and building
        make \
        build-essential \
        gcc \
        binutils \
        git \
        gettext \
        tzdata \
        ca-certificates \
        locales \
# Postgis libs
        gdal-bin \
        libproj-dev \
# Requirements for generating pdf thumbnails
        imagemagick \
        ghostscript \
# Library headers to build python packages
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
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libffi-dev; \
    \
    rm -rf /var/cache/apt/*; \
    rm -rf /usr/share/man/*; \
    rm -rf /usr/share/doc/*; \
    rm -rf /var/lib/apt/lists/*;

# Setup  environment
RUN set -ex \
    && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    \
    && addgroup --gid 1000 app \
    && adduser --uid 1000 \
        --gid 1000 \
        --no-create-home \
        --disabled-password --quiet app \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown app.app -R /app \
    && chown app.app -R /python \
    && gosu app python3 -m venv /python

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PATH="/python/bin:${PATH}" \
    XDG_CACHE_HOME="/python/cache" \
    DEFAULT_LOCAL_TMP="/python/cache" \
    PYTHONENV="/python"

COPY docker-entrypoint.sh /sbin/

ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]

WORKDIR /app

CMD ["python"]
