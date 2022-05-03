{ config, lib, pkgs, ... }: {

  options = {
    vscode.extensions = lib.mkOption { default = [ ]; };
    nixpkgs.latestPackages = lib.mkOption { default = [ ]; };
    # the following must be declared in configuration.nix
    vscode.user = lib.mkOption { };
    vscode.homeDir = lib.mkOption { };
  };

  config = {
    # fetch latest packages for this derivation
    nixpkgs.overlays = [
      (self: super:
        let
          latestPkgs = import
            (fetchTarball
              "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
            {
              config.allowUnfree = true;
            };
        in
        lib.genAttrs config.nixpkgs.latestPackages
          (pkg: latestPkgs."${pkg}"))
    ];

    system.activationScripts = {
      # symlink nixOS extensions to trick vscode into thinking they are installed
      fixVsCodeExtensions = {
        text = ''
          EXT_DIR=${config.vscode.homeDir}/.vscode-server/extensions
          mkdir -p $EXT_DIR
          chown ${config.vscode.user}:users $EXT_DIR
          for x in ${
            lib.concatMapStringsSep " " toString config.vscode.extensions
          }; do
            ln -sf $x/share/vscode/extensions/* $EXT_DIR/
          done
          chown -R ${config.vscode.user}:users $EXT_DIR
        '';
        deps = [ ];
      };
    };
  };
}
