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
  imports = [../../modules/common.nix nix-colors.homeManagerModule];

  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "sergeiz";
    homeDirectory = lib.mkDefault "/home/sergeiz";
    stateVersion = lib.mkDefault "23.05";
  };

  systemd.user.startServices = "sd-switch";
}
