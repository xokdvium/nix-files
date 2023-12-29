{lib, ...}:
lib.mkHostInfo {
  system = "x86_64-linux";
  hostname = "kitkat";
  secretsFile = ./secrets.yaml;
  nixosModules = [./configuration.nix];
  homeModules = [./home.nix];
}
