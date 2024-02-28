{
  pkgs,
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.headless = {
    attic.enable = mkHomeCategoryModuleEnableOption config {
      name = "attic";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.attic;
  in
    lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [
          attic-client
        ];

        persistence."/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
          directories = [".config/attic"];
        };
      };

      nix.settings = {
        substituters = [
          "https://attic.aeronas.ru/lp4a/"
          "https://attic.aeronas.ru/private/"
        ];

        trusted-public-keys = [
          "lp4a:Om07le0y+rXgyAo7tM2gWoWVKok18uqrxI7GB9DLtIE="
          "private:IvY1j71q2NBKHzakkPgOgP/OCVjKw7XNsPL1OV1umNU="
        ];
      };
    };
}
