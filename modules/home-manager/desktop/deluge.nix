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
    deluge.enable = mkHomeCategoryModuleEnableOption config {
      name = "deluge";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.deluge;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ deluge ]; };
}
