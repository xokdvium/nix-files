{
  inputs,
  outputs,
  lib,
  config,
  extraConfig,
  ...
}: let
  wipeScript = ''
    echo "Erasing my darlings"
    zfs rollback -r rpool/nixos/root@blank
  '';

  wipeService = {
    description = "Rollback zfs root";
    wantedBy = ["initrd.target"];
    after = [
      "zfs-import-rpool.service"
    ];

    before = [
      "sysroot.mount"
    ];

    path = [config.boot.zfs.package];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = wipeScript;
  };

  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.xokdvium.nixos = {
    persistence = {
      enable = lib.mkEnableOption "persistence";

      wipeOnBoot = lib.mkOption {
        type = lib.types.bool;
        description = "Restore root dataset blank snapshot on reboot";
        default = false;
        example = true;
      };
    };
  };

  config = let
    cfg = config.xokdvium.nixos.persistence;
  in
    lib.mkIf
    cfg.enable
    {
      programs.fuse.userAllowOther = true;

      environment.persistence."/persistent" = {
        hideMounts = true;

        files = [
          "/etc/machine-id"
        ];

        users =
          (genUsers (_: {
            directories = [
              "Downloads"
              "Music"
              "Pictures"
              "Documents"
              "Videos"
              "Work"
              {
                directory = ".gnupg";
                mode = "0700";
              }
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
          }))
          // {
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

      system.activationScripts.persistent-dirs.text = let
        mkHomeDir = dir: user:
          lib.optionalString user.createHome ''
            mkdir -p /${dir}/${user.home}
            chown ${user.name}:${user.group} /${dir}/${user.home}
            chmod ${user.homeMode} /${dir}/${user.home}
          '';
        mkHomePersist = user: ((mkHomeDir "persistent" user) + (mkHomeDir "state" user));
        users = lib.attrValues config.users.users;
      in
        lib.concatLines (map mkHomePersist users);

      fileSystems = lib.mkIf (config.xokdvium.nixos.zfsHost.enable) {
        "/persistent".neededForBoot = true;
        "/state".neededForBoot = true;
      };

      boot.initrd =
        lib.mkIf
        (cfg.wipeOnBoot && config.xokdvium.nixos.zfsHost.enable)
        {
          systemd = {
            enable = true;
            services.wipe-root = wipeService;
          };
        };
    };
}
