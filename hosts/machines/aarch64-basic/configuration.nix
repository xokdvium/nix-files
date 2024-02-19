# https://myme.no/posts/2022-12-01-nixos-on-raspberrypi.html
{
  lib,
  outputs,
  extraConfig,
  pkgs,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    ../../common
  ];

  sdImage.compressImage = false;
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes";
    };
  };

  users = {
    mutableUsers = true;
    users = genUsers (_: {
      initialPassword = "";
    });
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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

  system = {
    stateVersion = "24.05";
  };
}
