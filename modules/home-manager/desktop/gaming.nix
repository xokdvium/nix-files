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
    gaming.enable = mkHomeCategoryModuleEnableOption config {
      name = "gaming";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.gaming;
    in
    lib.mkIf cfg.enable {
      xokdvium.home.persistence = {
        state.dirs = [ ".local/share/Steam" ];
        persist.dirs = [ ".factorio" ];
      };
    };
}
