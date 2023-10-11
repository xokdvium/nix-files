{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../../features/common.nix
  ];

  home = {
    username = lib.mkDefault "xokdvium";
    homeDirectory = lib.mkDefault "/home/xokdvium";
    stateVersion = lib.mkDefault "23.05";
  };
}
