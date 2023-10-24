{lib, ...}: {
  nebulinx = lib.mkHostInfo {
    system = "x86_64-linux";
    hostname = "nebulinx";

    nixosModules = [
      ./nebulinx
    ];

    homeModules = [
      ../home/modules/desktop
      ../home/modules/desktop/gnome/default.nix
    ];
  };

  nanospark = lib.mkHostInfo {
    system = "x86_64-linux";
    hostname = "nanospark";

    nixosModules = [
      ./nanospark
    ];

    homeModules = [
      ../home/modules/headless
    ];
  };

  generic = lib.makeOverridable ({system}:
    lib.mkHostInfo {
      inherit system;
      hostname = "generic";

      nixosModules = [
        ./generic
      ];

      homeModules = [
        ../home/modules/headless
        ./generic/home.nix
      ];
    }) {system = "x86_64-linux";};

  airgapped = lib.makeOverridable ({system}:
    lib.mkHostInfo {
      inherit system;
      hostname = "airgapped";

      nixosModules = [
        ./airgapped
      ];

      homeModules = [
        ../home/modules/desktop
        ./airgapped/home.nix
      ];
    }) {system = "x86_64-linux";};
}
