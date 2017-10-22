#!/usr/bin/env bash
OARMADA_DIR="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" && pwd )"
USERNAME=${DEPLOY_USERNAME:-"$(whoami)"}
PLAYBOOK=${DEPLOY_PLAYBOOK:-"$OARMADA_DIR/playbook.yml"}
TAG=${DEPLOY_TAG:-shed}
EXTRA=${DEPLOY_EXTRA:-""}
USAGE="Usage: deploy [-i identity] [-u username] [-h hosts] [-p playbook] [-e ...]"

while [[ "$1" ]]; do
    case "$1" in
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -h|--hosts)
            HOSTS="$2"
            shift 2
            ;;
        -p|--playbook)
            PLAYBOOK="$2"
            shift 2
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        --)
            shift 1
            EXTRA="$*"
            break
            ;;
        --help)
            echo "$USAGE"
            exit 0
            ;;
        *)
            echo "Unrecognized argument: $1"
            echo "$USAGE"
            exit 1
            ;;
    esac
done

export DO_INV_TAG="$TAG"
ansible-playbook --ask-become-pass \
                 --inventory "$OARMADA_DIR/bin/do-tagged-inv.sh" \
                 -e ansible_ssh_user="$USERNAME" \
                 "$PLAYBOOK" \
                 $EXTRA
