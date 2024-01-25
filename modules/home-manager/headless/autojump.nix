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
    autojump.enable = mkHomeCategoryModuleEnableOption config {
      name = "autojump";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.autojump;
  in
    lib.mkIf cfg.enable {
      programs.autojump = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
        directories = [".local/share/autojump"];
      };
    };
}
