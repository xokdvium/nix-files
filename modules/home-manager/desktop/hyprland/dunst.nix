{
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
  cfg = config.xokdvium.home.desktop;
in {
  options.xokdvium.home.desktop = {
    dunst.enable = mkHomeCategoryModuleEnableOption config {
      name = "dunst";
      category = "desktop";
      autoEnable = cfg.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.dunst.enable {
    services.dunst = {
      enable = true;
    };
  };
}
