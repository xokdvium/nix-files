{lib, ...}:
lib.makeOverridable ({system}:
    lib.mkHostInfo {
      inherit system;
      hostname = "generic";
      nixosModules = [./configuration.nix];
      homeModules = [./home.nix];
    }) {system = "x86_64-linux";}
