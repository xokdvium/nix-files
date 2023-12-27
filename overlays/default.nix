# This file defines overlays
{inputs, ...}: {
  additions = final: _: import ../packages {pkgs = final;};
  # FIXME: No binary cache for aarch64-linux and there's no builder
  # helix-master = import ./helix.nix {inherit inputs;};
  hyprland-master = import ./hyprland.nix {inherit inputs;};
  nixpkgs-wayland = inputs.nixpkgs-wayland.overlay;
}
