{
  inputs,
  outputs,
  lib,
  pkgs,
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

    path = with pkgs; [
      zfs
    ];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = wipeScript;
  };

  genUsers = outputs.lib.genUsers extraConfig.users;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.extraOptions = {
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
    cfg = config.extraOptions.persistence;
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

        users = genUsers (_: {
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
        });
      };

      system.activationScripts.persistent-dirs.text = let
        mkHomePersist = user:
          lib.optionalString user.createHome ''
            mkdir -p /persistent/${user.home}
            chown ${user.name}:${user.group} /persistent/${user.home}
            chmod ${user.homeMode} /persistent/${user.home}
          '';
        users = lib.attrValues config.users.users;
      in
        lib.concatLines (map mkHomePersist users);

      fileSystems."/persistent" = {
        neededForBoot = true;
      };

      boot.initrd =
        lib.mkIf
        cfg.wipeOnBoot
        {
          systemd = {
            enable = true;
            services.wipe-root = wipeService;
          };
        };
    };
}
