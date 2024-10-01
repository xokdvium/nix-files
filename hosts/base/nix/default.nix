{ pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixVersions.nix_2_23;

    settings = {
      auto-optimise-store = true;
      sandbox = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [ "https://cache.nixos.org/" ];
      trusted-substituters = [
        "https://helix.cachix.org"
        "https://microvm.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # https://www.github.com/NixOS/nix/issues/6672#issuecomment-1920721589
      # IMPORTANT: Use best security practices when it comes to nix trusted-users
      # and accept-flake-config. They effectively make you passwordless root, so
      # these features should never be used (at least for desktops).
      trusted-users = lib.mkForce [ "root" ];
      accept-flake-config = lib.mkForce false;
    };
  };
}
