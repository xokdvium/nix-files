{extraConfig, ...}: let
  inherit (extraConfig.host) system;
in {
  imports = [
    ./locale.nix
    ./nix.nix
    ./stylix.nix
    ./users.nix
    ./yubikey.nix
    ./hostname.nix
    ./fixes.nix
  ];

  nixpkgs.hostPlatform = system;
  system.stateVersion = "23.11";
}
