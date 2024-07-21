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
    zoxide.enable = mkHomeCategoryModuleEnableOption config {
      name = "zoxide";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.zoxide;
    in
    lib.mkIf cfg.enable {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".local/share/zoxide" ];
      };
    };
}
