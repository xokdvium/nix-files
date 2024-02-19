# https://myme.no/posts/2022-12-01-nixos-on-raspberrypi.html
{pkgs, ...}: {
  imports = [
    ../../common
    ../../features/zerotier

    ./klipper.nix
    ./octoprint.nix
  ];

  xokdvium.nixos = {
    immutableUsers.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi3;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  networking = {
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };

    wireless = {
      interfaces = ["wlan0"];
      enable = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  system = {
    stateVersion = "24.05";
  };
}
