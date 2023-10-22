{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./stylix.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
