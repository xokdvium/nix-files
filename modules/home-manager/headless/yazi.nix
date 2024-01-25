{
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
    yazi.enable = mkHomeCategoryModuleEnableOption config {
      name = "yazi";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.yazi;
  in
    lib.mkIf cfg.enable {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
}
