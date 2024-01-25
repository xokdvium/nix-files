{
  outputs,
  config,
  lib,
  ...
}: let
  inherit
    (outputs.lib)
    mkHomeCategoryModuleEnableOption
    ;
in {
  options.xokdvium.home.headless = {
    git.enable = mkHomeCategoryModuleEnableOption config {
      name = "git";
      category = "headless";
    };
  };

  config = let
    cfg = config.xokdvium.home.headless.git;
  in
    lib.mkIf cfg.enable {
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

        userEmail = lib.mkDefault "serjtsimmerman@gmail.com";
        userName = lib.mkDefault "Sergei Zimmerman";

        extraConfig = {
          init = {defaultBranch = "main";};
          pull = {rebase = true;};
          push = {autoSetupRemote = true;};
        };

        delta = {
          enable = true;
          options = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
            colorMoved = "default";
            features = "coracias-caudatus";
          };
        };
      };
    };
}
