{
  description = "My NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:xokdvium/stylix/dev/init-yazi";
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
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.flake-utils.follows = "flake-utils";
      inputs.lint-nix.follows = "lint-nix";
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
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    project-templates,
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
    additionalSpecialArgs = {
      hostModulesPath = "${self}/hosts";
    };
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
      templates = project-templates.templates;

      nixosConfigurations = {
        nebulinx = lib.mkHostSystem {
          users = {inherit (users) xokdvium builder;};
          host = hosts.nebulinx;
          inherit additionalSpecialArgs;
        };

        vivobook = lib.mkHostSystem {
          users = {inherit (users) xokdvium;};
          host = hosts.vivobook;
          inherit additionalSpecialArgs;
        };
      };

      nixConfig = {
        extra-substituters = ["https://attic.aeronas.ru/private/"];
        extra-trusted-public-keys = ["private:IvY1j71q2NBKHzakkPgOgP/OCVjKw7XNsPL1OV1umNU="];
      };

      lib = import ./lib {inherit inputs outputs;};
    };
}
