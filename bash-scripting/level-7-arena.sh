#!/bin/bash

Directory="Arena"

if [ ! -d "$Directory" ]; then
    echo "No Directory Found"
fi

find "$Directory" -type f -name "*.txt" -exec ls -lh {} + | sort -k 5,5 -h | awk '{ print $5, $9 }'