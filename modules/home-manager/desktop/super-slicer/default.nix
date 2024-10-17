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
  options.xokdvium.home.desktop = {
    super-slicer.enable = mkHomeCategoryModuleEnableOption config {
      name = "super-slicer";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.super-slicer;
    in
    {
      home.packages = lib.mkIf cfg.enable (
        with pkgs;
        [
          (super-slicer-latest.overrideAttrs (prev: {
            patches = prev.patches ++ [
              ./0001-fix-broken-include.patch
            ];
          }))
        ]
      );
      xokdvium.home.persistence = {
        persist.dirs = [ ".config/SuperSlicer" ];
      };
    };
}
