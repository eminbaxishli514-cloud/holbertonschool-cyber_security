#!/bin/bash
find / -xdev -type d -perm -0002 ! -path "/proc/*" 2>/dev/null | tee /dev/tty | exec chmod o-w {} +
