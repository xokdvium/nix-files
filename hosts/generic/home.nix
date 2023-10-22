{lib, ...}: {
  programs.eza = {
    icons = lib.mkForce false;
  };
}
