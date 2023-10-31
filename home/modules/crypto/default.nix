{pkgs, ...}: {
  imports = [
    ./gpg.nix
    ./yubikey.nix
  ];

  home.packages = with pkgs; [
    pwgen
    diceware
    cryptsetup
    paperkey
    pinentry-curses
    age
  ];
}
