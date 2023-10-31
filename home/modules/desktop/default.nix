{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./bitwarden.nix
    ./discord.nix
    ./firefox.nix
    ./libreoffice.nix
    ./stylix.nix
    ./telegram.nix
    ./tor-browser.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
