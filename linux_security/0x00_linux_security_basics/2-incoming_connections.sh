#!/bin/bash
# Allow only incoming TCP connections on port 80

# IPv4
sudo iptables -F                 # Flush existing rules
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -j DROP   # Drop everything else

echo "Rules updated"

# IPv6
sudo ip6tables -F
sudo ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo ip6tables -A INPUT -j DROP

echo "Rules updated (v6)"
