#!/bin/bash
whois "$1" | awk '/^(Registrant|Admin|Tech)/{t=$1} \
/Name:|Organization:|Street:|City:|State\/Province:|Postal Code:|Country:|Phone:|Phone Ext:|Fax:|Fax Ext:|Email:/ {f=$0; gsub(/^[^:]+: /,""); if($0 ~ /Street:/){printf "%s Street, %s \n", t, $0} else if($0 ~ /Phone Ext:|Fax Ext:/){printf "%s %s,\n", t, gensub(/:$/," Ext:","1",$0)} else {printf "%s %s, %s\n", t, gensub(/:$/,"","1",$0), $0}}' > "$1.csv"
