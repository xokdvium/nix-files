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
    plasma.enable = mkHomeCategoryModuleEnableOption config {
      name = "plasma";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.plasma;
    in
    lib.mkIf cfg.enable {
      stylix.targets.kde = {
        enable = true;
      };
    };
}
