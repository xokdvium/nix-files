_: {
  imports = [
    ../common
    ../features/dewm/gnome.nix
    ../features/crypto.nix
    ./hardware-configuration.nix
    ./zfs.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  home-manager.verbose = true;
}
