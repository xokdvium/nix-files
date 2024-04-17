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
          };
          environmentVariables = {
            EDITOR = "${config.programs.helix.package}/bin/hx";
          };
        };
      };
    };
}
