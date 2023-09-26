{pkgs, ...}: {
  imports = [
    ./cli
    ./kitty
    ./fonts
  ];

  home.packages = with pkgs; [
    bitwarden
  ];
}
