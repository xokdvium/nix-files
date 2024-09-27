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
    rust-tools.enable = mkHomeCategoryModuleEnableOption config {
      name = "rust-tools";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.rust-tools;
    in
    lib.mkIf cfg.enable {
      xokdvium.home.persistence = {
        state.dirs = [ ".cargo/registry" ];
      };
    };
}
