{lib, ...}: {
  programs.zathura = {
    enable = true;
  };

  stylix.targets.zathura.enable = lib.mkDefault true;

  xdg.mimeApps.defaultApplications = {
    "text/pdf" = ["zathura.desktop"];
    "x-scheme-handler/pdf" = ["zathura.desktop"];
  };
}
