# NOTE: This file declares the theme for stylix and fontProfiles.
# This module can be included in either home-manager or nixos configuration.
# You are required to import the corresponding stylix module yourself.
{ lib, ... }:
{
  imports = [
    ./fonts.nix
    ./stylix.nix
    ./presets.nix
  ];

  options.xokdvium.common.style = {
    enable = lib.mkEnableOption "style";
  };
}
