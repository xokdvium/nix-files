_: {
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
        factorio.enable = true;
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
    stateVersion = "23.11";
  };
}
