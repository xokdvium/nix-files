{ lib, ... }:

{
  imports = [
    ./primary.nix
    ./secondary.nix
  ] ++ (lib.optionals (builtins.pathExists ./sensitive.nix) [ ./sensitive.nix ]);
}
