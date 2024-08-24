{
  lib,
  config,
  outputs,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;
in
{
  options.xokdvium.home.desktop = {
    chromium = {
      enable = mkHomeCategoryModuleEnableOption config {
        name = "chromium";
        category = "desktop";
        autoEnable = false;
      };
    };
  };

  config =
    let
      cfg = config.xokdvium.home.desktop.chromium;
    in
    lib.mkIf cfg.enable {
      programs.chromium = {
        enable = true;
        extensions = [
          # WebRTC Network Limiter
          # https://chromewebstore.google.com/detail/npeicpdbkakmehahjeeohfdhnlpdklia
          { id = "npeicpdbkakmehahjeeohfdhnlpdklia"; }
        ];
      };

      xokdvium.home.persistence = {
        persist.dirs = [ ".config/chromium" ];
      };
    };
}
