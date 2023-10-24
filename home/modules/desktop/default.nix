{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./stylix.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
