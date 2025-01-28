#!/usr/bin/env python

# import scripts
from scripts import bash
from scripts import yaml

# --------------------------------------------
# - variables
# --------------------------------------------

# environment need these packages
pkgs = [
    "openssh-client",
    "iputils-ping",
]

# yaml config file
yaml_config = "config.yaml"

# print msg color
print_mute      = "\x1b[1;30m"
print_success   = "\033[32m"
print_warning   = "\033[0;33m"
print_error     = "\033[0;31m"
print_nc        = "\033[0m"

# --------------------------------------------
# - setup
# --------------------------------------------

print("Beluga launch v0.1.0")

print(print_mute, end="")

print("[0] - Validate environment")
for pkg in pkgs:
    if not bash.hasDPKG(pkg):
        if not bash.installDPKG(pkg):
            print("[0] - Unable to install ", pkg, sep="")
            break

print("[0] - Load config")
config = yaml.read(yaml_config)

print(print_nc, end="")

print(config['network']['rpi'])

# --------------------------------------------
# - not setup
# --------------------------------------------

import time

from rich.progress import Progress

with Progress(transient=True) as progress:

    task1 = progress.add_task("[dim]Setup...", total=1000)
    task2 = progress.add_task("[cyan]Starting...", total=1000)

    while not progress.finished:
        progress.update(task1, advance=10)
        progress.update(task2, advance=1)
        time.sleep(0.02)

# --------------------------------------------

print(print_success, "done", print_nc, sep="")