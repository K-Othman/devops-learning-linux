#!/bin/bash

DIRECTORY="Arena"
SEARCH_TERM="coding"

if [ ! -d "$DIRECTORY" ]; then
    echo "No DIRECTORY exist"
    exit 1
fi

if [ -z "$SEARCH_TERM" ]; then
    echo "no matches found"
    exit 1
fi

grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log 

if [ $? -ne 0 ]; then
    echo "no matches found"
    exit 1
fi
