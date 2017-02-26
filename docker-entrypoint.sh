#!/usr/bin/env bash
set -eo pipefail

source /python/bin/activate

# Fix permissions if needed.
find /python /app ! -user app -exec chown app:app {} \;

update-python-env() {
    if [ -f /requirements.txt ]; then
    echo -n "* Installing requirements from /requirements.txt"
    gosu app pip install --quiet -r /requirements.txt
    echo "[Done]"
    fi

    if [ -f /app/setup.py ]; then
    echo -n "* Installing python package foud in /app"
    gosu app pip install --quiet -e /app
    echo "[Done]"
    fi

    echo "Python package installed: $(pip freeze | wc -l)"
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
