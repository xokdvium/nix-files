{pkgs}: let
  inherit (pkgs) callPackage;
in {
  yubikey-guide = callPackage ./yubikey-guide.nix {};
  yk-scripts = callPackage ./yk-scripts.nix {};
  gpg-scripts = callPackage ./gpg-scripts.nix {};
}
