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

  services = {
    gnome.gnome-remote-desktop.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-terminal
    gnome-calendar
    gnome-calculator
    epiphany
    geary
    totem
    gnome-music
    gnome-characters
    gnome-contacts
    gnome-remote-desktop
  ];
}
