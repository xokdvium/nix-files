{inputs, ...}: {
  imports = [
    ../../desktop

    ../../features/dewm/gnome.nix
    ../../features/docker.nix
    ../../features/quietboot.nix
    ../../features/crypto.nix
    ../../features/zerotier
    ../../features/binfmt.nix
    ../../features/clamav.nix
    ../../features/dnscrypt.nix

    # Disk configuration and partitioning
    ./zfsroot.nix
    ./nvidia.nix
    inputs.disko.nixosModules.disko
  ];

  nix.settings.trusted-users = [
    "builder"
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
        arcSize = 4 * 1024 * 1024 * 1024; # 4 GiB
        snapshots.enable = true;
        replication = {
          enable = true;
          enableDebug = true;
        };
      };
    };
  };

  services = {
    xserver.displayManager.gdm.autoSuspend = false;
  };

  # https://discourse.nixos.org/t/why-is-my-new-nixos-install-suspending/19500
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

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
