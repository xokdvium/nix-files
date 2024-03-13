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
    factorio.enable = mkHomeCategoryModuleEnableOption config {
      name = "factorio";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.factorio;
    in
    lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [ factorio ];
        persistence = {
          "/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
            directories = [ ".factorio" ];
          };
        };
      };
    };
}
