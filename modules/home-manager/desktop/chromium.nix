{
  lib,
  config,
  outputs,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
in
{
  options.xokdvium.home.desktop = {
    chromium = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "chromium";
        category = "desktop";
        autoEnable = false;
      };
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.chromium;
    in
    lib.mkIf cfg.enable {
      programs.chromium = {
        enable = true;
      };

      home.persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".config/chromium" ]; };
    };
}
