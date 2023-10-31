# https://github.com/NixOS/nixpkgs/issues/263839
{inputs, ...}: (_: prev: let
  pkgs = inputs.nixpkgs-stable.legacyPackages.${prev.system};
in {
  inherit (pkgs) visidata;
})
