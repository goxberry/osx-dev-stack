#!/bin/bash
set -eu

# Test check curl on system with curl
test_check_curl() {
    assertEquals 'Curl is supposed to exist!' 'Curl exists!' "$(check_curl)" 
}

# Load the install_os_tools.sh script
oneTimeSetUp() {
    . ./install_os_tools.sh
}

# Load test script for install_os_tools.sh.
. /usr/local/shunit2-2.1.6/src/shunit2

