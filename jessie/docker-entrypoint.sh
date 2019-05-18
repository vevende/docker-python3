#!/usr/bin/env bash
set -euo pipefail

YELLOW="\e[0;93m"
GREEN="\e[0;92m"
BOLD="\e[1m"
RESET="\e[0m"

HOME_APP=/home/app

step()    { echo -e "${YELLOW}${BOLD}===> ${RESET}${*}${RESET}"; }
success() { echo -e "${RESET}${GREEN}${BOLD}${*}${RESET}"; }

step "Current dir: $(pwd)"
step "Python version: $(python --version)"


# SETUP AND CHECK DEFINITIONS

function setup_python_env() {
    if [[ -f /python/bin/python ]]; then return 0; fi

    (
        set -x
        mkdir -p /python
        chown app.app -R /python
        python -m venv /python
        /python/bin/pip install --quiet setuptools wheel
    )

    step "Python environment $(success [Done])"
}

function setup_home_dir() {
    if [[ -f /home/app/.initialized ]]; then return 0; fi

    (
        set -x
        mkdir -p /home/app
        chown app.app /home/app

        if [[ -f .bashrc ]]; then ln -s .bashrc /home/app; fi

        touch /home/app/.initialized
    )

    step "Setup app shell $(success [Done])"
}

function check_permissions() {
    (
        find /app /python \
            -not \( -name "frontend"  -prune \) \
            -not \( -name "node_modules"  -prune \) \
            -not \( -name ".git" -prune  \) \
            -not \( -name ".cache" -prune \) \
            -not -user app \
            -exec chown app.app \{\} \; >/dev/null &

        chown app.app /home/app >/dev/null &

        wait
    ) &
    step "Run permissions check"
}

# SETUP AND CHECK ACTIONS


case "$1" in
    --shell)
        (
            setup_home_dir
            setup_python_env
            check_permissions
        )
        shift
        set -- gosu app bash
    ;;
esac


# ENTRYPOINT

step "Running: $@"
exec "$@"
