{
  imports = [
    ../../users/mail
    ../../../modules/home-manager/desktop/hyprland
    ../../../modules/home-manager/desktop/hyprland/nvidia.nix
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
        gaming.enable = true;
        factorio.enable = false;
        nekoray.enable = false;
        hiddify-next.enable = true;
      };

      editors = {
        vscode.enable = true;
      };
    };

    common = {
      style = {
        enable = true;
        preset = "eighties-spaceduck";
      };
    };
  };

  home = {
    file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;
    stateVersion = "23.11";
  };
}
