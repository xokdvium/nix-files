{ lib, ... }:

lib.makeOverridable (
  { system }:
  lib.mkHostInfo {
    inherit system;
    hostname = "airgapped";
    nixosModules = [ ./configuration.nix ];
    homeModules = [ ./home.nix ];
  }
) { system = "x86_64-linux"; }
