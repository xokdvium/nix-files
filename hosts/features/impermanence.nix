{
  inputs,
  lib,
  config,
  ...
}: let
  wipeScript = ''
    echo "Erasing my darlings"
    zfs rollback -r rpool/nixos/root@blank
  '';
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options = {
    persistence.enable = lib.mkEnableOption "persistence";
  };

  config = let
    cfg = config.persistence;
  in
    (lib.mkIf cfg.enable {
      programs.fuse.userAllowOther = true;

      environment.persistence."/persistent" = {
        hideMounts = true;

        files = [
          "/etc/machine-id"
          "/etc/passwd"
          "/etc/shadow"
        ];
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
    })
    // {
      # boot.initrd = {
      #   postDeviceCommands = lib.mkAfter wipeScript;
      # };
    };
}
