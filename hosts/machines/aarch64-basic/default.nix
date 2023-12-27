{lib, ...}:
lib.makeOverridable ({system}:
    lib.mkHostInfo {
      inherit system;
      hostname = "aarch64-basic";
      nixosModules = [./configuration.nix];
      homeModules = [./home.nix];
    }) {system = "aarch64-linux";}
