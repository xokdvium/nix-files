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
  options.xokdvium.home.desktop = {
    ferdium.enable = mkHomeCategoryModuleEnableOption config {
      name = "ferdium";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.ferdium;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ ferdium ];
      xokdvium.home.persistence = {
        state.dirs = [ ".config/Ferdium" ];
      };
    };
}
