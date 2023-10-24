{lib, ...}: {
  programs.zathura = {
    enable = true;
  };

  stylix.targets.zathura.enable = lib.mkDefault true;
}
