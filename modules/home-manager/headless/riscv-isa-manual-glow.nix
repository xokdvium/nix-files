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
  options.xokdvium.home.headless = {
    riscv-isa-manual-glow.enable = mkHomeCategoryModuleEnableOption config {
      name = "riscv-isa-manual-glow";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.riscv-isa-manual-glow;
    in
    lib.mkIf cfg.enable {
      home.packages = [
        inputs.riscv-isa-manual-glow.packages.${pkgs.system}.default
      ];
    };
}
