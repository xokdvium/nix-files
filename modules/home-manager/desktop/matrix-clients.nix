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
    matrix-clients.enable = mkHomeCategoryModuleEnableOption config {
      name = "matrix-clients";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.matrix-clients;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        element-desktop
      ];

      xokdvium.home.persistence = {
        persist.dirs = [
          ".config/Element"
          ".config/Riot"
        ];
      };
    };
}
