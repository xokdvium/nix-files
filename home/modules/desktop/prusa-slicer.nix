{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [prusa-slicer];
}
