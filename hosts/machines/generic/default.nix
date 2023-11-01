{lib, ...}:
lib.makeOverridable ({system}:
    lib.mkHostInfo {
      inherit system;
      hostname = "generic";
      secretsFile = ./secrets.yaml;
      nixosModules = [./configuration.nix];
      homeModules = [./home.nix];
    }) {system = "x86_64-linux";}
