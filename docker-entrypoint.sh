#!/usr/bin/env bash
set -eo pipefail

export LC_COLLATE=C

source /python/bin/activate

echo " * Loaded entrypoint"

sudo chown app.app -R /app
sudo chown app.app -R /python

case "$1" in
    make)
        set -- gosu app "$@"
        ;;
    python|uwsgi)
        gosu app /python/bin/pip install -r requirements.txt

        set -- gosu app "$@"
        ;;
    *)
       echo " * Activate the environment by 'source /python/bin/activate'"
esac

exec "$@"
