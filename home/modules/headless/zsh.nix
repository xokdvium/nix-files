{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    thefuck
    navi
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck"];
      theme = "robbyrussell";
    };
  };
}
