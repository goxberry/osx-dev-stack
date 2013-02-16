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
    assertEquals 'Did not get correct URL!' 'https://github.com/goxberry/xcode-cli-tools/blob/master/xcode_cli_tools_10_7_4_Jan_2013.dmg' "$(get_compiler_tools_url)"
}

# Test the generation of the compiler tools file name
test_get_compiler_tools_filename() {
    assertEquals 'Did not generate name correctly!' 'Command Line Tools (Lion)' "$(get_compiler_tools_filename)"
}

# Dry run test of commands used in installing compiler tools
test_install_compiler_tools() {
    echo "$(install_compiler_tools)"
}

# Load the install_os_tools.sh script
oneTimeSetUp() {
    . ./install_os_tools.sh
}

# Load test script for install_os_tools.sh.
. /usr/local/shunit2-2.1.6/src/shunit2

