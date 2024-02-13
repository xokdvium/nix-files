{
  symlinkJoin,
  callPackage,
}: let
  time = callPackage ./time.nix {};
in
  symlinkJoin {
    name = "eww-widgets-tree";
    paths = [time];
  }
