{ inputs, outputs, ... }:
let
  callLib = pathToLib: import pathToLib { inherit inputs outputs; };
in
rec {
  home = callLib ./home.nix;
  host = callLib ./host.nix;
  utils = callLib ./utils.nix;

  inherit (home)
    mkHomeDir
    mkHomeConfiguration
    mkUser
    mkHomeCategoryModuleEnableOption
    mkHomeCategoryEnableOption
    genUsers
    ;

  inherit (host) mkHostInfo mkHostSystem mkHostImage;

  inherit (utils) mkApp;

  units.size = rec {
    kb = 1024;
    mib = 1024 * kb;
    gib = 1024 * mib;
  };
}
