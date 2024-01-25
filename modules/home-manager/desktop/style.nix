{pkgs, ...}: {
  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.catppuccin-papirus-folders;
  };
}
