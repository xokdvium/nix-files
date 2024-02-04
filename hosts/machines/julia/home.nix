{
  lib,
  pkgs,
  ...
}: {
  xokdvium = {
    home = {
      headless.enable = true;
    };

    common = {
      style.enable = true;
    };
  };

  programs.eza = {
    icons = lib.mkForce false;
  };

  home = {
    packages = with pkgs; [
      libraspberrypi
      wget
      htop
    ];
    stateVersion = "24.05";
  };
}
