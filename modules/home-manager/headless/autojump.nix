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
    autojump.enable = mkHomeCategoryModuleEnableOption config {
      name = "autojump";
      category = "headless";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.autojump;
    in
    lib.mkIf cfg.enable {
      programs.autojump = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".local/share/autojump" ];
      };
    };
}
