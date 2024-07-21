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
    telegram.enable = mkHomeCategoryModuleEnableOption config {
      name = "telegram";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.telegram;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [ telegram-desktop_git ];
      xokdvium.home.persistence = {
        state.dirs = [ ".local/share/TelegramDesktop" ];
      };
    };
}
