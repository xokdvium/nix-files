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
  options.xokdvium.home.headless = {
    direnv.enable = mkHomeCategoryModuleEnableOption config {
      name = "direnv";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.direnv;
    in
    lib.mkIf cfg.enable {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".local/share/direnv" ];
      };
    };
}
