{ lib, ... }:

lib.makeOverridable (
  { system }:
  lib.mkHostInfo {
    inherit system;
    nixosModules = [ ./nixos-modules/configuration.nix ];
    homeModules = [ ./home.nix ];
  }
) { system = "x86_64-linux"; }
