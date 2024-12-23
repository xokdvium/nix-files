{
  inputs,
  extraConfig,
  config,
  hostModulesPath,
  pkgs,
  ...
}:

{
  imports =
    map (v: hostModulesPath + "/${v}") [
      "desktop"
      "features/dewm/gnome.nix"
      "features/dewm/hyprland.nix"
      "features/docker.nix"
      "features/crypto.nix"
      "features/zerotier"
      # "features/binfmt.nix"
      "features/gaming.nix"
      # "features/cachyos.nix"
      "features/github-token.nix"
      "features/latest-nix.nix"
    ]
    ++ [
      ./zfsroot.nix
      ./nvidia.nix
      inputs.disko.nixosModules.disko
    ];

  sops.secrets."binary-cache/private" = {
    sopsFile = extraConfig.host.secretsFile;
  };

  nix = {
    settings.extra-trusted-users = [ "builder" ];
    extraOptions = ''
      secret-key-files = ${config.sops.secrets."binary-cache/private".path}
    '';
  };

  xokdvium = {
    common = {
      style = {
        enable = true;
        preset = "eighties-spaceduck";
      };
    };

    nixos = {
      immutableUsers.enable = true;
      autoUpdate.enable = true;

      persistence = {
        enable = true;
        wipeOnBoot = true;
      };

      zfsHost = {
        enable = true;
        arcSize = 8 * pkgs.lib.units.size.gib;
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

  networking = {
    hostName = "nebulinx";
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        efiInstallAsRemovable = true;
        devices = [ "nodev" ];
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

    kernelModules = [ "kvm-amd" ];
    kernel = {
      sysctl = {
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
      };
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    graphics.enable = true;
    probe-rs-rules.enable = true;
  };

  nix.settings = {
    system-features = [
      "benchmark"
      "big-parallel"
      "kvm"
      "nixos-test"
      "gccarch-znver3"
    ];
  };

  users = {
    groups.builder = { };
  };

  system.stateVersion = "23.11";
}
