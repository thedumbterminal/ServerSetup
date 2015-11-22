# ServerSetup

[![Build Status](https://travis-ci.org/thedumbterminal/ServerSetup.svg?branch=master)](https://travis-ci.org/thedumbterminal/ServerSetup)

Version your linux system configurations

## Install

See here for installation of cpanm, local::lib and Carton:

[System setup for modern perl projects](http://www.thedumbterminal.co.uk/posts/2015/02/system_setup_for_modern_perl_projects.html)

To install dependencies:

    carton install

## Usage

### Storing config

1. First create a new directory to store the config.
1. In this new directory create a child directory which matches the output of `hostname --fqdn`.
1. Add any addtional directories inside the above to mirror any required directory layout for a system's which config is required to be stored.
1. Next copy any config files on the system to the mirrored directory structure.

### Checking config

Run the following command to compare a system's config against the stored config:

    script/check_saved_config.pl <your storage directory>

## Testing

    prove