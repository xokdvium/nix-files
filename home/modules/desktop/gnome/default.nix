_: {
  imports = [
    ../.
  ];

  # https://github.com/nix-community/home-manager/issues/3263
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}
