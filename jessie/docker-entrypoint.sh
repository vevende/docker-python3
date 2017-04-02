#!/bin/sh
set -e

for f in /docker-entrypoint.d/*; do
    if [ ! -f "$f" ]; then
        continue
    fi

    case "$f" in
        *.sh)
            echo "==> running $f";
            "$f";;

        *.py)
            echo "==> running: $f";
            gosu app python "$f";;

        *);;
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


echo "==> running: $@"
exec "$@"