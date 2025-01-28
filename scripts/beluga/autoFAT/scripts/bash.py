#!/usr/bin/env python

import subprocess

# run command
def run(command: str) -> bool:
    # runs command
    result = subprocess.run(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)

    # Check the command's return code (0 means success)
    if result.returncode == 0:
        # environment has pkg
        return True
    else:
        # environment dont have pkg
        return False

# add ssh wraping to command
def ssh_run(ip: str, user: str, pwd: str, command: str) -> bool:
    # sshpass applies the password to an ssh command
    # ssh connect you to another device
    # you can "pipe" a command using ssh to execute the command on another device
    ssh_command = 'sshpass -p "{}" ssh {}@{} "{}"'.format(pwd, user, ip, command)
    
    return run(ssh_command)

# check if apt package exist on craptop
def hasDPKG(pkg: str) -> bool:
    # bash command to run ("> /dev/null 2>&1" removes output)
    command = 'dpkg -s ' + pkg + ' > /dev/null 2>&1'

    if run(command):
        return True
    else:
        print("\033[0;31m", "Error: ", "\033[0m", "Missing package: ", pkg, ", try: apt-get install ", pkg, sep="")
        return False

# ping device
def ping(ip: str) -> bool:
    command = 'ping -c 4 ' + ip + ' | grep "4 received" > /dev/null 2>&1'

    if run(command):
        return True
    else:
        print("\033[0;31m", "Error: ", "\033[0m", "Unable to ping/reach ", ip, sep="")
        return False

# test ssh by try to run ls though ssh
def ssh_ls(device: object) -> bool:
    command = 'ls > /dev/null 2>&1'
    
    if ssh_run(device["ip_address"], device["user"], device["password"], command):
        return True
    else:
        print("\033[0;31m", "Error: ", "\033[0m", "Unable to ssh into: ", device["name"], sep="")
        return False

# validate env var on devices though ssh
def valEnv(device: object, variable: str, value: str) -> bool:
    command = "cat ~/.bashrc | grep 'export {}' | grep '{}' > /dev/null 2>&1".format(variable, value)

    if ssh_run(device["ip_address"], device["user"], device["password"], command):
        return True
    else:
        print("\033[0;31m", "Error: ", "\033[0m", "Unable to find env variable ", variable, " with value ", value, " on ", device["name"],  sep="")
        return False
