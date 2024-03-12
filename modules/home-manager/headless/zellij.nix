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
    zellij.enable = mkHomeCategoryModuleEnableOption config {
      name = "zellij";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.zellij;
    in
    lib.mkIf cfg.enable {
      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
}
