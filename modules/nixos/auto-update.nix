{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.xokdvium.nixos.autoUpdate;
in {
  options.xokdvium.nixos.autoUpdate = {
    enable = lib.mkEnableOption "auto-update";

    flake = lib.mkOption {
      type = lib.types.str;
      description = "Config flake";
      default = inputs.self.outPath;
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = cfg.flake;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
      dates = "daily";
      randomizedDelaySec = "1h";
    };
  };
}
