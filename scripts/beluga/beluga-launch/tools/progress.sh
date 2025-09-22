#!/bin/bash

bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_char_fail="X"
bar_percentage_scale=2

function show_progress {
    current="$1"
    total="$2"
    error="$3"

    success='\033[32m'
    fail='\033[0;31m'
    nc='\033[0m'

    # calculate the progress in percentage
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

    if [ $total -eq $current ]; then
        echo -ne $success
        echo -ne "\nDONE\n"
        echo -ne $nc
    fi

    if [ "$error" = "true" ]; then
        done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_fail}")
        echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"
        echo -ne $fail
        echo -ne "\nFail\n"
        echo -ne $nc
    fi
}
