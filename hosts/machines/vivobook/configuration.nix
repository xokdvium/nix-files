{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../common

    ../../features/dewm/gnome.nix
    ../../features/quietboot.nix
    ../../features/crypto.nix
    ../../features/docker.nix

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
