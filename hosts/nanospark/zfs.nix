{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha512" "nanospark");
  boot.supportedFilesystems = ["zfs"];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = ["zfs.zfs_arc_max=2147483648"];
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
}
