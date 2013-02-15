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
        echo 'http://curl.haxx.se/download.html'; \
        exit 1; }
}

# Function that finds and returns Mac OS X system version
find_osx_vers() {
    echo `sw_vers | grep ProductVersion | cut -f2`
}

# Function that finds and reutnrs Mac OS X system major version (i.e., 10.x)
find_osx_maj_vers() {
    echo `sw_vers | grep ProductVersion | cut -f2 | cut -d '.' -f1-2`
}

# Function that finds and returns URL for Xcode compiler tools
get_compiler_tools_url() {
    # Store OS X version and major version
    local OSX_VERS="$(find_osx_vers)"
    local OSX_MAJ_VERS="$(find_osx_maj_vers)"

    # First, separate out by major version:
    # URLs are from my Google Drive, to skirt Apple's login requirement
    case "${OSX_MAJ_VERS}" in
        "10.7") # 10.7.x, aka "Lion"
            # Then test for minor version here to satisfy version >= 10.7.4
            if [[ "${OSX_VERS}" > "10.7.4" || "${OSX_VERS}" == "10.7.4" ]]
            then
                echo 'https://docs.google.com/file/d/0B_ehEoEjfVy5akh4OV9IS0Rjb1E/edit?usp=sharing'
            else
                echo 'Must upgrade version of OS X to 10.7.4 or later!'
                echo 'To upgrade, use "sudo softwareupdate --install --all"'
                exit 1
            fi
            ;;
        "10.8") # 10.8.x, aka "Mountain Lion"
            echo 'https://docs.google.com/file/d/0B_ehEoEjfVy5Y1gtUWpXd1BLU1U/edit?usp=sharing'
            ;;
        *     ) # All other cases
            echo 'Must upgrade version of OS X to 10.7.4 or later!'
            echo 'To upgrade, use "sudo softwareupdate --install --all"'
            exit 1
            ;;
    esac

}

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