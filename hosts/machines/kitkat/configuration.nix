{
  modulesPath,
  lib,
  config,
  extraConfig,
  ...
}: {
  imports = [
    ../../common/nix.nix
    ../../common/ssh.nix
    ../../common/sops.nix
    ../../common/fixes.nix
    ../../common/hostname.nix
    ../../common/locale.nix
    ../../common/users.nix

    ./networking.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # FIX: This is required for home-manager
  programs.dconf.enable = true;
  extraOptions = {
    immutableUsers.enable = true;
  };

  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes";
    };
  };

  networking = {
    domain = "firstbyte.club";
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
      };
    };

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
        "vmw_pvscsi"
      ];
    };

    kernelModules = ["nvme"];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
      "net.ipv4.conf.all.src_valid_mark" = "1";
    };
  };

  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  sops.secrets = {
    "wg-easy/password".sopsFile = extraConfig.host.secretsFile;
    "wg-easy/address".sopsFile = extraConfig.host.secretsFile;
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        wg-easy = {
          image = "weejewel/wg-easy";
          ports = [
            "51820:51820/udp"
            "51821:51821/tcp"
          ];

          volumes = [
            "/root/.wg-easy:/etc/wireguard"
          ];

          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--cap-add=SYS_MODULE"
          ];

          environmentFiles = [
            config.sops.secrets."wg-easy/password".path
            config.sops.secrets."wg-easy/address".path
          ];
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
