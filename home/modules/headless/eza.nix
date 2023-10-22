{lib, ...}: {
  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = lib.mkDefault true;
  };
}
