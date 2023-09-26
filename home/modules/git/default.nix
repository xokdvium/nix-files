{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.colorScheme) colors;
in {
  programs.git = {
    enable = true;

    aliases = let
      commit_msg = "'[chore]: Temporary save point'";
      pretty_branch_cmd =
        "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) "
        + "- %(contents:subject) %(color:green)(%(committerdate:relative)) "
        + "[%(authorname)]' --sort=-committerdate";
      pretty_log_cmd =
        "!git log --pretty=format:'%C(magenta)%h%Creset "
        + "-%C(red)%d%Creset %s %C(dim green)(%cr) [%an]' --abbrev-commit -30";
    in {
      st = "status";
      co = "checkout";
      cob = "checkout -b";
      cm = "commit -m";
      del = "branch -D";
      br = "${pretty_branch_cmd}";
      save = "!git add -A && git commit -m ${commit_msg}";
      undo = "reset HEAD~1 --mixed";
      res = "!git reset --hard";
      lg = "${pretty_log_cmd}";
    };

    userEmail = lib.mkDefault "145775305+xokdvium@users.noreply.github.com";
    userName = lib.mkDefault "Sergei Zimmerman";

    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
      push = {autoSetupRemote = true;};
    };
  };
}
