{extraConfig, ...}: let
  inherit (extraConfig.host) system;
in {
  imports = [
    ./fixes.nix
    ./home-manager.nix
    ./hostname.nix
    ./locale.nix
    ./network-manager.nix
    ./nix.nix
    ./sops.nix
    ./ssh.nix
    ./stylix.nix
    ./users.nix
    ./xkblayout.nix
  ];

  nixpkgs.hostPlatform = system;
  system.stateVersion = "23.11";
}