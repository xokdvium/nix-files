{
  inputs,
  outputs,
  ...
}: let
  callLib = pathToLib:
    import pathToLib {
      inherit inputs outputs;
    };
in rec {
  home = callLib ./home.nix;
  host = callLib ./host.nix;
  utils = callLib ./utils.nix;
  lints = callLib ./lints.nix;

  inherit
    (home)
    mkHomeDir
    mkHomeConfiguration
    mkUser
    mkHomeCategoryModuleEnableOption
    mkHomeCategoryEnableOption
    genUsers
    ;

  inherit
    (host)
    mkHostInfo
    mkHostSystem
    mkHostImage
    ;

  inherit
    (utils)
    mkApp
    ;
}
