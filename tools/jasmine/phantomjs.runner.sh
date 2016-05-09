#!/bin/bash

##############################################################################
# Finds the bin directory where node and npm are installed, or installs a
# local copy of them in a temp folder if not found. Then outputs where they
# are.
#
# Usage and install instructions:
# https://github.com/hugojosefson/find-node-or-install
##############################################################################

# Creates temp dir which stays the same every time this script executes
function setTEMP_DIR()
{
  local NEW_OS_SUGGESTED_TEMP_FILE=$(mktemp -t asdXXXXX)
  local OS_ROOT_TEMP_DIR=$(dirname ${NEW_OS_SUGGESTED_TEMP_FILE})
  rm ${NEW_OS_SUGGESTED_TEMP_FILE}
  TEMP_DIR=${OS_ROOT_TEMP_DIR}/nvm
  rm -rf ${TEMP_DIR}
  mkdir -p ${TEMP_DIR}
}

# Break on error
set -e

# Did not find node. Better install it.
# Do it in a temp dir, which stays the same every time this script executes
setTEMP_DIR
cd ${TEMP_DIR}

# Do we have nvm here?
if [[ ! -d "nvm" ]]; then
git clone git://github.com/creationix/nvm.git >/dev/null
fi

# Clear and set NVM_* env variables to our installation
mkdir -p .nvm
export NVM_DIR=$( (cd .nvm && pwd) )
unset NVM_PATH
unset NVM_BIN

# Load nvm into current shell
. nvm/nvm.sh >/dev/null

# Install and use latest 6.x.x node
nvm install 6 >/dev/null
nvm alias default 6 >/dev/null
nvm use default --delete-prefix v6.1.0 --silent >/dev/null

# Find and output node's bin directory
NODE=$(which node)
NPM=$(which npm)
NPM install -g phantomjs

# sanity check number of args
if [ $# -lt 1 ]
then
    echo "Usage: `basename $0` path_to_runner.html"
    echo
    exit 1
fi

SCRIPTDIR=$(dirname `perl -e 'use Cwd "abs_path";print abs_path(shift)' $0`)
TESTFILE=""
while (( "$#" )); do
    if [ ${1:0:7} == "http://" -o ${1:0:8} == "https://" ]; then
        TESTFILE="$TESTFILE $1"
    else
        TESTFILE="$TESTFILE `perl -e 'use Cwd "abs_path";print abs_path(shift)' $1`"
    fi
    shift
done

# cleanup previous test runs
cd $SCRIPTDIR
rm -f *.xml

# make sure phantomjs submodule is initialized
cd ..
git submodule update --init

# fire up the phantomjs environment and run the test
cd $SCRIPTDIR
/usr/bin/env phantomjs $SCRIPTDIR/phantomjs-testrunner.js $TESTFILE

rm -rf ${TEMP_DIR}
