{
  inputs,
  extraConfig,
  config,
  hostModulesPath,
  ...
}:
{
  imports =
    map (v: hostModulesPath + "/${v}") [
      "desktop"
      "features/dewm/gnome.nix"
      "features/docker.nix"
      "features/quietboot.nix"
      "features/crypto.nix"
      "features/zerotier"
      "features/binfmt.nix"
      "features/dnscrypt.nix"
      # "features/cachyos.nix"
      "features/gaming.nix"
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
        preset = "catppuccin-macchiato";
      };
    };

    nixos = {
      immutableUsers.enable = true;
      autoUpdate.enable = true;

      persistence = {
        enable = true;
        wipeOnBoot = true;
      };

      zfsHost =
        let
          gibibyte = 1024 * 1024 * 1024;
        in
        {
          enable = true;
          arcSize = 8 * gibibyte;
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

  users = {
    groups.builder = { };
  };

  system.stateVersion = "23.11";
}
