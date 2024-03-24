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
    nix-closure-graph.enable = mkHomeCategoryModuleEnableOption config {
      name = "nix-closure-graph";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.nix-closure-graph;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ nix-closure-graph ]; };
}
