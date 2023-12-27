{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../home/modules/headless
  ];

  stylix.autoEnable = false;
  programs.eza = {
    icons = lib.mkForce false;
  };

  home.packages = with pkgs; [
    libraspberrypi
    wget
    htop
  ];
}
