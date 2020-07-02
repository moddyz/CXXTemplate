#!/bin/bash

# upgradeToLatestTemplate.sh
#
# Utility to upgrade the current CMakeTemplate-based project by pulling in the
# cmake modules from the latest state of the CMakeTemplate repository.
#
# This tool should be run at the _root_ of the current, local repository.

set -euxo pipefail

# Clone the CMakeTemplate project and copy a subset of files into the current repository.
rm -rf /tmp/CMakeTemplate
git clone https://github.com/moddyz/CMakeTemplate /tmp/CMakeTemplate
cp -r /tmp/CMakeTemplate/cmake/macros/* ./cmake/macros/
cp -r /tmp/CMakeTemplate/.clang-format ./
cp -r /tmp/CMakeTemplate/upgradeToLatestTemplate.sh ./
