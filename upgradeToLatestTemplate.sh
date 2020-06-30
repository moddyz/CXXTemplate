#!/bin/bash

# upgradeToLatestTemplate.sh
#
# Utility to upgrade the current CMakeTemplate-based project by pulling in the
# cmake modules from the latest state of the CMakeTemplate repository.
#
# This tool should be run at the _root_ of the current, local repository.

set -euxo pipefail

# Clone the CMakeTemplate project and copy all the files into the local repository.
rm -rf /tmp/CMakeTemplate
git clone https://github.com/moddyz/CMakeTemplate /tmp/CMakeTemplate
cp -r /tmp/CMakeTemplate/cmake/macros/* ./cmake/macros/
cp -r /tmp/CMakeTemplate/upgradeToLatestTemplate.sh ./
