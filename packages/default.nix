{ pkgs, inputs, ... }:
let
  inherit (pkgs) callPackage;
in
{
  yubikey-guide = callPackage ./yubikey-guide.nix { };
  yk-scripts = callPackage ./yk-scripts.nix { };
  gpg-scripts = callPackage ./gpg-scripts.nix { };
  zeronsd = callPackage ./zeronsd.nix { };
  zerotier-systemd-manager = callPackage ./zerotier-systemd-manager.nix { };
  nix-closure-graph = callPackage ./nix-closure-graph.nix { };
  npm-groovy-lint = callPackage ./npm-groovy-lint.nix { dream2nix = inputs.dream2nix; };
}
