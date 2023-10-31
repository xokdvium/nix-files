{extraConfig, ...}: let
  inherit (extraConfig.host) disk;
in {
  disko.devices = {
    disk.main = {
      device = disk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          swap = {
            size = "32G";
            content = {
              type = "swap";
              randomEncryption = true;
              resumeDevice = true;
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";

        rootFsOptions = {
          acltype = "posixacl";
          compression = "lz4";
          dnodesize = "auto";
          relatime = "on";
          xattr = "sa";
          checksum = "edonr";
        };

        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "nixos" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
            };
          };

          "nixos/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };

          "nixos/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot rpool/nixos/root@blank";
          };

          "nixos/persistent" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persistent";
          };
        };
      };
    };
  };
}
