# This file defines overlays
{inputs, ...}: {
  additions = final: prev: import ../packages {pkgs = prev;};

  library = final: prev: let
    libx = import ../lib {pkgs = prev;};
  in {
    lib = prev.lib // libx;
  };
}
