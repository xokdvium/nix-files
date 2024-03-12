{
  pkgs,
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
    nurl.enable = mkHomeCategoryModuleEnableOption config {
      name = "nurl";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.nurl;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ nurl ]; };
}
