#!/bin/bash
ps aux | grep "^$1" | grep -vE ' [0-9]+ 0 +0 '
