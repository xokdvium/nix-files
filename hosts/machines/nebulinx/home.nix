{
  xokdvium = {
    home = {
      persistence.enable = true;

      headless = {
        atuin = {
          noShellHistory = true;
          autoSync = true;
          enableZfsPatch = true;
        };

        dev-tools.enable = true;
      };

      desktop = {
        enable = true;
        gnome.enable = true;
        firefox = {
          staticBookmarks = true;
        };
        chromium.enable = true;
        gaming.enable = true;
        factorio.enable = false;
      };

      editors = {
        vscode.enable = true;
      };
    };

    common = {
      style = {
        enable = true;
        preset = "catppuccin-mocha";
      };
    };
  };

  home = {
    file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;
    stateVersion = "23.11";
  };
}
