{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Home Manager module
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix

    ./locale
    ./nix
  ];

  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
