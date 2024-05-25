{ pkgs, ... }:

{
  xokdvium = {
    home = {
      headless.enable = true;
      crypto.enable = true;
      desktop = {
        gnome.enable = true;
        okular.enable = true;
        firefox.enable = true;
      };
    };

    common = {
      style = {
        enable = true;
        preset = "catppuccin-mocha";
      };
    };
  };

  xdg.desktopEntries = {
    yubikey-guide = {
      name = "yubikey-guide";
      genericName = "Guide to using YubiKey for GPG and SSH";
      comment = "Open the guide in a reader program";
      categories = [ "Documentation" ];
      exec = "${pkgs.yubikey-guide}/bin/view-yubikey-guide";
    };
  };

  # NOTE: This does not really matter since this system is not supposed to
  # run any persistent services.
  home = {
    stateVersion = "24.05";
  };
}
