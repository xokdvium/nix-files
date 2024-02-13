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
    fuzzel.enable = mkHomeCategoryModuleEnableOption config {
      name = "fuzzel";
      category = "desktop";
      autoEnable = cfg.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          fuzzy = true;
          terminal = "${config.programs.alacritty.package}/bin/alacritty";
        };
        border = let
          hyprConf =
            config.wayland.windowManager.hyprland.settings;
        in {
          width = hyprConf.general.border_size;
          radius = hyprConf.decoration.rounding;
        };
      };
    };
  };
}
