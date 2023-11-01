{lib, ...}: {
  imports = [
    ../../common
    ../../features/crypto.nix
  ];

  networking.useDHCP = lib.mkDefault true;
}
