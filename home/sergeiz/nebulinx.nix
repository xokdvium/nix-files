{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [../xokdvium/nebulinx.nix];
  home = {
    username = lib.mkForce "sergeiz";
    homeDirectory = lib.mkForce "/home/sergeiz/";
  };
}
