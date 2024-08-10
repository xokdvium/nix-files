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
    gopass.enable = mkHomeCategoryModuleEnableOption config {
      name = "gopass";
      category = "crypto";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.crypto.gopass;
    in
    lib.mkIf cfg.enable {
      programs.password-store = {
        enable = true;
        package = pkgs.gopass;
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".local/share/gopass" ];
      };
    };
}
