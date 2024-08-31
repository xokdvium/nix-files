{
  nixpkgs = {
    overlays = [ (_final: prev: { nix = prev.nixVersions.nix_2_24; }) ];
  };
}
