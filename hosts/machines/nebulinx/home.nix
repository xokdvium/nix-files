_: let
  monitorsConfig = builtins.readFile ./monitors.xml;
in {
  imports = [
    ../../../home/modules/desktop/gnome
  ];

  extraOptions = {
    persistence.enable = true;
  };

  home = {
    file.".config/monitors.xml".text = monitorsConfig;
  };
}
