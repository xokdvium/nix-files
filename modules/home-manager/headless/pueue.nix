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
  options.xokdvium.home.headless = {
    pueue.enable = mkHomeCategoryModuleEnableOption config {
      name = "pueue";
      category = "headless";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.pueue;
    in
    lib.mkIf cfg.enable {
      services.pueue = {
        enable = true;
      };
    };
}
