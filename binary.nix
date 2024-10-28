{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  ht
  ghidra
  imhex
]
