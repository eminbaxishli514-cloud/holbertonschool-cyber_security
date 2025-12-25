#!/bin/bash
whois "$1" | awk -F': ' 'BEGIN{OFS=","} /^(Registrant|Admin|Tech)/{r=$1} /Name:|Organization:|Street:|City:|State\/Province:|Postal Code:|Country:|Phone:|Fax:|Email:/{f=$1;v=$2;if(f=="Street")v=v" ";if(f=="Phone"||f=="Fax"){print r" "f,v;print r" "f" Ext:,";next} print r" "f,v}' > "$1.csv"
