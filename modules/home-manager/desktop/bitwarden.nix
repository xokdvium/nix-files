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
    bitwarden.enable = mkHomeCategoryModuleEnableOption config {
      name = "bitwarden";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.bitwarden;
    in
    lib.mkIf cfg.enable {
      # deadnix: skip
      home.packages = with pkgs; [
        # TODO: Fix build
        # bitwarden
      ];
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/Bitwarden" ];
      };
    };
}
