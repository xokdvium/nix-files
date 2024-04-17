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
        # -- monitoring processes --
        bandwidth # - tell which processes utilize bandwidth
        procs # procs - better top
        # -- cli tools for one-liners --
        du-dust # du - better du
        ncdu # ncdu - tui du
        fd # fd - better find
        ripgrep # rg - better grep
        file # - show what's in the file
        gptfdisk # - working with disks
        usbutils # - tools for working with usb devices (like lsusb)
        hyperfine # hyperfine - quick benchmarks
        tokei # tokei - count lines of code
        # -- misc tools for productivity --
        glow # - terminal markdown reader
        bitwise # - bitwise calculator
        libqalculate # - cli calculator
        # -- working with containers --
        distrobox # - to run non-nix based containers
        # -- text/structured data processing --
        jq # - json processor
        yq # - yaml processor
        sd # sd - better sed
        grex # grex - to battle regex
        dyff # - diff tool for yaml (json)
      ];
    };
}
