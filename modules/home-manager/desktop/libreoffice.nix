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
    libreoffice.enable = mkHomeCategoryModuleEnableOption config {
      name = "libreoffice";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.libreoffice;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ libreoffice-fresh ]; };
}
