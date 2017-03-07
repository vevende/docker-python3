#!/usr/bin/env bash
set -eo pipefail

source /python/bin/activate

# Fix permissions if needed.
find /python /app ! -user app -exec chown app:app {} \;

update-python-env() {
    if [ -f /app/requirements.txt ]; then
    echo -n "* Installing packages from /app/requirements.txt"
    gosu app pip install --quiet -r /requirements.txt
    echo "[Done]"
    fi

    if [ -f /app/setup.py ]; then
    echo -n "* Installing python package found in /app"
    gosu app pip install --quiet -e /app
    echo "[Done]"
    fi

    echo "Python packages installed: $(pip freeze | wc -l)"
}

export -f update-python-env

# Loading optional entrypoints scripts.
for f in /docker-entrypoint.d/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.py)     echo "$0: running $f"; python "$f" ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

case "$1" in
    python|uwsgi|-)
        update-python-env

        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu app "$@"
        ;;
esac

exec "$@"
