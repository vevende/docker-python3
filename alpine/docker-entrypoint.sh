#!/bin/sh
set -eo pipefail

for f in /docker-entrypoint.d/*; do
    if [ ! -f "$f" ]; then
        continue
    fi

    case "$f" in
        *.sh)
            echo "$0: running $f";
            sh "$f";
            echo "$0: completed $f" ;;
        *.py)
            echo "$0: running: $f";
            gosu app python "$f";
            echo "$0: completed $f" ;;
        *) echo "$0: ignoring $f" ;;
    esac
done

case "$1" in
    python|pip|uwsgi|-)
        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu app "$@"

        ;;
esac


echo "running: $@"
exec "$@"