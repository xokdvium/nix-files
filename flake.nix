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
    nixos-generators.url = "github:nix-community/nixos-generators";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib.extend (_: _: import ./lib {inherit inputs outputs;});
    hosts = import ./hosts {inherit lib;};
    users = import ./home/users {inherit lib;};
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues outputs.overlays;
      };

      packages = import ./packages {inherit pkgs;};
      scripts = import ./scripts {inherit inputs outputs pkgs;};

      images = {
        installer = lib.mkHostImage {
          format = "install-iso";
          users = {inherit (users) xokdvium;};
          host = hosts.generic;
        };

        airgapped = lib.mkHostImage {
          format = "iso";
          users = {inherit (users) xokdvium;};
          host = hosts.airgapped;
        };
      };
    in {
      packages =
        packages
        // scripts
        // images;

      apps = rec {
        switch = lib.mkApp "${scripts.switch}/bin/switch";
        default = switch;
      };

      formatter = pkgs.alejandra;
    })
    // {
      homeManagerModules = import ./modules/home-manager;
      nixosModules = import ./modules/nixos;
      overlays = import ./overlays {inherit inputs outputs;};

      nixosConfigurations = {
        nanospark = lib.nixosSystem {
          modules = [./hosts/nanospark];
          specialArgs = {inherit inputs outputs;};
        };
      };

      homeConfigurations = {
        "sergeiz@nebulinx" = lib.mkHomeConfiguration {
          user = users.sergeiz;
          host = hosts.nebulinx;
        };

        "xokdvium@nanospark" = lib.mkHomeConfiguration {
          user = users.xokdvium;
          host = hosts.nanospark;
        };
      };
    };
}
