{
  pkgs,
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.headless = {
    dev-tools.enable = mkHomeCategoryModuleEnableOption config {
      name = "dev-tools";
      category = "headless";
      autoEnable = false;
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.dev-tools;
  in
    lib.mkIf cfg.enable {
      xokdvium.home.headless = {
        bottom.enable = true;
      };

      home.packages = with pkgs; [
        du-dust # du - better du
        ncdu # ncdu - tui du
        fd # fd - better find
        hyperfine # hyperfine - quick benchmarks
        procs # procs - better top
        tokei # tokei - count lines of code
        sd # sd - better sed
        grex # grex - to battle regex
        btop # btop - really cool top
        glow # glow - terminal .md reader
        distrobox # - to run non-nix based containers
        ripgrep # rg - better grep
      ];
    };
}
