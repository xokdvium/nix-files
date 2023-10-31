{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../generic
    ../features/dewm/gnome.nix
    # Disk configuration and partitioning
    ../disko/zfsroot.nix
    inputs.disko.nixosModules.disko
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
      };

      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  zfsHost = {
    enable = true;
    arcSize = 1073741824;
  };

  persistence = {
    enable = true;
    wipeOnBoot = true;
  };

  system.stateVersion = "23.11";
}
