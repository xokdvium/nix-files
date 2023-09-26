{
  description = "My NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Manage my user configurations. Preferable to NixOS modules
    # because I might still use other distros
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cool cli wrapper for flakes
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs"; # override this repo's nixpkgs snapshot
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.legacyPackages;
  in {
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs;};

    packages = forEachSystem (pkgs: import ./packages {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      nanospark = lib.nixosSystem {
        modules = [./hosts/nanospark];
        specialArgs = {inherit inputs outputs;};
      };
    };

    homeConfigurations = {
      "sergeiz@nebulinx" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/sergeiz/nebulinx.nix];
      };

      "xokdvium@nanospark" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/xokdvium/nanospark.nix];
      };
    };
  };
}
