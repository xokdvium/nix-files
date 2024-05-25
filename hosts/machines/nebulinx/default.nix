{ lib, ... }:

lib.mkHostInfo {
  system = "x86_64-linux";
  hostname = "nebulinx";
  disk = "/dev/disk/by-id/ata-WDC_WD10JUCT-63CYNY0_WD-WXK1E1586NVZ";
  secretsFile = ./secrets.yaml;
  nixosModules = [ ./configuration.nix ];
  homeModules = [ ./home.nix ];
}
