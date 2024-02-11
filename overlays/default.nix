# This file defines overlays
{inputs, ...}: {
  additions = final: _: import ../packages {pkgs = final;};
  helix-master = import ./helix.nix {inherit inputs;};
  hyprland-master = import ./hyprland.nix {inherit inputs;};
  nixpkgs-wayland = inputs.nixpkgs-wayland.overlay;
  base16-schemes = import ./base16-schemes.nix {inherit inputs;};
}
