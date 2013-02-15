#!/bin/bash
set -eu

# Test check curl on system with curl
test_check_curl() {
    assertEquals 'Curl is supposed to exist!' 'Curl exists!' "$(check_curl)" 
}

# Test finding OS X version
test_find_osx_vers() {
    assertEquals 'Version is supposed to be 10.7.5!' '10.7.5' "$(find_osx_vers)"
}

# Test finding OS X major version
test_find_osx_maj_vers() {
    assertEquals 'Version is supposed to be 10.7!' '10.7' "$(find_osx_maj_vers)"
}

# Test getting URL
test_compiler_tools_url() {
    assertEquals 'Did not get correct URL!' 'https://docs.google.com/file/d/0B_ehEoEjfVy5akh4OV9IS0Rjb1E/edit?usp=sharing' "$(get_compiler_tools_url)"
}

# Load the install_os_tools.sh script
oneTimeSetUp() {
    . ./install_os_tools.sh
}

# Load test script for install_os_tools.sh.
. /usr/local/shunit2-2.1.6/src/shunit2

