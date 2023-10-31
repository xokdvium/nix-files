{lib, ...}: {
  nebulinx = lib.mkHostInfo {
    system = "x86_64-linux";
    hostname = "nebulinx";
    disk = "/dev/disk/by-id/ata-WDC_WD10JUCT-63CYNY0_WD-WXK1E1586NVZ";
    secretsFile = ./nebulinx/secrets.yaml;

    nixosModules = [
      ./nebulinx
    ];

    homeModules = [
      ../home/modules/desktop/gnome
      ./nebulinx/home.nix
    ];
  };

  vivobook = lib.mkHostInfo {
    system = "x86_64-linux";
    hostname = "vivobook";
    disk = "/dev/disk/by-id/nvme-KINGSTON_OM8PDP3256B-AB1_50026B76856BE00C";
    secretsFile = ./vivobook/secrets.yaml;

    nixosModules = [
      ./vivobook
    ];

    homeModules = [
      ../home/modules/desktop/gnome
      ./vivobook/home.nix
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
