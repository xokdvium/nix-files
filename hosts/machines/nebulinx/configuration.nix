{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../common

    ../../features/dewm/gnome.nix
    ../../features/docker.nix
    ../../features/quietboot.nix
    ../../features/crypto.nix

    # Disk configuration and partitioning
    ./zfsroot.nix

    inputs.disko.nixosModules.disko
  ];

  extraOptions = {
    immutableUsers.enable = true;
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        efiInstallAsRemovable = true;
      };
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [];
    };

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;

    # https://nixos.wiki/wiki/Nvidia
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = false;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  zfsHost = {
    enable = true;
    arcSize = 2147483648;
  };

  persistence = {
    enable = true;
    wipeOnBoot = true;
  };

  virtualisation.docker = {
    enableNvidia = true;
  };

  system.stateVersion = "23.11";
}
