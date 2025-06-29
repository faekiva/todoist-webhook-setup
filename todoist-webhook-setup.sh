#!/bin/bash

set -euo pipefail
IFS=$'\n\t'



if ! command -v gum &>/dev/null; then
    echo "gum is not installed. Please install it."
fi

if ! command -v httpie &>/dev/null; then
    echo "httpie is not installed. Please install it."
fi

gum confirm "This script will set up a Todoist webhook. Do you want to continue?" || exit 1

if [[ -z "$CLIENT_ID" ]]; then
    echo "$CLIENT_ID"
    CLIENT_ID=$(gum input --placeholder "Enter your Todoist Client ID")
fi

if [[ -z "$CLIENT_SECRET" ]]; then
    echo "$CLIENT_SECRET"
    CLIENT_SECRET=$(gum input --placeholder "Enter your Todoist Client Secret")
fi

RANDOM_STRING=$(
    tr -dc A-Za-z0-9 </dev/urandom | head -c 13
    echo
)
echo "https://todoist.com/oauth/authorize?client_id=$CLIENT_ID&scope=data:read_write,task:add,data:delete&state=$RANDOM_STRING"

todoist-oauth-receiver