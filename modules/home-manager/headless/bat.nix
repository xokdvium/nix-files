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
    bat = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "bat";
        category = "headless";
      };

      withExtras = lib.mkOption {
        description = "Enable bat extras (batman, batdiff, e.t.c.)";
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.bat;
  in
    lib.mkIf cfg.enable {
      programs = {
        bat = {
          enable = true;

          extraPackages = lib.optionals cfg.withExtras (with pkgs.bat-extras; [
            prettybat
            batwatch
            batpipe
            batman
            batgrep
            batdiff
          ]);
        };

        zsh.shellAliases = {
          bman = "batman";
        };
      };
    };
}
