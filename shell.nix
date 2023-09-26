# Courtesy to https://github.com/Misterio77
# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs ?
  # If pkgs is not defined, instantiate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
    ];
  };
}
