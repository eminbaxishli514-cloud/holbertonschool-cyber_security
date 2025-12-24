#!/bin/bash
sudo iptables -F && sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT && sudo iptables -A INPUT -j DROP && sudo ip6tables -F && sudo ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT && sudo ip6tables -A INPUT -j DROP && echo "Rules updated" && echo "Rules updated (v6)"
