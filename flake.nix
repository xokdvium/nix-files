{
  description = "My NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

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
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    project-templates = {
      url = "github:xokdvium/project-templates";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
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
        imports = [ treefmt-nix.flakeModule ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        flake = {
          lib = import ./lib { inherit inputs outputs; };
          homeManagerModules = import ./modules/home-manager;
          nixosModules = import ./modules/nixos;
          overlays = import ./overlays { inherit inputs outputs; };
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

          homeConfigurations =
            let
              setNixModule =
                { pkgs, ... }:
                {
                  nix.package = pkgs.nix;
                };
            in
            {
              "xokdvium@nebulinx" = lib.mkHomeConfiguration {
                user = users.xokdvium;
                host = hosts.nebulinx;
                modules = [ setNixModule ];
                inherit additionalSpecialArgs;
              };

              "xokdvium@vivobook" = lib.mkHomeConfiguration {
                user = users.xokdvium;
                host = hosts.vivobook;
                modules = [ setNixModule ];
                inherit additionalSpecialArgs;
              };

              "xokdvium@generic" = lib.mkHomeConfiguration {
                user = users.xokdvium;
                host = hosts.generic;
                modules = [ setNixModule ];
                inherit additionalSpecialArgs;
              };
            };
        };

        perSystem =
          {
            pkgs,
            inputs',
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = builtins.attrValues outputs.overlays;
            };

            imports = [ ./treefmt.nix ];
            devShells = rec {
              bootstrap = import ./shell.nix {
                inherit pkgs;
                inherit (inputs'.nh.packages) nh;
              };
              default = bootstrap;
            };

            packages = (import ./packages { inherit pkgs; }) // {
              installer = lib.mkHostImage {
                format = "install-iso";
                host = hosts.generic;
                users = {
                  inherit (users) xokdvium;
                };
              };

              airgapped = lib.mkHostImage {
                format = "iso";
                users = {
                  inherit (users) xokdvium;
                };
                host = hosts.airgapped;
              };
            };
          };
      }
    );
}
