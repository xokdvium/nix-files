{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = import ./. { inherit inputs pkgs; };
    };
}
