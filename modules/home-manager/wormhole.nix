{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.magic-wormhole;
in
{
  options.programs.magic-wormhole = {
    enable = lib.mkEnableOption "magic-wormhole";
    package = lib.mkPackageOption pkgs "magic-wormhole-rs" { };
  };

  config = mkIf cfg.enable { home.packages = [ cfg.package ]; };
}
