{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../../global
  ];

  home = {
    username = lib.mkDefault "xokdvium";
    homeDirectory = lib.mkDefault "/home/xokdvium";
    stateVersion = lib.mkDefault "23.05";
  };
}
