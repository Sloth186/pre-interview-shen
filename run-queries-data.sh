#! /usr/local/bin/bash
DIR=$@
resultre="(unknown|sat|unsat)"
queryre="driver::filename = queries\/([a-zA-Z0-9_\/\.-]+)"
benchmarkre="global::totalTime = ([0-9]+)ms"
printf "QueryName,Result,ElapsedTime\n" &> data.csv
for file in "$DIR"/*
do
    printf "$(basename $file)\n"
    result="null"
    query="null"
    benchmark="null"
    (./cvc5 $file --tlimit-per=60000 --stats) &> output.txt
    while read line
    do
        if [[ $line =~ $resultre ]]; then
            result="${BASH_REMATCH[1]}"
            if [[ $result == "unknown" ]]; then
                result="TIMEOUT"
            else
                if [[ $result == "unsat" ]]; then
                    result="UNSAT"
                else
                    result="SAT"
                fi
            fi
        else
            if [[ $line =~ $queryre ]]; then
                query="${BASH_REMATCH[1]}"
            else
                if [[ $line =~ $benchmarkre ]]; then
                    benchmark="${BASH_REMATCH[1]}\n"
                fi
            fi
        fi
    done <<< "$(cat output.txt)"
    printf "$query,$result,$benchmark" &>> data.csv
done