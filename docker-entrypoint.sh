#!/usr/bin/env bash
set -eo pipefail
shopt -s nullglob

source /python/bin/activate

case "$1" in
    run-entrypoints)
        test -z "$2" && exit 1;

        # Loading optional entrypoints scripts.
        for f in $2; do
            case "$f" in
                *.sh)
                    echo "\n==== $0: Running $f \n====\n";
                    gosu app bash "$f" ;
                    echo -e "\n==== Completed $f ====\n"
                    ;;

                *.py)
                    echo "\n==== $0: Running $f \n====\n";
                    gosu app python "$f" ;
                    echo -e "\n==== Completed $f ====\n"
                    ;;

                *) echo "$0: Ignoring $f" ;;
            esac
        done
    ;;
    python|python3|uwsgi|-)
        gosu app "$0" run-entrypoints /docker-entrypoint.d/post-*

        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu app "$@"
        ;;
esac

"$0" run-entrypoints /docker-entrypoint.d/pre-*

echo "running: $@"
exec "$@"
