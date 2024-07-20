{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.nix_2_23;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      sandbox = true;

      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      accept-flake-config = true;
    };
  };
}
