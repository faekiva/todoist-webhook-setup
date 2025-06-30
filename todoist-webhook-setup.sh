#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

if ! command -v gum &>/dev/null; then
    echo "gum is not installed. Please install it."
fi

if ! command -v httpie &>/dev/null; then
    echo "httpie is not installed. Please install it."
fi

if [[ -z "$CLIENT_ID" ]]; then
    echo "$CLIENT_ID"
    CLIENT_ID=$(gum input --placeholder "Enter your Todoist Client ID")
    export CLIENT_ID
fi

if [[ -z "$CLIENT_SECRET" ]]; then
    echo "$CLIENT_SECRET"
    CLIENT_SECRET=$(gum input --placeholder "Enter your Todoist Client Secret")
    export CLIENT_SECRET
fi

STATE_STRING=$(
    tr -dc A-Za-z0-9 </dev/urandom | head -c 13
    echo
)

export STATE_STRING

echo "Please visit the following URL in your browser to authorize the application:"
echo "https://todoist.com/oauth/authorize?client_id=$CLIENT_ID&scope=data:read_write,task:add,data:delete&state=$STATE_STRING"

gum spin --spinner dot --title "waiting for request..." --show-output -- todoist-oauth-receiver