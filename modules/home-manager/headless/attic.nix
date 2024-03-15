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
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.attic;
    in
    lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [ attic-client ];

        persistence."/persistent/home/${config.home.username}" =
          lib.mkIf config.xokdvium.home.persistence.enable
            { directories = [ ".config/attic" ]; };
      };

      nix.settings = {
        extra-substituters = [
          "https://attic.aeronas.ru/lp4a/"
          "https://attic.aeronas.ru/private/"
        ];

        extra-trusted-public-keys = [
          "lp4a:v95ilxwsZCHb678U95+2zBFw+va3HdndhHDjeehtrOA="
          "private:piCMDhXH9IYWPqDWBrPjgG0UutnonBDjVmFH49PIS3Q="
        ];
      };
    };
}
