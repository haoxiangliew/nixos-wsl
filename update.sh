#!/usr/bin/env bash

echo "Updating dotfiles..."

rm ./configuration.nix
echo "Removed ./configuration.nix"
rm ./home.nix
echo "Removed ./home.nix"
rm ./vscode-server.nix
echo "Removed ./vscode-server.nix"
rm -rf ./dotfiles
echo "Removed dotfiles"

cp /etc/nixos/configuration.nix ./
echo "Updated configuration.nix"
cp /etc/nixos/home.nix ./
echo "Updated home.nix"
cp /etc/nixos/vscode-server.nix ./
echo "Updated vscode-server.nix"
cp -r /etc/nixos/dotfiles ./
echo "Updated dotfiles"

echo
echo "All done!"