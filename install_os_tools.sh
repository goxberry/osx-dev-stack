#!/bin/bash
set -eu

# This shell script carries out the "install OS" layer of provisioning by
# installing base tools needed to carry out the subsequent steps of system
# configuration and application deployment mentioned in the README.

# Function checking for cURL; if it doesn't exist, exit & output
# location of website containing cURL binary for installation.
function check_curl() {
    (which curl > /dev/null) && echo 'Curl exists!' || { \
        echo 'Curl does not exist!'; \
        echo 'Download Curl!'; \
        echo 'http://curl.haxx.se/download.html'; \
        exit 1; }
}

# Function that finds and returns Mac OS X system version
function find_osx_vers() {
    echo `sw_vers | grep ProductVersion | cut -f2`
    #TODO(goxberry@gmail.com): Add error handling here.
}

# Function that finds and reutnrs Mac OS X system major version (i.e., 10.x)
function find_osx_maj_vers() {
    echo `sw_vers | grep ProductVersion | cut -f2 | cut -d '.' -f1-2`
    #TODO(goxberry@gmail.com): Add error handling here.
}

# Function that finds and returns URL for Xcode compiler tools
function get_compiler_tools_url() {
    # Store OS X version and major version
    local OSX_VERS="$(find_osx_vers)"
    local OSX_MAJ_VERS="$(find_osx_maj_vers)"

    # Package URLs
    local LION_URL='https://github.com/goxberry/xcode-cli-tools/blob/master/xcode_cli_tools_10_7_4_Jan_2013.dmg'
    local MTN_LION_URL='https://github.com/goxberry/xcode-cli-tools/blob/master/xcode_cli_tools_10_8_Jan_2013.dmg'

    # First, separate out by major version:
    # URLs are from my Google Drive, to skirt Apple's login requirement
    case "${OSX_MAJ_VERS}" in
        "10.7") # 10.7.x, aka "Lion"
            # Then test for minor version here to satisfy version >= 10.7.4
            if [[ "${OSX_VERS}" > "10.7.4" || "${OSX_VERS}" == "10.7.4" ]]
            then
                echo "${LION_URL}"
            else
                echo 'Must upgrade version of OS X to 10.7.4 or later!'
                echo 'To upgrade, use "sudo softwareupdate --install --all"'
                exit 1
            fi
            ;;
        "10.8") # 10.8.x, aka "Mountain Lion"
            echo "${MTN_LION_URL}"
            ;;
        *     ) # All other cases
            echo 'Must upgrade version of OS X to 10.7.4 or later!'
            echo 'To upgrade, use "sudo softwareupdate --install --all"'
            exit 1
            ;;
    esac

}

# Gets file name of compiler tools
function get_compiler_tools_filename() {
    local TOOLS_BASENAME='Command Line Tools '
    local OSX_MAJ_VERS="$(find_osx_maj_vers)"
    case "${OSX_MAJ_VERS}" in
        "10.7")
            local TOOLS_SUFFIX='(Lion)' ;;
        "10.8")
            local TOOLS_SUFFIX='(Mountain Lion)' ;;
    esac
    local TOOLS_FULLNAME=${TOOLS_BASENAME}${TOOLS_SUFFIX}
    echo "${TOOLS_FULLNAME}"
}

# Function that downloads and installs Xcode compiler tools
function install_compiler_tools() {
    local TOOLS_URL="$(get_compiler_tools_url)"

    # Process file names
    local TOOLS_FULLNAME="$(get_compiler_tools_filename)"
    local TOOLS_VOL='/Volumes/'${TOOLS_FULLNAME}
    local TOOLS_PKG=${TOOLS_VOL}${TOOLS_FULLNAME}'.mpkg'
    local TOOLS_FILE=${TOOLS_FULLNAME}'.dmg'

    # Download compiler tools
    echo 'Downloading '${TOOLS_FULLNAME}'...'
    curl -k -L -f -o "${TOOLS_FILE}" "${TOOLS_URL}" || { \
        echo 'Download of compiler tools failed!'; \
        exit 1; }

    # Mount the dmg, install the package, unmount the dmg (in subshell)
    echo 'Mounting '${TOOLS_FULLNAME}' volume...'
    hdiutil mount "${TOOLS_FILE}" || { \
        echo 'Mounting ${TOOLS_FILE} failed!'; \
        exit 1; }

    #echo 'Installing '${TOOLS_FULLNAME}' ...'
    #sudo installer --package "${TOOLS_PKG}" --target / || { \
    #    echo 'Installing ${TOOLS_PKG} failed!' ; \
    #    exit 1; }

    echo 'Unmounting '${TOOLS_FULLNAME}' volume...'
    (cd "${TOOLS_VOL}"; hdiutil unmount "${TOOLS_VOL}") || { \
        echo 'Unmounting ${TOOLS_VOL} failed!' ; \
        exit 1; }

    # Clean up by deleting downloaded file
    if [ -e "${TOOLS_FILE}" ]
        then
        rm -f "${TOOLS_FILE}"
        else
        : # Do nothing
    fi
}

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