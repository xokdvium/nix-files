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
    nushell.enable = mkHomeCategoryModuleEnableOption config {
      name = "nushell";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.nushell;
    in
    lib.mkIf cfg.enable {
      programs = {
        nushell = {
          enable = true;
          shellAliases = {
            lla = "ls -al";
            ll = "ls -ll";
            la = "ls -a";
          };

          configFile.text = ''
            $env.config = {
              edit_mode: vi
            }
          '';

          environmentVariables = {
            EDITOR = "${config.programs.helix.package}/bin/hx";
          };
        };
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".config/nushell" ];
      };
    };
}
