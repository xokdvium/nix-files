{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    thefuck
    navi
  ];

  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;
      enableAutosuggestions = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "thefuck"];
      };
    };
  };

  home.persistence."/persistent/home/${config.home.username}" = lib.mkIf config.extraOptions.persistence.enable {
    files = [".zsh_history"];
  };
}
