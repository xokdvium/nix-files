{
  pkgs,
  outputs,
  config,
  lib,
  ...
}:
let
  inherit (outputs.lib) mkHomeCategoryModuleEnableOption;

  deltaTheme = pkgs.writeText "delta-stylix-base16.gitconfig" (
    lib.generators.toGitINI {
      "delta \"stylix-base16\"" = with config.lib.stylix.colors.withHashtag; {
        dark = true;
        line-numbers = true;
        syntax-theme = "base16-stylix";
        zero-style = "syntax";
        plus-style = "syntax";
        plus-emph-style = ''"${base00}" "${base0B}"'';
        minus-style = "syntax";
        minus-emph-style = ''"${base00}" "${base08}"'';
        blame-palette = "${base00} ${base01}";
        file-style = "${base0D}";
        line-numbers-minus-style = "${base08}";
        line-numbers-plus-style = "${base0B}";
      };
    }
  );
in
{
  options.xokdvium.home.headless = {
    git.enable = mkHomeCategoryModuleEnableOption config {
      name = "git";
      category = "headless";
    };
  };

  config =
    let
      cfg = config.xokdvium.home.headless.git;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        git-absorb
        onefetch
      ];

      programs = {
        git = {
          enable = true;

          aliases =
            let
              commit_msg = "'[chore]: Temporary save point'";
              pretty_branch_cmd =
                "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) "
                + "- %(contents:subject) %(color:green)(%(committerdate:relative)) "
                + "[%(authorname)]' --sort=-committerdate";
              pretty_log_cmd =
                "!git log --pretty=format:'%C(magenta)%h%Creset "
                + "-%C(red)%d%Creset %s %C(dim green)(%cr) [%an]' --abbrev-commit -30";
            in
            {
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
            init = {
              defaultBranch = "main";
            };
            pull = {
              rebase = true;
            };
            push = {
              autoSetupRemote = true;
            };
            core = {
              fsmonitor = "${pkgs.rs-git-fsmonitor}/bin/rs-git-fsmonitor";
            };
          };

          includes = [ { path = deltaTheme; } ];

          delta = {
            enable = true;
            options = {
              navigate = true;
              line-numbers = true;
              colorMoved = "default";
              features = "stylix-base16";
            };
          };
        };

        nushell.shellAliases = {
          gst = "git status";
          gl = "git pull";
          gaa = "git add --all";
          gp = "git push";
          gpf = "git push --force-with-lease --force-if-includes";
        };
      };

      xdg.configFile."delta/stylix-base16.gitconfig".source = deltaTheme;
    };
}
