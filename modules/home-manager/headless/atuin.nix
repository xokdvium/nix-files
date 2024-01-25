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
    atuin.enable = mkHomeCategoryModuleEnableOption config {
      name = "atuin";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.atuin;
  in
    lib.mkIf cfg.enable {
      programs.atuin = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
}
