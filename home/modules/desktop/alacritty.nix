{lib, ...}: {
  programs.alacritty = {
    enable = true;
  };

  stylix.targets.alacritty.enable = lib.mkDefault true;
}
