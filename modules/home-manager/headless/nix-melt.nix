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
    nix-melt.enable = mkHomeCategoryModuleEnableOption config {
      name = "nix-melt";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.nix-melt;
    in
    lib.mkIf cfg.enable {
      # deadnix: skip
      home.packages = with pkgs; [
        # nix-melt 
      ];
    };
}
