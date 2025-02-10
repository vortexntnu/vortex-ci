#!/bin/usr/env python

import yaml

def read(file):
    with open(file, 'r') as file:
        try:
            config = yaml.safe_load(file)
            if not validate(config):
                return False
            return config
        except yaml.YAMLError as e:
            print("[0] - Error while parsing {file}: {e}")

def validate(config):
    # TODO: Your validation logic here
    if 'network' not in config:
        print("[0] - Network configuration is missing")
        return False
    return True
