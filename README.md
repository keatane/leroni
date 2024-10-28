# Leroni - LnI
## Introduction
A bash automated script to install Nix (for current user only) and apps to any Linux distro.

The aim is to install stuff I personally need for my sistem, whatever it will be (Linux based).  
Provided with different flavours as categories of apps needed.

- work: work tools
- art: artistic software
- games: game platforms
etc.

To make your own configuration, just copy one of the .nix files and put in all the packages needed.  
Search for packages from the official site: https://search.nixos.org/packages 


## Helper
Please, provide one of the following arguments:
+ help -- provide this menu
+ install [config_1] [config_2] -- install nix and apps
+ uninstall -- remove nix and apps
+ apps [config_1] [config_2] -- install just apps of config files chosen, nix required

Note: omitting [config] files will install all config files in the current directory.
