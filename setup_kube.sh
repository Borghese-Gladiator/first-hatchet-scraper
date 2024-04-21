#!/bin/bash
 
# Define an alias for generating random strings. This needs to be a function in a script.
randstring() {
    openssl rand -base64 69 | tr -d "\n=+/" | cut -c1-$1
}
 
# Create keys directory
mkdir -p ./keys
 
# Generate keysets using Docker
docker run -v $(pwd)/keys:/hatchet/keys ghcr.io/hatchet-dev/hatchet/hatchet-admin:v0.11.3 /hatchet/hatchet-admin keyset create-local-keys --key-dir /hatchet/keys
 
# Read keysets from files
SERVER_ENCRYPTION_MASTER_KEYSET=$(<./keys/master.key)
SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET=$(<./keys/private_ec256.key)
SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET=$(<./keys/public_ec256.key)
 
# Generate the random strings for SERVER_AUTH_COOKIE_SECRETS
SERVER_AUTH_COOKIE_SECRET1=$(randstring 16)
SERVER_AUTH_COOKIE_SECRET2=$(randstring 16)
 
# Create the YAML file
cat > hatchet-values.yaml <<EOF
api:
  enabled: true
  env:
    SERVER_AUTH_COOKIE_SECRETS: "$SERVER_AUTH_COOKIE_SECRET1 $SERVER_AUTH_COOKIE_SECRET2"
    SERVER_ENCRYPTION_MASTER_KEYSET: "$SERVER_ENCRYPTION_MASTER_KEYSET"
    SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET: "$SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET"
    SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET: "$SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET"
 
engine:
  enabled: true
  env:
    SERVER_AUTH_COOKIE_SECRETS: "$SERVER_AUTH_COOKIE_SECRET1 $SERVER_AUTH_COOKIE_SECRET2"
    SERVER_ENCRYPTION_MASTER_KEYSET: "$SERVER_ENCRYPTION_MASTER_KEYSET"
    SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET: "$SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET"
    SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET: "$SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET"
EOF
 
# Cleanup key directory
rm -rf ./keys