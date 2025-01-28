#!/usr/bin/env python

# imports
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn, TimeElapsedColumn
from rich.theme import Theme
from rich.console import Console
import time

# import scripts
from scripts import bash
from scripts import yaml

# import FATs
from scripts.FAT import devops
from scripts.FAT import perception
from scripts.FAT import autonomous

# --------------------------------------------
# - variables
# --------------------------------------------

# environment need these packages
env_pkgs = [
    "openssh-client",
    "iputils-ping",
    "sshpass",
]

# yaml config file
# yaml_config = "config.yaml"
yaml_config = "config.yaml"

# print msg color
# print_mute      = "\x1b[1;30m"
# print_success   = "\033[32m"
# print_warning   = "\033[0;33m"
# print_error     = "\033[0;31m"
# print_nc        = "\033[0m"

# fat rapport
version = "0.2.1"
devops_fat_status      = [False, "Not reached"]
perception_fat_status  = [False, "Depend on DevOps"]
autonomous_fat_status  = [False, "Depend on DevOps"]

def main() -> bool:
    # progress bar
    with Progress(
        TextColumn("[progress.description]{task.description}"),
        BarColumn(complete_style="cyan", finished_style="green"),
        TaskProgressColumn(),
        TimeElapsedColumn(),
    ) as progress:
        autofat = progress.add_task("[cyan]AutoFAT ", total=8)

        # --------------------------------------------
        # - setup
        # --------------------------------------------

        # check environment, is correct packages installed?
        for pkg in env_pkgs:
            # res, msg = bash.hasDPKG(pkg)
            if not bash.hasDPKG(pkg):
                return False
        progress.advance(autofat)

        # load config
        config = yaml.read(yaml_config)
        if not config:
            print("\033[0;31m", "Error: ", "\033[0m", "failed to read yaml config.", sep="")
            return False
        progress.advance(autofat)

        # --------------------------------------------
        # - DevOps FAT
        # --------------------------------------------

        # set status of FAT, failed util succeeded
        devops_fat_status[1] = "Failed"

        if devops.FAT(progress, autofat, config):
            devops_fat_status[1] = "Success"
            devops_fat_status[0] = True
        else:
            return False

        # --------------------------------------------
        # - Validate ROS
        # --------------------------------------------

        # TODO: check if ros exists, validate ROS related packages

        # --------------------------------------------
        # - Start ROS
        # --------------------------------------------

        # TODO: start ROS

        # sorce relevant stuff...
        # start ROS core


        # --------------------------------------------
        # - Perception FAT
        # --------------------------------------------

        # set status of FAT, failed util succeeded
        perception_fat_status[1] = "Failed"

        if perception.FAT(progress, autofat, config):
            perception_fat_status[1] = "Success"
            perception_fat_status[0] = True
        else:
            return False


        # --------------------------------------------
        # - Autonomous FAT
        # --------------------------------------------

        # set status of FAT, failed util succeeded
        autonomous_fat_status[1] = "Failed"

        if autonomous.FAT(progress, autofat, config):
            autonomous_fat_status[1] = "Success"
            autonomous_fat_status[0] = True
        else:
            return False

        # --------------------------------------------
        # - Stop ROS
        # --------------------------------------------


    return True

# --------------------------------------------

def raport():
    if devops_fat_status[0]:
        print("\nDevOps FAT: \t\t", "\033[32m", devops_fat_status[1], "\033[0m", sep="")
    else:
        print("\nDevOps FAT: \t\t", "\033[0;31m", devops_fat_status[1], "\033[0m", sep="")

    if perception_fat_status[0]:
        print("Perception FAT: \t", "\033[32m", perception_fat_status[1], "\033[0m", sep="")
    else:
        print("Perception FAT: \t", "\033[0;31m", perception_fat_status[1], "\033[0m", sep="")

    if autonomous_fat_status[0]:
        print("autonomous FAT: \t", "\033[32m", autonomous_fat_status[1], "\033[0m", sep="")
    else:
        print("autonomous FAT: \t", "\033[0;31m", autonomous_fat_status[1], "\033[0m", sep="")

# --------------------------------------------

if __name__ == "__main__":
    print("\x1b[1;30m", "automatied FAT v", version, "\033[0m", sep="")
    if main():
        print("\033[32m", "Done", "\033[0m", sep="")
    else:
        print("\033[0;31m", "Error", "\033[0m", sep="")

    raport()
