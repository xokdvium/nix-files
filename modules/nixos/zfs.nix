{
  config,
  lib,
  ...
}: let
  cfg = config.extraOptions.zfsHost;
in {
  options = {
    extraOptions.zfsHost = {
      enable = lib.mkEnableOption "zfsHost";

      arcSize = lib.mkOption {
        type = lib.types.int;
        description = "Size of ZFS adaptive replacement cache in bytes";
        default = 1024 * 1024 * 1024; # 1GiB
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      supportedFilesystems = [
        "zfs"
      ];

      kernelPackages = lib.mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;
      kernelParams = [
        "zfs.zfs_arc_max=${builtins.toString cfg.arcSize}"
      ];

      zfs.devNodes = "/dev/disk/by-partuuid";
    };

    services = {
      zfs = {
        trim.enable = true;
        autoScrub.enable = true;
      };
    };
  };
}
