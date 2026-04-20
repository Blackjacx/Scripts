#!/usr/bin/env bash

# Imprort global functionality
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/imports.sh"

# ====================================================================================================================
# Screenshots
# ====================================================================================================================

gen_screenshots() {
    local scheme="$1"
    local workspace="$2"
    local ios_version="${3:-"iOS 18.6"}"

    if [[ -z $scheme ]]; then
        log_error "Please provide a scheme"
        return
    fi

    if [[ -z $workspace ]]; then
        log_error "Please provide a workspace"
        return
    fi

    local simulator="iPhone 16 Pro"
    local language="en_GB"
    local out_dir
    out_dir="$(mktemp -d)"

    mint run Blackjacx/Assist@"0.8.0" snap \
        --workspace "$workspace" \
        --scheme "$scheme" \
        --test-plan-name "Screenshots" \
        --test-plan-configs "$language" \
        --destination-dir "$out_dir" \
        --zip-file-name "Screenshots-$(date +%F_%H-%M-%S).zip" \
        --appearances "light" \
        --devices "$simulator" \
        --runtime "$ios_version"
}
