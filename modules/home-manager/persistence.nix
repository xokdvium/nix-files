{
  inputs,
  lib,
  config,
  ...
}:

{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  options.xokdvium.home = {
    persistence =
      let
        commonOptions = {
          dirs = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "List of directories to persist";
            default = [ ];
          };

          files = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "List of files to persist";
            default = [ ];
          };
        };
      in
      {
        enable = lib.mkEnableOption "persistence";

        hideMounts = lib.mkOption {
          type = lib.types.bool;
          description = "Hide mounts";
          default = true;
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
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "Default files to persist";
            default = [ ];
          };

          defaultDirs = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "Default dirs to persist";
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
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "Default files to persist";
            default = [ "/etc/machine-id" ];
          };

          defaultDirs = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.attrs lib.types.string);
            description = "Default dirs to persist";

            default = [
              ".cache/nix"
              ".gnupg"
              ".ssh"
              "Downloads"
              "Music"
              "Pictures"
              "Documents"
              "Videos"
              "Work"
            ];
          };
        } // commonOptions;
      };
  };

  config =
    let
      cfg = config.xokdvium.home.persistence;
    in
    lib.mkIf cfg.enable {
      home.persistence = {
        "${cfg.persist.path}/home/${config.home.username}" = {
          allowOther = true;
          files = cfg.persist.files ++ cfg.persist.defaultFiles;
          directories = cfg.persist.dirs ++ cfg.persist.defaultDirs;
        };

        "${cfg.state.path}/home/${config.home.username}" = {
          allowOther = true;
          files = cfg.state.files ++ cfg.state.defaultFiles;
          directories = cfg.state.dirs ++ cfg.state.defaultDirs;
        };
      };
    };
}
