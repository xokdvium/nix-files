{ outputs, ... }:
let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in
{
  imports = [
    ./gopass.nix
    ./gpg.nix
    ./utils.nix
    ./yubikey.nix
  ];

  options.xokdvium.home.crypto = {
    enable = mkHomeCategoryEnableOption "crypto";
  };
}
