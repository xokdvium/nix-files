_: {
  xokdvium = {
    home = {
      persistence.enable = true;

      headless = {
        atuin = {
          noShellHistory = true;
          autoSync = true;
        };

        dev-tools.enable = true;
      };

      desktop = {
        enable = true;
        gnome.enable = true;
        hyprland.enable = true;
        firefox = {
          staticBookmarks = true;
        };
      };

      editors = {
        vscode.enable = true;
      };
    };

    common = {
      style = {
        enable = true;
        preset = "helios";
      };
    };
  };

  home = {
    file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;
    stateVersion = "23.11";
  };
}
