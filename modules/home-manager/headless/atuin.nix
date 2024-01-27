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
    atuin = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "atuin";
        category = "headless";
      };

      noShellHistory = lib.mkEnableOption "noShellHistory";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.atuin;
  in
    lib.mkIf cfg.enable {
      programs = {
        atuin = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        zsh.history.path = lib.mkIf cfg.noShellHistory "/dev/null";
        bash.historyFile = lib.mkIf cfg.noShellHistory "/dev/null";
      };

      home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.xokdvium.home.persistence.enable {
        directories = [".local/share/atuin"];
      };
    };
}
