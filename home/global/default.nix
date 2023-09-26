{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: let
  inherit (inputs) nix-colors;
  inherit (nix-colors) colorSchemes;
  inherit (nix-colors.lib-contrib {inherit pkgs;}) colorschemeFromPicture;
in {
  imports =
    [
      ../features/common.nix
      nix-colors.homeManagerModule
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  colorScheme = lib.mkDefault nix-colors.colorSchemes.catppuccin-macchiato;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
