{
  imports = [
    ../../users/mail
    ../../../modules/home-manager/desktop/hyprland
  ];

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
        nekoray.enable = true;
        hiddify-next.enable = true;
        icon = {
          enable = true;
          icon = ../../../images/icon.png;
        };
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
