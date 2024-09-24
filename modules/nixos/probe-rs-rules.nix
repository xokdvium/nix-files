# https://github.com/jneem/probe-rs-rules
# Not my code, but it's vendored and reworked somewhat.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.probe-rs-rules;
in

{
  options.hardware.probe-rs-rules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mkDoc "Add udev permissions for various probes.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs; [ probe-rs-rules ];
  };
}
