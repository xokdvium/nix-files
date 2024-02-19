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

  users.users = genUsers (_: {
    initialPassword = "";
  });

  networking.useDHCP = lib.mkDefault true;

  boot = {
    initrd.systemd.enable = lib.mkForce false;
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
