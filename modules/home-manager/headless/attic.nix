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
    attic.enable = mkHomeCategoryModuleEnableOption config {
      name = "attic";
      category = "headless";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.attic;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ attic-client ];
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/attic" ];
      };
    };
}
