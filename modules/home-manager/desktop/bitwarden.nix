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
      home.packages = with pkgs; [ bitwarden ];

      home.persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".config/Bitwarden" ]; };
    };
}
