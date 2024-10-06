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
    hiddify-next.enable = mkHomeCategoryModuleEnableOption config {
      name = "hiddify-next";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.hiddify-next;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ hiddify-next ];
      xokdvium.home.persistence = {
        persist.dirs = [ ".local/share/app.hiddify.com" ];
      };
    };
}
