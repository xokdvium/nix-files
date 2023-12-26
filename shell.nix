{
  pkgs ?
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
    just
    act
    dig
  ];

  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
}
