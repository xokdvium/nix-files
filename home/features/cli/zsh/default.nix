{
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];

  home.packages = with pkgs; [
    bat
    thefuck
    navi
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
    };

    plugins = [
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k;
        file = ".p10k.zsh";
      }
    ];
    zplug = {
      enable = true;
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = ["as:theme" "depth:1"];
        }
        {
          name = "plugins/git";
          tags = ["from:oh-my-zsh"];
        }
        {
          name = "fdellwing/zsh-bat";
        }
      ];
    };
  };
}
