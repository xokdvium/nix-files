{ pkgs, lib, ... }:

let
  helix-git-blame = pkgs.writeShellApplication {
    name = "helix-git-blame";
    runtimeInputs = with pkgs; [
      ripgrep
      zellij
      git
      choose
      bash
    ];
    text = builtins.readFile ./helix-git-blame.sh;
  };
in

{
  programs.helix.settings = {
    keys.normal = {
      space.B = ":sh ${lib.getExe helix-git-blame}";
    };
  };
}
