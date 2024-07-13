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
      modDrv = pkgs.factorio-utils.modDrv {
        allRecommendedMods = true;
        allOptionalMods = false;
      };

      helmod =
        let
          version = "0.12.20";
          name = "helmod";
        in
        modDrv {
          src = pkgs.fetchurl {
            url = "https://github.com/Helfima/${name}/archive/refs/tags/${version}.zip";
            hash = "sha256-m7Mdnmk0koZbv3TDoXDVkjB3ZjdM+Ew96kFsSSEDdNQ=";
            name = "${name}_${version}.zip";
          };
        };

      factorioWithMods = pkgs.factorio.override { mods = [ helmod ]; };
    in
    lib.mkIf cfg.enable {
      home = {
        packages = [ factorioWithMods ];
        persistence = {
          "/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
            directories = [ ".factorio" ];
          };
        };
      };
    };
}
