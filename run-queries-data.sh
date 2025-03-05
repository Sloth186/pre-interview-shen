#! /usr/local/bin/bash
DIR=$@
echo "Running cvc5 on all files in $DIR"
for file in "$DIR"/*
do
    echo "Checking $file..."
    time output=$(./cvc5 "$file" --tlimit=2000 --output=raw-benchmark)
    if [[ "$output" == "" ]]
    then
        echo "TIMEOUT"
    else
        if [[ "$output" == "sat" ]]
        then
            echo "SAT"
        else
            echo "UNSAT"
        fi
    fi
done