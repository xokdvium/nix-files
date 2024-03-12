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
    btop.enable = mkHomeCategoryModuleEnableOption config {
      name = "btop";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.btop;
    in
    lib.mkIf cfg.enable {
      programs.btop = {
        enable = true;
      };
    };
}
