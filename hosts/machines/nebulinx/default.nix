{ lib, ... }:

lib.mkHostInfo {
  system = "x86_64-linux";
  disk = "/dev/disk/by-id/ata-WDC_WD10JUCT-63CYNY0_WD-WXK1E1586NVZ";
  secretsFile = ./secrets.yaml;
  nixosModules = [ ./nixos-modules/configuration.nix ];
  homeModules = [ ./home.nix ];
}
