#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2026 c1ph3rC4t

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TOTAL_CHECKS=2

run_checks() {
    begin_check "Trufflehog scan"
        trufflehog git file://.
    end_check

    begin_check "Gitleaks scan"
        gitleaks detect --source . -v
    end_check

    success
}

if [ "${CI:-}" = "true" ]; then
    PUSH_CHECK=true
    run_checks > /dev/stderr
else
    run_checks
fi
