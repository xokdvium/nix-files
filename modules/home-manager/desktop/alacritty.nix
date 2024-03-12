{
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
    alacritty.enable = mkHomeCategoryModuleEnableOption config {
      name = "alacritty";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.alacritty;
    in
    lib.mkIf cfg.enable {
      programs.alacritty = {
        enable = true;
      };
    };
}
