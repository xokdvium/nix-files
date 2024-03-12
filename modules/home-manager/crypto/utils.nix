{
  pkgs,
  outputs,
  config,
  lib,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
in
{
  options.xokdvium.home.crypto = {
    utils.enable = mkHomeCategoryModuleEnableOption config {
      name = "utils";
      category = "crypto";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.crypto.utils;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        pwgen
        ssh-to-pgp
        diceware
        cryptsetup
        paperkey
        pinentry-curses
        age
      ];
    };
}
