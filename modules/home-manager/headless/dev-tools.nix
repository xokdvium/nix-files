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
  options.xokdvium.home.headless = {
    dev-tools.enable = mkHomeCategoryModuleEnableOption config {
      name = "dev-tools";
      category = "headless";
      autoEnable = false;
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.dev-tools;
    in
    lib.mkIf cfg.enable {
      xokdvium.home.headless = {
        bottom.enable = true;
        pueue.enable = true;
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
        glow # glow - terminal .md reader
        distrobox # - to run non-nix based containers
        ripgrep # rg - better grep
        file # - show what's in the file
        gptfdisk # - working with disks
        usbutils # - tools for working with usb devices (like lsusb)
      ];
    };
}
