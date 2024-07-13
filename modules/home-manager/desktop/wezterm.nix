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
        extraConfig = # lua
          ''
            return {
              hide_tab_bar_if_only_one_tab = true,
              allow_square_glyphs_to_overflow_width = "Always",
            }
          '';
      };
    };
}
