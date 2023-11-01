{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./bitwarden.nix
    ./discord.nix
    ./firefox.nix
    ./stylix.nix
    ./telegram.nix
    ./tor-browser.nix
    ./zathura.nix
    ./wireshark.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
