# something something... intresting
# uses 4 progress advance.

from scripts import bash

def FAT(progress, autofat, config) -> bool:
    # for all devices in network part of config
    for device in config['network']:

        # attempt to ping device
        if not bash.ping(device['ip_address']):
            return False
        progress.advance(autofat)

        # try ssh
        if not bash.ssh_ls(device):
            return False
        progress.advance(autofat)

        # validate env variables
        for variable in device["env_var"]:
            if not bash.valEnv(device, variable["name"], variable["value"]):
                return False
        progress.advance(autofat)

    return True
