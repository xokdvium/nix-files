{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../.
  ];

  # https://github.com/nix-community/home-manager/issues/3263
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';

  home.packages = with pkgs.gnomeExtensions; [
  ];

  # https://github.com/Electrostasy/dots/blob/c62895040a8474bba8c4d48828665cfc1791c711/profiles/system/gnome/default.nix#L123-L287
  dconf.settings = with lib.gvariant; {
  };
}
