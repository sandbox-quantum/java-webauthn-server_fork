#!/bin/sh

# Start the first process
YUBICO_WEBAUTHN_ALLOWED_ORIGINS=https://*:8443 ./gradlew -d run &

/bin/sh
