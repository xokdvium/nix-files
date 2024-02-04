{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../desktop

    ../../features/dewm/hyprland.nix
    ../../features/dewm/gnome.nix
    ../../features/quietboot.nix
    ../../features/crypto.nix
    ../../features/docker.nix
    ../../features/zerotier
    ../../features/dnscrypt.nix
    ../../features/distributed-builds.nix

    ./zfsroot.nix
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.asus-battery
  ];

  xokdvium = {
    common = {
      style = {
        enable = true;
        preset = "spaceduck";
      };
    };

    nixos = {
      immutableUsers.enable = true;
      persistence = {
        enable = true;
        wipeOnBoot = true;
      };

      zfsHost = {
        enable = true;
        arcSize = 1024 * 1024 * 1024; # 1 GiB
        snapshots.enable = true;
        replication.enable = true;
      };
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

    # FIXME: Currently latest kernel is broken.
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_6_5;
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

    asus.battery = {
      chargeUpto = 75;
      enableChargeUptoScript = true;
    };
  };

  system.stateVersion = "23.11";
}
