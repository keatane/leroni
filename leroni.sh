#!/bin/bash

config="all"

printf "[*] - Welcome to Leroni - LnI installer\n"
printf "[!] - Please take note that this script will asks for root privileges\n"

if [ $# -eq 0 ]; then
    printf "[X] - No arguments supplied, exiting...\n"
    exit -1
fi

if [ $# -eq 2 ]; then
    config=$2
fi

leroni-help(){
    printf "\n------------------------------------------------------\n"
    printf "\nLeroni - Helper\n\n"
    printf "Please, provide one of the following arguments:\n"
    printf "+ help \t\t\t-- will provide this menu\n"
    printf "+ install [config] \t-- will install nix and apps\n"
    printf "+ uninstall \t\t-- will remove nix and apps\n"
    printf "+ apps [config]\t\t-- will install just apps of config chosen, nix required\n"
    printf "\nPossible configs: work, art\n"
    printf "(omitting will install all config files)\n"
    printf "\n------------------------------------------------------\n\n"
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
        if test -f "work.nix"; then
            printf "\n[*] - Work configuration loaded, installing apps...\n"
            nix-env -i -f "work.nix"
        else
            printf "\n[X] - Missing work.nix file, no app will be installed\n"
            exit -1
        fi
        if test -f "art.nix"; then
            printf "\n[*] - Art configuration loaded, installing apps...\n"
            nix-env -i -f "art.nix"
        else
            printf "\n[X] - Missing art.nix file, no app will be installed\n"
            exit -1
        fi
    
    elif [[ $config = "work" ]]; then
            if test -f "work.nix"; then
                printf "\n[*] - Work configuration loaded, installing apps...\n"
                nix-env -i -f "work.nix"
            else
                printf "\n[X] - Missing work.nix file, no app will be installed\n"
                exit -1
            fi
    elif [[ $config = "art" ]]; then
            if test -f "art.nix"; then
                printf "\n[*] - Art configuration loaded, installing apps...\n"
                nix-env -i -f "art.nix"
            else
                printf "\n[X] - Missing art.nix file, no app will be installed\n"
                exit -1
            fi
    elif [[ $config = "games" ]]; then
            if test -f "games.nix"; then
                printf "\n[*] - Games configuration loaded, installing apps...\n"
                export NIXPKGS_ALLOW_UNFREE=1
                nix-env -i -f "art.nix"
            else
                printf "\n[X] - Missing games.nix file, no app will be installed\n"
                exit -1
            fi
    fi
    printf "\n[V] - App installation finished, exiting...\n"
}

# Map arguments
if [ $1 = "help" ]; then
    leroni-help

elif [[ $1 = "uninstall" ]]; then
    nix-uninstall

elif [[ $1 = "install" ]]; then
    nix-install
    app-install

elif [[ $1 = "apps" ]]; then
    app-install

else
    printf "[X] - Command not recognized\n\n"
    leroni-help
fi
