# This file defines overlays
{inputs, ...}: {
  additions = final: _: import ../packages {pkgs = final;};
  helix-master = import ./helix.nix {inherit inputs;};
  hyprland-master = import ./hyprland.nix {inherit inputs;};
  nixpkgs-wayland = inputs.nixpkgs-wayland.overlay;
  attic = inputs.attic.overlays.default;
  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
}
