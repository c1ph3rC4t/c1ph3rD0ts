#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2026 c1ph3rC4t

# Config
set -euo pipefail

TOTAL_CHECKS=2
DONE_CHECKS=0

# Functions
function begin_check {
    echo -e " \x1b[1m\x1b[34m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] $@\x1b[0m"
    CURRENT_CHECK=$@
}

function end_check {
    ((++DONE_CHECKS))
    echo -e " \x1b[1m\x1b[34m::\x1b[0m\x1b[1m $CURRENT_CHECK done\x1b[0m\n"
}

function success {
    RAND=$(( $(od -An -tu4 -N4 /dev/urandom) % 10 ))
    if (( RAND <= 0 )); then
        echo -e " \x1b[1m\x1b[35m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] All checks passed! :3\x1b[0m"
    else
        echo -e " \x1b[1m\x1b[32m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] All checks passed\x1b[0m"
    fi
}

function run_checks {
    trap 'handle_error > /dev/stderr' ERR

    # Trufflehog scan
    begin_check Trufflehog scan
        trufflehog git file://.
    end_check

    # Gitleaks scan
    begin_check Gitleaks scan
        gitleaks detect --source . -v
    end_check

    # Success
    success
}

function handle_error {
    echo -e "\n \x1b[1m\x1b[31m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] $CURRENT_CHECK failed\x1b[0m\n"
}

trap 'handle_error > /dev/stderr' ERR

if [ "${CI:-}" = "true" ]; then
    PUSH_CHECK=true
    run_checks > /dev/stderr
else
    run_checks
fi
