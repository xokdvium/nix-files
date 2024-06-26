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

  config.home =
    let
      cfg = config.xokdvium.home.desktop.prusa-slicer;
    in
    {
      packages = lib.mkIf cfg.enable (with pkgs; [ prusa-slicer ]);
      persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".config/PrusaSlicer" ]; };
    };
}
