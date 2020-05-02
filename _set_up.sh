#!/bin/bash

################################################################################
### Set up everything in the correct order
################################################################################

source .exports
source set_up_dependencies.sh
source set_up_commit_signing.sh
source set_up_encrypted_resources.sh
source set_up_symlinks.sh
source set_up_user_defaults.sh
