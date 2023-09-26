# This file defines overlays
{ inputs, ... }: {
  additions = final: prev: import ../packages { pkgs = final; };
}
