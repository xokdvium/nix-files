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
    prusa-slicer.enable = mkHomeCategoryModuleEnableOption config {
      name = "prusa-slicer";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.prusa-slicer;
    in
    {
      home.packages = lib.mkIf cfg.enable (with pkgs; [ prusa-slicer ]);
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/PrusaSlicer" ];
      };
    };
}
