{
  lib,
  outputs,
  inputs,
  ...
}: let
  excludedFlakes = [
  ];
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0" # FIXME: Remove this when obsidian gets bumped
      ];
    };

    overlays = builtins.attrValues outputs.overlays;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      trusted-users = ["root" "@wheel"];
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

    registry =
      lib.genAttrs
      (builtins.filter (name: !builtins.elem name excludedFlakes) (builtins.attrNames inputs))
      (name: {flake = inputs.${name};});
  };
}
