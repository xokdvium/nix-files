{outputs, ...}: let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in {
  imports = [
    ./autojump.nix
    ./bat.nix
    ./comma.nix
    ./core.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./impermanence.nix
    ./wormhole.nix
    ./zsh.nix
    ./starship.nix
    ./zellij.nix
    ./yazi.nix
    ./atuin.nix
  ];

  options.xokdvium.home.headless = {
    enable = mkHomeCategoryEnableOption "headless";
  };
}
