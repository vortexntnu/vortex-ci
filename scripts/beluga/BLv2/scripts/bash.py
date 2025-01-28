#!/usr/bin/env python

import subprocess

def run(command: str) -> bool:
    # runs command
    result = subprocess.run(command, shell=True)

    # Check the command's return code (0 means success)
    if result.returncode == 0:
        # environment has pkg
        return True
    else:
        # environment dont have pkg
        return False

def hasDPKG(pkg: str) -> bool:
    # bash command to run ("> /dev/null 2>&1" removes output)
    command = 'dpkg -s ' + pkg + ' > /dev/null 2>&1'

    return run(command)

def installDPKG(pkg: str) -> bool:
    # bash command to run ("> /dev/null 2>&1" removes output)
    command = 'apt-get install -yqq ' + pkg + ' > /dev/null 2>&1'

    print("[0] - Installing ", pkg, "...", sep="")

    return run(command)
