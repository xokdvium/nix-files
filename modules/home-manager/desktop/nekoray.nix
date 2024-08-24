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
  options.xokdvium.home.desktop = {
    nekoray.enable = mkHomeCategoryModuleEnableOption config {
      name = "nekoray";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.nekoray;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ nekoray ];
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/nekoray" ];
      };
    };
}
