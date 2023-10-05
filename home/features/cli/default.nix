{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (inputs) nix-index-database;
in {
  imports = [
    nix-index-database.hmModules.nix-index

    ./autojump
    ./eza
    ./fzf
    ./git
    ./neovim
    ./rbw
    ./zsh
  ];

  home.packages = with pkgs; let
    inherit (pkgs) system;
  in [
    inputs.nh.packages.${system}.default

    ascii-image-converter # Generate ascii art from images
    librsvg # SVG renderer
    tig # Git repo viewer
    libqalculate # Amazing CLI calculator
    qrcp # Transfer files to a phone via Wi-Fi
    hyperfine # Benchmarking utility
    ncdu # NCurses based disk usage
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };
}
