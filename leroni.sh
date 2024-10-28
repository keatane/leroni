#!/bin/bash

config="all"

printf "[*] - Welcome to Leroni - LnI installer\n"
printf "[!] - Please take note that this script will asks for root privileges\n"

if [ $# -eq 0 ]; then
    printf "[X] - No arguments supplied, exiting...\n"
    exit -1
fi

request=$1 
shift

# Check if at least one config file has been provided
if [ $# -gt 0 ]; then
    config=$@
fi

leroni-help(){
    printf "\n------------------------------------------------------------------------------\n"
    printf "\nLeroni - Helper\n\n"
    printf "Please, provide one of the following arguments:\n"
    printf "+ help \t\t\t\t\t-- provide this menu\n"
    printf "+ install [config_1] [config_2] \t-- install nix and apps\n"
    printf "+ uninstall \t\t\t\t-- remove nix and apps\n"
    printf "+ apps [config_1] [config_2]\t\t-- install just apps of config files chosen, nix required\n"
    printf "\nNote: omitting [config] files will install all config files in the current directly.\n"
    printf "\n------------------------------------------------------------------------------\n\n"
}

nix-uninstall(){
    printf "[*] - Removing Nix and installed apps...\n"
    sudo rm -rf /nix ~/.nix-channels ~/.nix-defexpr ~/.nix-profile
    printf "[V] - Removal completed, exiting...\n"
}

nix-install(){
    printf "[*] - Starting system initialization...\n\n"
    nix-env --version
    if [ "$?" -eq 127 ]; then
        printf "[*] - Installing Nix package manager...\n"
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
    else
        echo [!] - Nix package manager already exists, exiting...
        exit -2
    fi
    . /home/keat/.nix-profile/etc/profile.d/nix.sh

    nix-env --version
    if [ "$?" -eq 127 ]; then
        printf "[X] - Some errors occured while installing Nix, exiting...\n"
        exit -1
    fi
    printf "[V] - Nix installation has succedeed, exiting...\n"
}

app-install(){
    nix-env --version > /dev/null
    if [ "$?" -eq 127 ]; then
        printf "[X] - No Nix installed, exiting...\n"
        exit -1
    fi

    # Map app installation depending on argument
    printf "\n[*] - Starting app installation from Nix\n"
    if [[ $config = "all" ]]; then
        printf "[*] - All configurations loaded\n"
        for file in *.nix; do
            printf "\n[*] - $file configuration loaded, installing apps...\n"
            export NIXPKGS_ALLOW_UNFREE=1
            nix-env -i -f "$file"
        done
    else
        for arg in $config; do
            if test -f "$arg.nix"; then
                printf "\n[*] - $arg configuration loaded, installing apps...\n"
                export NIXPKGS_ALLOW_UNFREE=1
                nix-env -i -f "$arg.nix"
            else
                printf "\n[X] - Missing $arg.nix file, no app will be installed\n"
                exit -1
            fi
        done
    fi
    printf "\n[V] - App installation finished, a reboot is suggested, exiting...\n"
}

# Map arguments
if [[ $request = "help" ]]; then
    leroni-help

elif [[ $request = "uninstall" ]]; then
    nix-uninstall

elif [[ $request = "install" ]]; then
    nix-install
    app-install

elif [[ $request = "apps" ]]; then
    app-install

else
    printf "\n[X] - Command not recognized\n"
    leroni-help
fi
