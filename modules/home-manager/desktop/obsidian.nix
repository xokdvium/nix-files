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
    obsidian.enable = mkHomeCategoryModuleEnableOption config {
      name = "obsidian";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.obsidian;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ obsidian ];
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/obsidian" ];
      };
    };
}
