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
    ./deluge.nix
    ./vscode.nix
    ./cura.nix
    ./prusa-slicer.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
