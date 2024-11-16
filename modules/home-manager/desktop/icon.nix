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
    icon = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "icon";
        category = "desktop";
      };

      icon = lib.mkOption {
        type = lib.types.path;
        description = "Path to the icon file.";
      };

    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.icon;
    in
    lib.mkIf cfg.enable {
      home.file.".face" = {
        source = cfg.icon;
      };
    };
}
