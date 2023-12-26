{pkgs, ...}: {
  imports = [
    ../headless
    ../crypto

    ./alacritty.nix
    ./bitwarden.nix
    ./discord.nix
    ./firefox.nix
    ./stylix.nix
    ./style.nix
    ./telegram.nix
    ./tor-browser.nix
    ./zathura.nix
    ./wireshark.nix
    ./deluge.nix
    ./vscode.nix
    ./cura.nix
    ./prusa-slicer.nix
    ./freecad.nix
    ./obsidian.nix
    ./helix.nix
    ./termshark.nix
    ./visidata.nix
  ];

  home.packages = with pkgs; [
    ghostwriter
  ];
}
