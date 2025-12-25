#!/bin/bash
whois "$1" | awk '
BEGIN {
  OFS=","
}
function print_field(prefix, field, value) {
  print prefix " " field, value
}
$1 ~ /Registrant|Admin|Tech/ {
  role=$1
}
$0 ~ /(Name:|Organization:|Street:|City:|State\/Province:|Postal Code:|Country:|Phone:|Fax:|Email:)/ {
  sub(/^[^:]+: */,"",$0)
  gsub(/Street:/,"Street,",$0)
  gsub(/Name:/,"Name,",$0)
  gsub(/Organization:/,"Organization,",$0)
  gsub(/City:/,"City,",$0)
  gsub(/State\/Province:/,"State/Province,",$0)
  gsub(/Postal Code:/,"Postal Code,",$0)
  gsub(/Country:/,"Country,",$0)
  gsub(/Phone:/,"Phone,",$0)
  gsub(/Fax:/,"Fax,",$0)
  gsub(/Email:/,"Email,",$0)
  print role " " $0
}
END {
  print "Registrant Phone Ext:,"
  print "Registrant Fax Ext:,"
  print "Admin Phone Ext:,"
  print "Admin Fax Ext:,"
  print "Tech Phone Ext:,"
  print "Tech Fax Ext:,"
}
' > "$1.csv"
