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
    gaming.enable = mkHomeCategoryModuleEnableOption config {
      name = "gaming";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.gaming;
    in
    lib.mkIf cfg.enable {
      home.persistence = {
        "/state/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
          directories = [ ".local/share/Steam" ];
        };

        "/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
          directories = [ ".factorio" ];
        };
      };
    };
}
