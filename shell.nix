let
  lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);
  fetchTarballFromGithub =
    {
      owner,
      repo,
      lock ? lockFile.nodes.${repo}.locked,
    }:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
in
{
  pkgs ?
    let
      nixpkgs = fetchTarballFromGithub {
        owner = "nixos";
        repo = "nixpkgs";
      };
    in
    import nixpkgs { },
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
    nh
    glow
  ];

  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
