{inputs, ...}: {
  imports = [
    ./style.nix
    inputs.stylix.homeManagerModules.stylix
  ];
}
