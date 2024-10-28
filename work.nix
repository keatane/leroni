{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  libgcc
  python3
  podman
  vscodium
  brave
  vlc
  neovim
]
