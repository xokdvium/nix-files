{ pkgs, config, ... }:

{
  devShells = {
    default = config.devShells.bootstrap;
    bootstrap = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
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
        git-secret
      ];

      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    };
  };
}
