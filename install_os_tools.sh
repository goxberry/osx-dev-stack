#!/bin/bash
set -eu

# This shell script carries out the "install OS" layer of provisioning by
# installing base tools needed to carry out the subsequent steps of system
# configuration and application deployment mentioned in the README.

# Function checking for cURL; if it doesn't exist, exit & output
# location of website containing cURL binary for installation.
check_curl() {
    (which curl > /dev/null) && echo 'Curl exists!' || { \
        echo 'Curl does not exist!'; \
        echo 'Download Curl!'; \
        echo 'http://curl.haxx.se/download.html'; }
}

# Function that finds and returns Mac OS X system version
find_osx_vers() {
    echo `sw_vers | grep ProductVersion | cut -f2`
}

# Function that finds and returns URL for Xcode compiler tools

# Function that downloads and installs Xcode compiler tools

# Function that checks for Ruby; if it doesn't exist, download &
# install

# Function that checks for Ruby Gems; if it doesn't exist, then
# download & install

# Function that checks for X11 or XQuartz; if it doesn't exist, then
# download & install

# Function that checks for existence of Homebrew; if it doesn't exist,
# then download, install, & configure

# Function that checks for existence of Git; if it doesn't exist, then
# download & install using Homebrew.

# Function that downloads the osx-dev-stack Git repo to user home
# directory, initializes any needed submodules, and updates them

# Function that checks for existence of Puppet; if it doesn't exist, download &
# install Puppet.

# Invoke puppet for system configuration; Puppet config should ensure
# that Git is installed in addition to installing other packages via
# Homebrew. Puppet can also take care of application deployment step
# by invoking Fabric.

# Download and install DMG and app-related software here? Don't want
# to do this step in Puppet because Puppet won't uninstall Mac Apps
# installed via dmg, pkg, or mpkg.

# Add system customization steps here?