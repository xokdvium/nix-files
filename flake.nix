{
  description = "My NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperml/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-eval-jobs = {
      url = "github:nix-community/nix-eval-jobs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-eval-jobs.follows = "nix-eval-jobs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    lint-nix.url = "github:xc-jp/lint.nix";
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
    users = import ./hosts/users {inherit lib;};

    images = {
      installer = {
        format = "install-iso";
        users = {inherit (users) xokdvium;};
        host = hosts.generic;
      };

      airgapped = {
        format = "iso";
        users = {inherit (users) xokdvium;};
        host = hosts.airgapped;
      };

      aarch64-basic = {
        format = "sd-aarch64";
        users = {inherit (users) admin;};
        host = hosts.aarch64-basic;
      };
    };

    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues outputs.overlays;
      };

      packages = import ./packages {inherit pkgs;};
      lints = lib.lints pkgs ./.;
    in {
      packages =
        packages
        // {
          installer = lib.mkHostImage images.installer;
          airgapped = lib.mkHostImage images.airgapped;
        }
        // lib.attrsets.optionalAttrs (system == "aarch64-linux") {
          aarch64-basic = lib.mkHostImage images.aarch64-basic;
        };

      legacyPackages = {} // lints;

      formatter = pkgs.alejandra;

      devShells = rec {
        bootstrap = import ./shell.nix {
          inherit pkgs;
          inherit (inputs.nh.packages.${system}) nh;
        };
        default = bootstrap;
      };
    })
    // {
      homeManagerModules = import ./modules/home-manager;
      nixosModules = import ./modules/nixos;
      overlays = import ./overlays {inherit inputs outputs;};

      templates = {
        cpp = {
          path = ./templates/cpp;
          description = "C++ project template";
        };

        ruby = {
          path = ./templates/ruby;
          description = "Ruby project template";
        };

        rust = {
          path = ./templates/rust;
          description = "Rust project template";
        };
      };

      nixosConfigurations = {
        nebulinx = lib.mkHostSystem {
          users = {inherit (users) xokdvium builder;};
          host = hosts.nebulinx;
        };

        vivobook = lib.mkHostSystem {
          users = {inherit (users) xokdvium;};
          host = hosts.vivobook;
        };

        julia = lib.mkHostSystem {
          users = {inherit (users) admin;};
          host = hosts.julia;
        };
      };

      homeConfigurations = {};

      lib = import ./lib {inherit inputs outputs;};
    };
}
