# This file defines overlays
{inputs, ...}: {
  additions = final: _: import ../packages {pkgs = final;};
  visidata-fix = import ./visidata-fix.nix {inherit inputs;};
  helix-master = import ./helix.nix {inherit inputs;};
}
