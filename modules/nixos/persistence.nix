{
  inputs,
  lib,
  config,
  ...
}:

let
  wipeScript = ''
    echo "Erasing my darlings"
    zfs rollback -r rpool/nixos/root@blank
  '';

  wipeService = {
    description = "Rollback zfs root";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];

    before = [ "sysroot.mount" ];

    path = [ config.boot.zfs.package ];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = wipeScript;
  };
in

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.xokdvium.nixos = {
    persistence =
      let
        commonOptions = {
          dirs = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.str);
            description = "List of directories to persist";
            default = [ ];
          };

          files = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.str);
            description = "List of files to persist";
            default = [ ];
          };

          defaultDirs = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.str);
            description = "Default dirs to persist";
            default = [ ];
          };
        };
      in
      {
        enable = lib.mkEnableOption "persistence";

        wipeOnBoot = lib.mkOption {
          type = lib.types.bool;
          description = "Restore root dataset blank snapshot on reboot";
          default = false;
          example = true;
        };

        hideMounts = lib.mkOption {
          type = lib.types.bool;
          description = "Hide mounts";
          default = false;
          example = false;
        };

        state = {
          path = lib.mkOption {
            type = lib.types.path;
            internal = true;
            description = "Path to persisted files that are private to the machine (like docker images)";
            default = "/state";
          };

          defaultFiles = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.str);
            description = "Default files to persist";
            default = [ ];
          };
        } // commonOptions;

        persist = {
          path = lib.mkOption {
            type = lib.types.path;
            internal = true;
            description = "Path to persisted files that might be worth backing up";
            default = "/persistent";
          };

          defaultFiles = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.str);
            description = "Default files to persist";
            default = [ "/etc/machine-id" ];
          };
        } // commonOptions;
      };
  };

  config =
    let
      cfg = config.xokdvium.nixos.persistence;
    in
    lib.mkIf cfg.enable {
      programs.fuse.userAllowOther = true;

      environment.persistence = {
        "${cfg.persist.path}" = {
          hideMounts = cfg.hideMounts;
          files = cfg.persist.files ++ cfg.persist.defaultFiles;
          directories = cfg.persist.dirs ++ cfg.persist.defaultDirs;

          # (FIXME): Make this configurable. Root is not managed by 
          # home-manager yet. Maybe it would be worthwhile to define root
          # user just like all other users?
          users = {
            root = {
              home = "/root";
              directories = [
                {
                  directory = ".ssh";
                  mode = "0700";
                }
              ];
            };
          };
        };

        "${cfg.state.path}" = {
          hideMounts = cfg.hideMounts;
          files = cfg.state.files ++ cfg.state.defaultFiles;
          directories = cfg.state.dirs ++ cfg.state.defaultDirs;
        };
      };

      system.activationScripts.persistent-dirs.text =
        let
          mkHomeDir =
            dir: user:
            lib.optionalString user.createHome ''
              mkdir -p /${dir}/${user.home}
              chown ${user.name}:${user.group} /${dir}/${user.home}
              chmod ${user.homeMode} /${dir}/${user.home}
            '';
          mkHomePersist = user: ((mkHomeDir "persistent" user) + (mkHomeDir "state" user));
          users = builtins.filter (user: user.isNormalUser) (lib.attrValues config.users.users);
        in
        lib.concatLines (map mkHomePersist users);

      fileSystems = lib.mkIf (config.xokdvium.nixos.zfsHost.enable) {
        "${cfg.persist.path}".neededForBoot = true;
        "${cfg.state.path}".neededForBoot = true;
      };

      boot.initrd = lib.mkIf (cfg.wipeOnBoot && config.xokdvium.nixos.zfsHost.enable) {
        systemd = {
          enable = true;
          services.wipe-root = wipeService;
        };
      };
    };
}
