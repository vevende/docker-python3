#!/usr/bin/env bash
set -eo pipefail

export LC_COLLATE=C
source /python/bin/activate

# Fix permissions if needed.
find /python /app ! -user app -exec chown app:app {} \;

update-python-env() {
    if [ -f /requirements.txt ]; then
    gosu app pip install -r /requirements.txt
    fi

    if [ -f /app/setup.py ]; then
    gosu app python /app/setup.py develop
    fi
}

export -f update-python-env

case "$1" in
    python|uwsgi|make|-)
        update-python-env

        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu app "$@"
        ;;
esac

exec "$@"
