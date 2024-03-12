{ outputs, ... }:
let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in
{
  imports = [
    ./gpg.nix
    ./yubikey.nix
    ./utils.nix
  ];

  options.xokdvium.home.crypto = {
    enable = mkHomeCategoryEnableOption "crypto";
  };
}
