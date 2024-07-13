{ pkgs, config, ... }:

{
  devShells = {
    default = config.devShells.bootstrap;
    bootstrap = pkgs.mkShell {
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
    };
  };
}
