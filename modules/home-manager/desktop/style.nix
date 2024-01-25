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
    style.enable = mkHomeCategoryModuleEnableOption config {
      name = "style";
      category = "desktop";
    };
  };

  config = let
    cfg = config.xokdvium.home.desktop.style;
  in
    lib.mkIf cfg.enable {
      gtk.iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders;
      };
    };
}
