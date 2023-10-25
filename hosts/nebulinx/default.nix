_: {
  imports = [
    ../common

    ../features/dewm/gnome.nix
    ../features/crypto.nix
    ../features/impermanence.nix

    ./hardware-configuration.nix
    ./zfs.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };

      efi.canTouchEfiVariables = true;
    };
  };

  persistence.enable = true;
  system.stateVersion = "23.11";
}
