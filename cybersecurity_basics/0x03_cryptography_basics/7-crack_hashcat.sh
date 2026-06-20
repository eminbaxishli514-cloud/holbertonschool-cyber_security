#!/bin/bash
hashcat -m 0 -a 0 "$1" rockyou.txt --quiet --potfile-disable -o 7-password.txt
