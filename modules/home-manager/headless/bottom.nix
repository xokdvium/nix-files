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
    bottom.enable = mkHomeCategoryModuleEnableOption config {
      name = "bottom";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.bottom;
    in
    lib.mkIf cfg.enable {
      programs.bottom = {
        enable = true;
      };
    };
}
