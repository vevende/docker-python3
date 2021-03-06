#!/bin/sh
FAILS=0
FOUND=0

RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
RESET='\e[0m'

catch() {
    local PASSES=$(( $FOUND - $FAILS ))
    local ELAPSED="$(($END_TIME-$START_TIME))"

    echo -e "${YELLOW}==== Completed ====${RESET}\n"

    echo -e "\t${FOUND} tests executed in ${ELAPSED}s"
    echo -e "\t${PASSES} ✔ passes"

    test ${FAILS} -gt 0 && echo -en "${RED}"
    echo -e "\t${FAILS} × failures"
    test ${FAILS} -gt 0 && echo -en "${RESET}"

    echo

    if [ ${FAILS} -gt 0 ]; then
        exit 1
    fi
}

assert() {
    FOUND=$((++FOUND))
    echo -n "assert $@ ";

    "$@"

    local exitcode=$?
    if [ $exitcode -ne 0 ]; then
        FAILS=$((++FAILS))
        echo -e "${RED}FAILED${RESET}"
    else
        echo -e "${GREEN}PASS${RESET}"
    fi
}

trap catch EXIT

echo -e "${YELLOW}==== Starting ====${RESET}"

START_TIME="$(date -u +%s)"

assert test $(whoami) = 'app'
assert test $(which python) = '/python/bin/python'
assert test $(which pip) = '/python/bin/pip'
assert test ! -z $(which uwsgi)

# Check for permissions
assert test ! -O /bin
assert test -O /app
assert test -O /python

# Check if the entrypoints are correctly call.
assert test -f /tmp/entrypoint1.sh.txt
assert test -f /tmp/entrypoint2.sh.txt
assert test -f /tmp/entrypoint1.py.txt
assert test -f /tmp/entrypoint2.py.txt
assert test ! -f /tmp/disabled-entrypoint.txt

pip freeze -r /requirements.txt

END_TIME="$(date -u +%s)"
