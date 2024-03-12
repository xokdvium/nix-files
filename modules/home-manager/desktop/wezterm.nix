{
  pkgs,
  inputs,
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
    wezterm.enable = mkHomeCategoryModuleEnableOption config {
      name = "wezterm";
      category = "desktop";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.wezterm;
    in
    lib.mkIf cfg.enable {
      programs.wezterm = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        package = inputs.wezterm.packages.${pkgs.system}.default;
      };
    };
}
