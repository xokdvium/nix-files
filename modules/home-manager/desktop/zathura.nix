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
  options.xokdvium.home.desktop = {
    zathura.enable = mkHomeCategoryModuleEnableOption config {
      name = "zathura";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.zathura;
    in
    lib.mkIf cfg.enable {
      programs.zathura = {
        enable = true;
      };

      xdg.mimeApps.defaultApplications = {
        "text/pdf" = [ "zathura.desktop" ];
        "x-scheme-handler/pdf" = [ "zathura.desktop" ];
      };
    };
}
