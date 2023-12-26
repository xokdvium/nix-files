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
    ../../features/zerotier
    ../../features/zerotier/zeronsd.nix

    # Disk configuration and partitioning
    ./zfsroot.nix
    ./nvidia.nix
    inputs.disko.nixosModules.disko
  ];

  extraOptions = {
    immutableUsers.enable = true;
    persistence = {
      enable = true;
      wipeOnBoot = true;
    };

    zfsHost = {
      enable = true;
      arcSize = 4 * 1024 * 1024 * 1024; # 4 GiB
    };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        efiInstallAsRemovable = true;
        devices = ["nodev"];
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
    };

    kernelModules = ["kvm-amd"];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  system.stateVersion = "23.11";
}
