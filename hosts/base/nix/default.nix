{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.nix_2_20.overrideAttrs (
      final: prev: { patches = [ ./0001-make-attic-work.patch ]; }
    );

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      sandbox = true;

      substituters = [
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org/"
        "https://helix.cachix.org/"
        "https://nixpkgs-wayland.cachix.org/"
        "https://nixpkgs-update.cachix.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
      ];
    };
  };
}
