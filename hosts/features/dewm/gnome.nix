{
  pkgs,
  lib,
  config,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.touchpad]
        tap-to-click=true
      '';
    };
  };

  stylix.targets = {
    gnome.enable = lib.mkForce false;
  };
}
