#!/bin/bash

PASSPHRASE=$PASSPHRASE:-"" # Default to empty string

duplicati-cli backup $TARGET_URL /source --passphrase=$PASSPHRASE