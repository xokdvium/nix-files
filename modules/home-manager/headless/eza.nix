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
  options.xokdvium.home.headless = {
    eza.enable = mkHomeCategoryModuleEnableOption config {
      name = "eza";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.eza;
    in
    lib.mkIf cfg.enable {
      programs.eza = {
        enable = true;
        git = true;
        icons = lib.mkDefault true;

        enableBashIntegration = true;
        enableFishIntegration = true;
        enableIonIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;

        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };
    };
}
