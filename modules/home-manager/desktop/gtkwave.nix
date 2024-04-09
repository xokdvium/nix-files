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
    gtkwave.enable = mkHomeCategoryModuleEnableOption config {
      name = "gtkwave";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.gtkwave;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ gtkwave ]; };
}
