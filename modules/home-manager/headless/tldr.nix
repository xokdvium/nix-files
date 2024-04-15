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
    tldr.enable = mkHomeCategoryModuleEnableOption config {
      name = "tldr";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.tldr;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ tldr ]; };
}
