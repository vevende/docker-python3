#!/bin/sh
set -eo pipefail

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

        # Protects uwsgi to accidentally creates zombie processes
        if [ ${1} = 'uwsgi' ]; then
            set -- tini -- "$@"
        fi

        set -- gosu app "$@"

        ;;
esac


echo "==> running: $@"
exec "$@"