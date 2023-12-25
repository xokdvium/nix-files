{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    gvfs.enable = true;
  };

  stylix.targets = {
    gnome.enable = lib.mkForce false;
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      gnome-music
      gnome-terminal
      gnome-contacts
      gnome-calendar
      gnome-calculator
      epiphany
      geary
      gnome-characters
      totem
    ]);
}
