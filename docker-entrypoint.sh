#!/usr/bin/env bash
set -eo pipefail

export LC_COLLATE=C

source /python/bin/activate

find /python /app ! -user app -exec chown app:app {} \;

set -x

env
ls -l /app
ls -l /python

set +x

case "$1" in
    make)
        set -- gosu app "$@"
        ;;
    python|uwsgi)
        if [ -f /requirements.txt ]; then
        gosu app pip install -r requirements.txt
        fi

        if [ -f /app/setup.py ]; then
        gosu app python setup.py develop
        fi

        set -- gosu app "$@"
        ;;
    *)
       echo " * Activate the environment by 'source /python/bin/activate'"
esac

exec "$@"
