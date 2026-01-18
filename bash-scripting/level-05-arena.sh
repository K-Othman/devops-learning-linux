#!/bin/bash


mkdir -p ./bash-scripting/Battlefield

touch ./Battlefield/knight.txt ./Battlefield/sorcerer.txt ./Battlefield/rogue.txt

mkdir -p ./bash-scripting/Archive

if [ -f "./Battlefield/knight.txt" ]; then
    mv  ./Battlefield/knight.txt ./bash-scripting/Archive
fi

ls ./bash-scripting/Battlefield ./bash-scripting/Archive