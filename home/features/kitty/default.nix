{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
  };

  stylix.targets.kitty.enable = true;
}
