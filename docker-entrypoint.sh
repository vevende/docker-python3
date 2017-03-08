#!/usr/bin/env bash
set -eo pipefail

source /python/bin/activate

echo -n "* Check folder permissions"
find /python /app ! -user app -exec chown app:app {} \;
echo " [Done]"

update-python-env() {
    if [ -f /app/requirements.txt ]; then
    echo -n "* Installing packages from /app/requirements.txt ... "
    gosu app pip install --quiet -r /requirements.txt
    echo "[Done]"
    fi

    if [ -f /app/setup.py ]; then
    echo -n "* Installing python package found in /app ..."
    gosu app pip install --quiet -e /app
    echo "[Done]"
    fi

    echo "* Python packages installed: $(pip freeze | wc -l)"
}

run-entrypoints() {
    test -z "$1" && exit 1;

    # Loading optional entrypoints scripts.
    for f in $1; do
        echo -e "\n==== Found $f ====\n"
        case "$f" in
            *.sh)     echo "$0: running $f"; gosu app bash "$f" ;;
            *.py)     echo "$0: running $f"; gosu app python "$f" ;;
            *)        echo "$0: ignoring $f" ;;
        esac
        echo -e "\n==== Finished $f ====\n"
    done
}

export -f update-python-env

run-entrypoints "/docker-entrypoint.d/pre-*"

case "$1" in
    python|uwsgi|-)
        update-python-env
        run-entrypoints "/docker-entrypoint.d/post-*"

        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu app "$@"
        ;;
esac

echo "running: $@"
exec "$@"
