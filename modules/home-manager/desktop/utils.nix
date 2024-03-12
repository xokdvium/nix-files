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
    utils.enable = mkHomeCategoryModuleEnableOption config {
      name = "utils";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.utils;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        visidata
        tor-browser-bundle-bin
      ];
    };
}
