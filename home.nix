# Hao Xiang's nixos-unstable home configuration

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    (import (builtins.fetchTarball
      "https://github.com/jonascarpay/declarative-cachix/archive/master.tar.gz"))
    ./vscode-server.nix
  ];

  cachix = [ "nix-community" ];

  vscode = {
    user = "haoxiangliew";
    homeDir = "/home/haoxiangliew";
    extensions = with pkgs.vscode-extensions; [ ms-vscode.cpptools ];
  };

  nixpkgs.latestPackages = [ "vscode-extensions" ];

  home-manager.users.haoxiangliew = {

    home = { stateVersion = config.system.nixos.release; };

    imports = [
      "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
    ];

    nixpkgs = {
      config.allowUnfree = true;
    };

    gtk = {
      enable = true;
      font = {
        name = "Ubuntu";
        package = pkgs.ubuntu_font_family;
      };
      cursorTheme = {
        name = "Capitaine Cursors";
        package = pkgs.capitaine-cursors;
        size = 8;
      };
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        package = pkgs.libsForQt5.qtstyleplugins;
        name = "gtk2";
      };
    };

    home.packages = with pkgs; [
      # apps
      youtube-dl

      # devtools
      # c / c++
      clang
      clang-tools
      gdb
      gnumake
      ninja
      avrdude
      pkgsCross.avr.buildPackages.binutils
      pkgsCross.avr.buildPackages.gcc
      # git
      gitAndTools.delta
      # latex
      pandoc
      texlab
      texlive.combined.scheme-full
      # nix
      direnv
      nixfmt
      nixpkgs-fmt
      rnix-lsp
      # python
      python3Full
    ];

    services = {
      vscode-server.enable = true;
    };
  };
}
