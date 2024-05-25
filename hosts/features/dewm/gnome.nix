{ pkgs, ... }:

{
  imports = [ ./common ];
  services = {
    displayManager = {
      defaultSession = "gnome-xorg";
    };
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.peripherals.touchpad]
          tap-to-click=true
        '';
      };
    };

    gvfs.enable = true;
  };

  stylix.targets = {
    gnome.enable = true;
  };

  environment.gnome.excludePackages =
    (with pkgs; [ gnome-tour ])
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
