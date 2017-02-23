#!/usr/bin/env bash
set -eo pipefail

export LC_COLLATE=C

source /python/bin/activate

echo " * Loaded entrypoint"

case "$1" in
    make)
        set -- gosu app "$@"
        ;;
    python|uwsgi)
        gosu app pip install -r requirements.txt
        gosu app pip install --no-deps -e .

        set -- gosu app "$@"
        ;;
    *)
       echo " * Activate the environment by 'source /python/bin/activate'"
esac

exec "$@"
