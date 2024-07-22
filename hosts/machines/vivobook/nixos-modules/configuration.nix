{
  inputs,
  pkgs,
  hostModulesPath,
  ...
}:

{
  imports =
    map (v: hostModulesPath + "/${v}") [
      "desktop"
      "features/dewm/gnome.nix"
      "features/quietboot.nix"
      "features/crypto.nix"
      "features/docker.nix"
      "features/zerotier"
      "features/systemd-networkd.nix"
      "features/distributed-builds"
    ]
    ++ [
      ./zfsroot.nix
      inputs.disko.nixosModules.disko
      inputs.nixos-hardware.nixosModules.asus-battery
    ];

  xokdvium = {
    common = {
      style = {
        enable = true;
        preset = "catppuccin-mocha";
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
        arcSize = pkgs.lib.units.size.gib;
        snapshots.enable = true;
        replication.enable = true;
      };
    };
  };

  networking = {
    hostName = "vivobook";
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
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

    kernelModules = [ "kvm-intel" ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;

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
