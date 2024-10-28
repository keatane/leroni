{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  libgcc
  python3
  vscodium
  brave
  vlc
  neovim
]
