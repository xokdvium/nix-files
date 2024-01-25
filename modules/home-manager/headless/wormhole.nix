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
    magic-wormhole.enable = mkHomeCategoryModuleEnableOption config {
      name = "magic-wormhole";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.magic-wormhole;
  in
    lib.mkIf cfg.enable {
      programs.magic-wormhole = {
        enable = true;
      };
    };
}
