{
  pkgs,
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.desktop = {
    freecad.enable = mkHomeCategoryModuleEnableOption config {
      name = "freecad";
      category = "desktop";
      autoEnable = false;
    };
  };

  config = let
    cfg = config.xokdvium.home.desktop.freecad;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        freecad
      ];

      home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
        directories = [".config/FreeCAD"];
      };
    };
}
