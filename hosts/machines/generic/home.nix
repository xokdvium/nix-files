{lib, ...}: {
  imports = [
    ../../../home/modules/headless
  ];

  programs.eza = {
    icons = lib.mkForce false;
  };
}
