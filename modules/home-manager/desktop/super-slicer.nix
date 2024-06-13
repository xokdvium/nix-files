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
    super-slicer.enable = mkHomeCategoryModuleEnableOption config {
      name = "super-slicer";
      category = "desktop";
    };
  };

  config.home =
    let
      cfg = config.xokdvium.home.desktop.super-slicer;
    in
    {
      packages = lib.mkIf cfg.enable (with pkgs; [ super-slicer-latest ]);
      persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".config/SuperSlicer" ]; };
    };
}
