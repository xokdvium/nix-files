# https://myme.no/posts/2022-12-01-nixos-on-raspberrypi.html
{
  lib,
  outputs,
  extraConfig,
  ...
}: let
  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    ../../common
    ./klipper.nix
    ./octoprint.nix
  ];

  users = {
    mutableUsers = true;
    users = genUsers (_: {
      initialPassword = "";
    });
  };

  networking = {
    useDHCP = lib.mkDefault true;

    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };

    wireless = {
      interfaces = ["wlan0"];
      enable = true;
    };
  };
}
