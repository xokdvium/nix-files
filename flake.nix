{
  description = "My NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.follows = "chaotic/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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
      inputs.flake-compat.follows = "flake-compat";
    };

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

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    nix-eval-jobs = {
      url = "github:nix-community/nix-eval-jobs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-compat.follows = "flake-compat";
    };

    project-templates = {
      url = "github:xokdvium/project-templates";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      flake = false;
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };

    riscv-isa-manual-glow = {
      url = "github:xokdvium/riscv-isa-manual-glow";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };

  outputs =
    {
      self,
      treefmt-nix,
      flake-parts,
      project-templates,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      let
        inherit (self) outputs;
        lib = nixpkgs.lib.extend (_: _: import ./lib { inherit inputs outputs; });
        hosts = import ./hosts { inherit lib; };
        users = import ./hosts/users { inherit lib; };

        additionalSpecialArgs = {
          hostModulesPath = "${self}/hosts";
        };
      in
      {
        imports = [
          treefmt-nix.flakeModule
          flake-parts.flakeModules.easyOverlay
          ./packages/top.nix
          ./overlays
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        flake = {
          lib = import ./lib { inherit inputs outputs; };
          homeManagerModules = import ./modules/home-manager;
          nixosModules = import ./modules/nixos;
          templates = project-templates.templates;

          nixosConfigurations = {
            nebulinx = lib.mkHostSystem {
              users = {
                inherit (users) xokdvium builder;
              };
              host = hosts.nebulinx;
              inherit additionalSpecialArgs;
            };

            vivobook = lib.mkHostSystem {
              users = {
                inherit (users) xokdvium;
              };
              host = hosts.vivobook;
              inherit additionalSpecialArgs;
            };
          };
        };

        perSystem =
          { system, ... }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = builtins.attrValues outputs.overlays;
            };

            imports = [
              ./flake/treefmt.nix
              ./flake/devshell.nix
            ];

            packages = {
              installer = lib.mkHostImage {
                format = "install-iso";
                host = hosts.generic;
                users = {
                  inherit (users) xokdvium;
                };
                inherit additionalSpecialArgs;

              };

              airgapped = lib.mkHostImage {
                format = "iso";
                users = {
                  inherit (users) xokdvium;
                };
                host = hosts.airgapped;
                inherit additionalSpecialArgs;
              };
            };
          };
      }
    );
}
