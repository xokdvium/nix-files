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
    okular.enable = mkHomeCategoryModuleEnableOption config {
      name = "okular";
      category = "desktop";
    };
  };

  config = let
    cfg = config.xokdvium.home.desktop.okular;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        okular
      ];
    };
}
