#!/bin/bash

# This file was curated by Vortex - DevOps
# If any questions contact vortex devops

# source files and decleare global variable
# -----------------------------------------------------------------------------------------------------------

source ./tools/progress.sh      # progress bar, visulizing progress
source ./tools/yaml-parser.sh    # for parsing yaml config file

echo -ne "beluga-launch v0.0.1\n\n"

# -----------------------------------------------------------------------------------------------------------
# - init enviorment
# -----------------------------------------------------------------------------------------------------------

echo -ne "\033[1;30m"   # muted / grey color
# echo -ne "Initialize environment...\n"

# apt-get update -qq | echo -ne "Updating apt\n"
# apt-get upgrade -yqq | echo -ne "Upgrading apt\n"

# load config file
echo -ne "Loading config\n"
eval $(parse_yaml launch-config.yaml)

parse_yaml launch-config.yaml

# check if ssh is installed on craptop
if dpkg -s openssh-client | grep -q "Status:"; then # if dpkg can find package openssh-client
    echo -ne ""
else # could not find package
    apt-get install -yqq openssh-client | echo -ne "Installing openssh-client\n" # install package openssh-client
fi

# chack is bc is installed on craptop
if dpkg -s bc | grep -q "Status:"; then
    echo -ne ""
else
    apt-get install -yqq bc | echo -ne "Installing bc\n"
fi

# check if ping is installed on craptop
if dpkg -s iputils-ping | grep -q "Status:"; then
    echo -ne ""
else
    apt-get install -yqq iputils-ping | echo -ne "Installing iputils-ping\n"
fi

echo -ne "\033[0m"  # no color

# -----------------------------------------------------------------------------------------------------------
# - launch beluga
# -----------------------------------------------------------------------------------------------------------

# task tracker / progressbar / log
tasks_in_total=37   # total amout of subtasks
current_task=1      # current task working with, for log messages
current_subtask=1   # current sub-task used with tasks in total to give an estimate of current progress
error="false"       # gives error in progressbar, IMPORTANT after error is sent to progressbar stop script

# color echo msg
success="\033[32m"      # green
fail="\033[0;31m"       # red
warning="\033[0;33m"    # yellow
nc="\033[0m"            # no color

echo -ne "\n"

# init progress bar
show_progress $current_subtask $tasks_in_total $error

# handshakes
# -----------------------------------------------------------------------------------------------------------

# handshake rpi
((current_subtask++))

# if able to ping rpi
if ping -q -c 4 $rpi | grep "100% packet loss"; then
    echo -ne "\r[${current_task}] $fail Failed to make contact with rasberrypi $nc \n \033[2K \n"
    error="true"
    show_progress $current_subtask $tasks_in_total $error
    exit 1 # end script
else
    echo -ne "\r[${current_task}] Successful handshake with rasberrypi \n \033[2K \n"
    show_progress $current_subtask $tasks_in_total $error
fi

# handshake xavier
((current_subtask++))

# if able to ping xavier
if ping -q -c 4 $xavier | grep "100% packet loss"; then
    echo -ne "\r[${current_task}] $fail Failed to make contact with Xavier $nc \n \033[2K \n"
    error="true"
    show_progress $current_subtask $tasks_in_total $error
    exit 1 # end script
else
    echo -ne "\r[${current_task}] Successful handshake with Xavier \n \033[2K \n"
    show_progress $current_subtask $tasks_in_total $error
fi

# confirm workspace (ws)
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

if ls | grep "vortex_ws"; then # check if vortex_ws exsists in current contex
    echo -ne "\r[${current_task}] Found vortex_ws, verifing integrity \n \033[2K \n"
    show_progress $current_subtask $tasks_in_total $error
    
    # repo = ...
    ((current_subtask++))
    if ls vortex_ws/ | grep ""; then
        # check if git repo
        # then, git pull
    else
        git clone ... /vortex_ws | echo -ne "\r[${current_task}] Cloning <repo> in vortex_ws \n \033[2K \n"
    fi
    show_progress $current_subtask $tasks_in_total $error

else # if vortex_ws did not exsist create repo
    echo -ne "\r[${current_task}] $warning Could not find vortex_ws, creating workspace $nc \n \033[2K \n"
    mkdir vortex_ws
    show_progress $current_subtask $tasks_in_total $error

    # clone all repos
    # repo = ...
    ((current_subtask++))
    git clone ... /vortex_ws | echo -ne "\r[${current_task}] Cloning <repo> in vortex_ws \n \033[2K \n"
    show_progress $current_subtask $tasks_in_total $error
fi

# check craptop's ws
# git status...
# git pull when needed

# mirror to rpi
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

# mirror to xavier
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

# start stuff on rpi
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

# start stuff on xavier
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

# validate rpi
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))

# validate xavier
# -----------------------------------------------------------------------------------------------------------

((current_subtask++))
((curent_task++))


tasks_in_total=37
for current_task in $(seq $tasks_in_total) # simulates progress... 
    do
    echo -ne "\e[1A"
    sleep 0.2 #simulate the task running
    error="false"
    echo -ne "\r[${current_task}] long and descriptive log message, which hopfuly are longer then the progress bar.       \n \033[2K \n"
    
    if [ $current_task -eq 40 ]; then
        msg=$(printf "problem with task ${current_task}")
        error="true"
        show_progress $current_task $tasks_in_total $error
        break
    else
        show_progress $current_task $tasks_in_total $error
    fi
    
done

echo -ne "\nBeluga ready\n"

# input mode - remote control, auto, sw FAT

# if remote check joysick connection
# setup

# if auto
# give option for ...