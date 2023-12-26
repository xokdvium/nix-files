{lib, ...}:
lib.mkHostInfo {
  system = "x86_64-linux";
  hostname = "borg";
  nixosModules = [./configuration.nix];
  homeModules = [./home.nix];
}
