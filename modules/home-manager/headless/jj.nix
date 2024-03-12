{
  pkgs,
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
    jujutsu.enable = mkHomeCategoryModuleEnableOption config {
      name = "jujutsu";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.jujutsu;
    in
    lib.mkIf cfg.enable {
      programs.jujutsu = {
        enable = true;
        package = pkgs.jujutsu_git;
        settings = {
          user =
            let
              gitConf = config.programs.git;
            in
            {
              name = gitConf.userName;
              email = gitConf.userEmail;
            };
        };
      };
    };
}
