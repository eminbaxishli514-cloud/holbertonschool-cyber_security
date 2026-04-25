#!/bin/bash
nmap -sV -A -O --script banner,ssl-enum-ciphers,default,smb-enum-domains -oN service_enumeration_results.txt $1
