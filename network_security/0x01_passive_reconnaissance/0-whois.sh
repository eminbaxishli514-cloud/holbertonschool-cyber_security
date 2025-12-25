#!/bin/bash
whois $1 | awk -F: '/Registrant|Admin|Tech/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); if($2!="") print $1 "," $2}' > $1.csv
