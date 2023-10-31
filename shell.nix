# Courtesy to https://github.com/Misterio77
# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs ?
  # If pkgs is not defined, instantiate nixpkgs from locked commit
  with builtins; let
    lockFile = fromJSON (readFile ./flake.lock);
    lock = lockFile.nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {},
  ...
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git
    sops
    gnupg
    ssh-to-pgp
  ];

  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
}
