{ ... }:

{
  xokdvium = {
    home = {
      headless.enable = true;
    };

    common = {
      style.enable = true;
    };
  };

  # NOTE: This does not really matter since this system is not supposed to
  # run any persistent services.
  home = {
    stateVersion = "24.05";
  };
}
