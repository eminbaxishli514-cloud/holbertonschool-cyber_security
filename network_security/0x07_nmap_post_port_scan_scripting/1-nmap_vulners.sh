#!/bin/bash
nmap -sV --script vulners -p 80,443 "$1"
