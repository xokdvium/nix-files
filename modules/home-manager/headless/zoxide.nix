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

      home.persistence."/persistent/home/${config.home.username}" =
        lib.mkIf config.xokdvium.home.persistence.enable
          { directories = [ ".local/share/zoxide" ]; };
    };
}
