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

  systemd.user.startServices = "sd-switch";
}
