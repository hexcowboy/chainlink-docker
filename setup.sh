#!/bin/bash

# Conforms to https://docs.chain.link/docs/running-a-Chainlink-node/

shopt -s nocasematch
networks=("mainnet" "rinkeby" "kovan")

# Prompt for the network, then save to Chainlink .env
while [[ ! " ${networks[*]} " =~ " ${network} " ]]; do
    read -p "Which network will your Chainlink node be using? [mainnet, rinkeby, kovan] " network

    case $network in
        Mainnet )
            > chainlink.env
            echo "ETH_CHAIN_ID=1" >> chainlink.env
            echo "CHAINLINK_TLS_PORT=0" >> chainlink.env
            ;;
        Rinkeby )
            > chainlink.env
            echo "ETH_CHAIN_ID=4" >> chainlink.env
            echo "MIN_OUTGOING_CONFIRMATIONS=2" >> chainlink.env
            echo "LINK_CONTRACT_ADDRESS=0x01BE23585060835E02B77ef475b0Cc51aA1e0709" >> chainlink.env
            ;;
        Kovan )
            > chainlink.env
            echo "ETH_CHAIN_ID=42" >> chainlink.env
            echo "LINK_CONTRACT_ADDRESS=0xa36085F69e2889c224210F603D836748e7dC0088" >> chainlink.env
            ;;
        (exit|quit)
            exit 0
            ;;
        *)
            echo "Invalid network selection. Type "exit" to quit."
            ;;
    esac
done

echo

# Get credentials for Chainlink, confirm password, and save it to the password store
echo "You will be prompted to create a new password for the Chainlink node."
echo "Requirements:"
echo "  - must be longer than 12 characters"
echo "  - must contain at least 3 uppercase characters"
echo "  - must contain at least 3 numbers"
echo "  - must contain at least 3 symbols"
while true; do
    read -sp "Chainlink password: " chainlink_password && echo
    read -sp "Chainlink password(confirm): " chainlink_password2 && echo
    [ "$chainlink_password" = "$chainlink_password2" ] && break
    echo "Passwords do not match."
done

echo "${chainlink_password}" > chainlink/credentials.txt

echo

# Get API credentials for Chainlink
echo "Please supply either existing or new Chainlink API credentials."

while [[ -z $username ]]; do
    read -p "Chainlink API username: " username
done

while true; do
    read -sp "Chainlink API password: " api_password && echo
    read -sp "Chainlink API password(confirm): " api_password2 && echo
    [ "$api_password" = "$api_password2" ] && break
    echo "Passwords do not match."
done

echo "${username}" > chainlink/api.txt
echo "${api_password}" >> chainlink/api.txt

echo

# Save universal properties to the Chainlink .env
echo "ROOT=/srv" >> chainlink.env
echo "LOG_LEVEL=debug" >> chainlink.env
echo "CHAINLINK_TLS_PORT=0" >> chainlink.env
echo "SECURE_COOKIES=false" >> chainlink.env
echo "ALLOW_ORIGINS=*" >> chainlink.env

# Get provider URI and verify it's valid, then save to Chainlink .env
while [[ ! $provider =~ wss:(\/?\/?)[^\s]+ ]]; do
    case $provider in
        (exit|quit)
            exit 0
            ;;
        *)
            echo "Please enter a valid WebSockets URI, eg. wss://${network}.infura.io/v3/00000000000000000000000000000000"
            ;;
    esac
    read -p "Ethereum provider URI: " provider
    provider=$(echo -n $provider | awk '{$1=$1};1' || $provider)
done

echo "ETH_URL=${provider}" >> chainlink.env

echo

# Get password for postgres, confirm it, and save it to the local .env
echo "Requirements:"
echo "  - Must be alphanumeric only (A-Za-z0-9)"
while true; do
    read -sp "Postgres database password: " password && echo
    read -sp "Postgres database password (confirm): " password2 && echo
    [ "$password" = "$password2" ] && break
    echo "Passwords do not match."
done

USER="postgres"
SERVER="postgres"
PORT="5432"
DATABASE="chainlink"

> postgres.env
echo "POSTGRES_USER=${USER}" >> postgres.env
echo "POSTGRES_DB=${DATABASE}" >> postgres.env
echo "POSTGRES_PASSWORD=${password}" >> postgres.env

# Add the connection string to the Chainlink .env
urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}
echo "DATABASE_URL=postgresql://$USER:$(urlencode $password)@$SERVER:$PORT/$DATABASE" >> chainlink.env


echo

echo "Configuration complete!"
