{ outputs, ... }:
let
  inherit (outputs.lib) mkHomeCategoryEnableOption;
in
{
  imports = [
    ./attic.nix
    ./atuin
    ./autojump.nix
    ./bat.nix
    ./bottom.nix
    ./btop.nix
    ./chaotic.nix
    ./comma.nix
    ./core.nix
    ./dev-tools.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./jj.nix
    ./macchina.nix
    ./nix-closure-graph.nix
    ./nix-melt.nix
    ./nurl.nix
    ./nushell.nix
    ./pueue.nix
    ./rust-tools.nix
    ./starship.nix
    ./tldr.nix
    ./wormhole.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
    ./zsh.nix
    ./riscv-isa-manual-glow.nix
  ];

  options.xokdvium.home.headless = {
    enable = mkHomeCategoryEnableOption "headless";
  };
}
