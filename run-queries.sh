#! /usr/local/bin/bash
DIR=$@
echo "Running cvc5 on all files in $DIR"
for file in "$DIR"/*
do
    echo "Checking $file..."
    ./cvc5 "$file" --tlimit=60000
done