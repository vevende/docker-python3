#!/usr/bin/env bash
FAILS=0
FOUND=0

ERROR='\033[0;31m'
RESET='\033[0m'

function catch {
    echo -e "\nTotal tests found: ${FOUND}. Fails: ${FAILS}"

    if [[ ${FAILS} -gt 0 ]]; then
        exit 1
    fi
}

function assert {
    let "FOUND+=1"

    test "$@" && : || local FAIL='FAIL';
    test ! -z "$FAIL" && let "FAILS+=1"
    test -z "$FAIL"  && echo -en "PASS" || echo -en "${ERROR}FAIL"

    echo -e " assert ${@} ${RESET}"
}

trap catch EXIT

set -eEo errtrace

assert $(whoami) = 'app'
assert $(which python) = '/python/bin/python'
assert -O /app
assert -O /python
