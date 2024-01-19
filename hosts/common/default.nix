_: {
  imports = [
    ../base
    ./network-manager.nix
    ./stylix.nix
    ./xkblayout.nix
    ./swraid.nix
    ./man.nix
  ];

  system.stateVersion = "23.11";
}
