{lib, ...}:
lib.mkHostInfo {
  system = "aarch64-linux";
  hostname = "julia";
  secretsFile = ./secrets.yaml;
  nixosModules = [./configuration.nix];
  homeModules = [./home.nix];
}
