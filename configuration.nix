{ config, pkgs, lib, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl/default.nix;
in
{
  imports = [
    ./home.nix
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "haoxiangliew";
    startMenuLaunchers = true;
    # docker-native.enable = true;
    # docker-desktop.enable = true;
  };

  system = {
    stateVersion = config.system.nixos.release;
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "haoxiangliew" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import
          (builtins.fetchTarball
            "https://github.com/nix-community/NUR/archive/master.tar.gz")
          {
            inherit pkgs;
          };
      };
    };
    overlays =
      let
        neovimOverlay = (import (builtins.fetchTarball {
          url =
            "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
        }));
      in
      [ neovimOverlay ];
  };

  environment = {
    systemPackages = with pkgs; [
      fd
      fzf
      git
      htop
      neofetch
      p7zip
      psmisc
      ranger
      ripgrep
      thefuck
      tree
      unrar
      unzip
      wget
    ];
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      cascadia-code
      cm_unicode
      corefonts
      dejavu_fonts
      font-awesome_4
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      source-han-sans
      source-han-serif
      ubuntu_font_family
      vistafonts
    ];
    fontconfig = {
      enable = true;
      cache32Bit = true;
      defaultFonts = {
        serif = [ "Liberation Serif" "Source Han Serif" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Ubuntu" "Source Han Sans" ];
        monospace = [ "Cascadia Code" ];
      };
    };
  };

  programs = {
    fish = {
      enable = true;
      shellInit = builtins.readFile ./dotfiles/fish/config.fish;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      withRuby = true;
      withPython3 = true;
      withNodeJs = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    dconf.enable = true;
  };

  services = {
    openssh.enable = true;
    pcscd.enable = true;
  };

  security = {
    sudo = {
      wheelNeedsPassword = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      gtkUsePortal = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };

  users = {
    users.haoxiangliew = {
      createHome = true;
      home = "/home/haoxiangliew";
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
