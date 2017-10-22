#!/usr/bin/env bash
case "$1" in
    --list)
        if [[ ! "$DO_INV_TAG" ]]; then
            >2& echo 'env var $DO_INV_TAG must be set, e.g. `shed`'
            exit 1
        fi
        doctl compute droplet list --tag-name "$DO_INV_TAG" --output json \
            | jq "{$DO_INV_TAG: {hosts: [.[].networks.v4[0].ip_address], vars: {}}}"
        ;;
    *)
        >&2 echo "Error: unknown command"
        exit 1
        ;;
esac

