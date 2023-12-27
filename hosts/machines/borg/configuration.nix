{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    ../../common

    ../../features/zerotier
    ../../features/zerotier/zeronsd.nix
    ../../features/zerotier/zeronsd.nix

    ./networking.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  extraOptions = {
    immutableUsers.enable = true;
    persistence = {
      enable = true;
    };
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
  };

  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  system.stateVersion = "23.11";
}
