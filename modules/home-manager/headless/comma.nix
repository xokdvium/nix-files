{
  inputs,
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
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.xokdvium.home.headless = {
    comma.enable = mkHomeCategoryModuleEnableOption config {
      name = "comma";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.comma;
  in
    lib.mkIf cfg.enable {
      programs = {
        nix-index = {
          enable = true;
          enableZshIntegration = true;
          enableBashIntegration = true;
        };

        nix-index-database.comma = {
          enable = true;
        };
      };
    };
}
