#!/bin/bash
sudo nmap -sF -p 80-85 -T2 -f $1
