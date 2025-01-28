#!/bin/bash

c=1

echo -ne "c: $c\n"

((c++))

echo -ne "c: $c\n"

let "c++"

echo -ne "c: $c\n"

echo -ne "\033[0;33mwarning \033[0m \n"