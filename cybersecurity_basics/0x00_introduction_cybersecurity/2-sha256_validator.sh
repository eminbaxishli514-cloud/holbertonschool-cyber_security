#!/bin/bash
[ "$(sha256sum "$1" | cut -c1-64)" = "$2" ] && echo "$1: OK"
