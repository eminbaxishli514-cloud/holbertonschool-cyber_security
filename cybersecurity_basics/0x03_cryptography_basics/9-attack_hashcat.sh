#!/bin/bash
hashcat -m 0 -a 1 "$1" wordlist1.txt wordlist2.txt --quiet --potfile-disable --outfile-format=2 -o 9-password.txt
