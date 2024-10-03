{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.xokdvium.nixos.zfsHost;
in

{
  options = {
    xokdvium.nixos.zfsHost = {
      enable = lib.mkEnableOption "zfsHost";

      arcSize = lib.mkOption {
        type = lib.types.int;
        description = "Size of ZFS adaptive replacement cache in bytes";
        default = lib.units.size.gib;
      };

      rootPoolName = lib.mkOption {
        type = lib.types.str;
        description = "Name of the root pool";
        default = "rpool";
      };

      statePoolName = lib.mkOption {
        type = lib.types.str;
        description = "Name of the root pool";
        default = "rpool";
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
      supportedFilesystems = [ "zfs" ];
      kernelParams = [ "zfs.zfs_arc_max=${builtins.toString cfg.arcSize}" ];
      zfs.devNodes = "/dev/disk/by-partuuid";
    };

    sops.secrets = lib.mkIf cfg.replication.enable {
      "syncoid/private-key" = {
        owner = "syncoid";
        sopsFile = ../../secrets/syncoid/secrets.yaml;
      };
    };

    environment.systemPackages = with pkgs; [
      httm # interactive cli file history via zfs
    ];

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

        datasets =
          let
            monthlyCount = 4;
            hourlyCount = 12;
            dailyCount = 14;

            snapshotSettings = {
              autosnap = true;
              autoprune = true;
              recursive = true;
              monthly = monthlyCount;
              hourly = hourlyCount;
              daily = dailyCount;
            };
          in
          {
            "${cfg.statePoolName}/nixos/persistent" = lib.mkIf config.xokdvium.nixos.persistence.enable snapshotSettings;
          };
      };

      syncoid = lib.mkIf cfg.replication.enable {
        enable = true;

        localTargetAllow = lib.optionals (cfg.replication.deleteOldSnapshots) [ "destroy" ];

        commonArgs =
          [ ]
          ++ lib.optionals (cfg.replication.enableDebug) [
            "--debug"
            "--dumpsnaps"
          ]
          ++ lib.optionals (cfg.replication.deleteOldSnapshots) [ "--delete-target-snapshots" ];

        sshKey = config.sops.secrets."syncoid/private-key".path;

        commands = {
          "backup2aeronas" = {
            source = "${cfg.statePoolName}/nixos/persistent";
            target = "syncoid@aeronas.zt.breathein.space:stank/backups/machines/${config.networking.hostName}";
            sendOptions = "--raw";
            recursive = true;
            # FIXME: Do proper host key checking
            extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
          };
        };
      };
    };
  };
}
