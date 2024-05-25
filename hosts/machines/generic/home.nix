{ lib, ... }:

{
  xokdvium = {
    home = {
      headless.enable = true;
    };

    common = {
      style.enable = true;
    };
  };

  programs.eza = {
    icons = lib.mkForce false;
  };

  # NOTE: This does not really matter since this system is not supposed to
  # run any persistent services.
  home = {
    stateVersion = "24.05";
  };
}
