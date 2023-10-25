{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./firefox.nix
    ./stylix.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
