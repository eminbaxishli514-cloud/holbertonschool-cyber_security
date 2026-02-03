#!/bin/bash
john --wordlist=rockyou.txt --format=nt "$1" 2>/dev/null; john --show --format=nt "$1" | cut -d: -f2 > 5-password.txt
