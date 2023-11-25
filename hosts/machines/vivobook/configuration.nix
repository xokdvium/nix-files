{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../common

    ../../features/dewn/hyprland.nix
    ../../features/dewm/gnome.nix
    ../../features/quietboot.nix
    ../../features/crypto.nix
    ../../features/docker.nix

    ./zfsroot.nix
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
      arcSize = 1024 * 1024 * 1024; # 1 GiB
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
      };
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
    };

    kernelModules = ["kvm-intel"];
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

  system.stateVersion = "23.11";
}
