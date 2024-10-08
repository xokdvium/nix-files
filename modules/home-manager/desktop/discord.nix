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
    discord.enable = mkHomeCategoryModuleEnableOption config {
      name = "discord";
      category = "desktop";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.discord;
    in
    lib.mkIf cfg.enable { home.packages = with pkgs; [ discord ]; };
}
