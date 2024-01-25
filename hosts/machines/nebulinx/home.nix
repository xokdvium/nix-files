_: {
  xokdvium = {
    home = {
      persistence.enable = true;
      desktop = {
        enable = true;
      };

      editors = {
        vscode.enable = true;
      };
    };

    common = {
      style.preset = "spaceduck";
    };
  };

  home = {
    file.".config/monitors.xml".text = builtins.readFile ./monitors.xml;
    stateVersion = "23.11";
  };
}
