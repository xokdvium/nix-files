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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;

    hostConfigurations = {
      nixosConfigurations = {
        nanospark = nixpkgs.lib.nixosSystem {
          modules = [./hosts/nanospark];
          specialArgs = {inherit inputs outputs;};
        };
      };
    };

    homeManagerConfigurations = {
      homeConfigurations = {
        "sergeiz@nebulinx" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [./home/sergeiz/nebulinx.nix];
        };

        "xokdvium@nanospark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [./home/xokdvium/nanospark.nix];
        };
      };
    };

    systems = ["x86_64-linux" "aarch64-linux"];
    attrsForEachSystem = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = import ./packages {inherit pkgs;};
      devShells = import ./shell.nix {inherit pkgs;};
      formatter = pkgs.alejandra;
    });
  in
    {
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays {inherit inputs;};
      lib = import ./lib;
    }
    // attrsForEachSystem
    // hostConfigurations
    // homeManagerConfigurations;
}
