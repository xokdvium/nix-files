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

      snapshots = {
        enable = lib.mkEnableOption "snapshots";
        enableDebug = lib.mkEnableOption "enableDebug";
      };

      replication = {
        enable = lib.mkEnableOption "replication";
        enableDebug = lib.mkEnableOption "enableDebug";

        deleteOldSnapshots = lib.mkOption {
          type = lib.types.bool;
          description = "Delete target snapshots that are not present locally";
          default = true;
        };
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

    sops.secrets = lib.mkIf cfg.replication.enable {
      "syncoid/private-key" = {
        owner = "syncoid";
        sopsFile = ../../secrets/syncoid/secrets.yaml;
      };
    };

    services = {
      zfs = {
        trim.enable = true;
        autoScrub.enable = true;
      };

      sanoid = lib.mkIf cfg.snapshots.enable {
        enable = true;
        extraArgs = lib.optionals (cfg.snapshots.enableDebug) [
          "--verbose"
          "--debug"
        ];

        datasets = let
          monthlyCount = 12;
          hourlyCount = 48;
          dailyCount = 31;
        in {
          "rpool/nixos/persistent" = lib.mkIf config.extraOptions.persistence.enable {
            autosnap = true;
            autoprune = true;
            recursive = true;
            monthly = monthlyCount;
            hourly = hourlyCount;
            daily = dailyCount;
          };
        };
      };

      syncoid = lib.mkIf cfg.replication.enable {
        enable = true;
        commonArgs =
          []
          ++ lib.optionals (cfg.replication.enableDebug) [
            "--debug"
            "--dumpsnaps"
          ]
          ++ lib.optionals (cfg.replication.deleteOldSnapshots) [
            "--delete-target-snapshots"
          ];

        sshKey = config.sops.secrets."syncoid/private-key".path;

        commands = {
          "backup2aeronas" = {
            source = "rpool/nixos/persistent";
            target = "syncoid@aeronas.jawphungy.home.arpa:stank/backups/machines/${config.networking.hostName}";
            sendOptions = "--raw";
            recursive = true;
            # FIXME: Do proper host key checking
            extraArgs = ["--sshoption=StrictHostKeyChecking=off"];
          };
        };
      };
    };
  };
}
