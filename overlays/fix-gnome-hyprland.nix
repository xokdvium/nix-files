# Fix GNOME xdg-desktop-portal
# https://discourse.nixos.org/t/ln-failed-to-create-symbolic-link-nix-store-user-units-xdg-desktop-portal-gtk-service-file-exists/53876/6

_final: prev: {
  xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (_old: {
    buildInputs = [
      prev.glib
      prev.gtk3
      prev.xdg-desktop-portal
      prev.gsettings-desktop-schemas
      prev.gnome-desktop
      prev.gnome-settings-daemon
    ];
    mesonFlags = [ ];
  });
}
