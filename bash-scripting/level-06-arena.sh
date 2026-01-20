#!/bin/bash


file_name="$1"

if [ $# -eq 0 ]; then
    echo "No file provided"
elif [ ! -f "$file_name" ]; then
    echo "File does not exist"
else
    wc -l < "$file_name"
fi