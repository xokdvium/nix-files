{ lib, ... }:

lib.mkHostInfo {
  system = "x86_64-linux";
  disk = "/dev/disk/by-id/nvme-KINGSTON_OM8PDP3256B-AB1_50026B76856BE00C";
  secretsFile = ./secrets.yaml;
  nixosModules = [ ./configuration.nix ];
  homeModules = [ ./home.nix ];
}
