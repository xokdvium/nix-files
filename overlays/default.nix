# This file defines overlays
{ inputs, ... }:

{
  additions =
    final: _:
    import ../packages {
      pkgs = final;
      inherit inputs;
    };
  helix-master = import ./helix.nix { inherit inputs; };
  hyprland-master = import ./hyprland.nix { inherit inputs; };
  attic = inputs.attic.overlays.default;
  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
  nixd-main = import ./nixd-main.nix { inherit inputs; };
  yazi-main = inputs.yazi.overlays.default;
  obsidian-fix = import ./obsidian-fix.nix { inherit inputs; };
}
