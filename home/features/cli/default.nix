{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./git
    ./neovim
  ];

  home.packages = with pkgs; let
    system = pkgs.system;
  in [
    inputs.nh.packages.${system}.default

    bitwarden-cli # Password manager
  ];
}
