{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.magic-wormhole = {
    enable = true;
  };
}
