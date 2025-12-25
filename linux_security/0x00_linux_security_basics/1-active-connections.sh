#!/bin/bash
# Display all active TCP network socket connections with process info
# Requires root or sudo privileges

ss -t -a -n -p
